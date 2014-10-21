Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbaJUHYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 03:24:51 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:11995 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaJUHYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 03:24:50 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-44-54460a3e415c
Message-id: <54460A3D.6010101@samsung.com>
Date: Tue, 21 Oct 2014 09:24:45 +0200
From: =?UTF-8?B?S3J6eXN6dG9mIEtvesWCb3dza2k=?= <k.kozlowski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>, Mark Brown <broonie@kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] ARM: EXYNOS: Call regulator suspend prepare/finish
References: <1413839151-10875-1-git-send-email-javier.martinez@collabora.co.uk>
In-reply-to: <1413839151-10875-1-git-send-email-javier.martinez@collabora.co.uk>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t/xy7p2XG4hBt3tZhZTHz5hs7j+5Tmr
	xdllB9ksjv4usHj9wtCid8FVNotNj6+xWlzeNYfNYsb5fUwWq3b9YXTg8pjdcJHF4+/z6ywe
	O2fdZffYtKqTzWPzknqPvi2rGD0+b5ILYI/isklJzcksSy3St0vgylj0ahlbQa9Axc6T15ka
	GL/ydDFyckgImEi0rD7IBGGLSVy4t56ti5GLQ0hgKaPExe5fjBDOZ0aJz/cPgFXxCmhJHLu/
	CsxmEVCVmLl6IzuIzSbgITHtew8ziC0qECFxZc0cRoh6QYkfk++xgNgiAikSz1fPYQEZyizQ
	xCTxsXE/WJGwgJ/ErTMTwIqEBPwlPs37ydrFyMHBKRAgce2NFojJLKAuMWVKLkgFs4C8xOY1
	b5knMArMQrJhFkLVLCRVCxiZVzGKppYmFxQnpeca6RUn5haX5qXrJefnbmKExMPXHYxLj1kd
	YhTgYFTi4Y1Y4hoixJpYVlyZe4hRgoNZSYT3bwxQiDclsbIqtSg/vqg0J7X4ECMTB6dUA2P0
	p17umho7H/fjFp9a7BalruVe3pCwnidi432XReVZv6VWlqsqbop13u3i9zlJLLl882fbHotG
	8SLnrm2VN7uW7GhpaZ3iGrb5wmsL7vq+nUfC+FJTb6qs0j+5/f0dBYeT/6+tXFdn8fZQyHPh
	nt7VVz2qNLa2fPh1/nXs3615WipX9a4e7ldiKc5INNRiLipOBABk4dm4ZQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.10.2014 23:05, Javier Martinez Canillas wrote:
> Hello,
> 
> This series add support for Exynos platforms to prepare regulators for
> system suspend. The regulator core has a set of helpers functions to be
> used when the system is entering and leaving from a suspend state but
> currently there is only one user in mainline.
> 
> This user is drivers/mfd/sec-core.c but it calls regulator_suspend_prepare()
> from within the driver power-management suspend function. This does not
> seems to be correct since the regulator suspend prepare function affects all
> regulators in the system and not only the ones managed by this device.
> 
> So patch #1 in this series revert the commit that introduced that change and
> patch #2 calls the regulator framework suspend/finish functions from the
> Exynos platform power-management code. The first patch should be queued through
> the mfd tree and the second through the linux-samsung tree.
> 
> Changes since v2:
>  - Check for regulator_suspend_finish() return value for an error.
>    Suggested by Doug Anderson.
> 
> Changes since v1:
>  - Remove the call to regulator_suspend_prepare() from drivers/mfd/sec-core.c
>    as suggested by Doug Anderson.
>  - Call regulator_suspend_prepare() before s3c_pm_check_prepare() as suggested
>    by Doug Anderson.
>  - Added Lee Jones to cc list since there is a change for the mfd framework.
> 
> Javier Martinez Canillas (2):
>   Revert "mfd: sec-core: Prepare regulators for suspend state to reduce
>     power-consumption"
>   ARM: EXYNOS: Call regulator core suspend prepare and finish functions
> 
>  arch/arm/mach-exynos/suspend.c | 23 +++++++++++++++++++++++
>  drivers/mfd/Kconfig            |  1 -
>  drivers/mfd/sec-core.c         | 10 ----------
>  3 files changed, 23 insertions(+), 11 deletions(-)

Patchset tested on Trats2 board (Exynos4412 with max77686 PMIC, modified
DTS to disable buck[134] during suspend to RAM).

Tested-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof


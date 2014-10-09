Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbaJIIqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 04:46:12 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:34661 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027AbaJIIqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 04:46:00 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f776d000003e54-cd-54364b446fb8
Content-transfer-encoding: 8BIT
Message-id: <1412844355.1316.15.camel@AMDC1943>
Subject: Re: [PATCH 3/5] regulator: dt-bindings: Add regulator-initial-mode
 support
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Mark Brown <broonie@kernel.org>, Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Date: Thu, 09 Oct 2014 10:45:55 +0200
In-reply-to: <1412775847-15213-4-git-send-email-javier.martinez@collabora.co.uk>
References: <1412775847-15213-1-git-send-email-javier.martinez@collabora.co.uk>
 <1412775847-15213-4-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t/xy7ou3mYhBrcOaVpMffiEzeL6l+es
	FvOPnGO1OLvsIJvF0d8FFmv+Kllc3jWHzWLG+X1MFqeuf2azmP9gB7MDl8fshossHn+fX2fx
	2DnrLrvHplWdbB5XTjSxevydtZ/Fo2/LKkaPz5vkAjiiuGxSUnMyy1KL9O0SuDJ6JrSzFPSK
	Vsxec4a5gXGLYBcjJ4eEgInEqU372SBsMYkL99aD2UICSxklpuw3BLF5BQQlfky+x9LFyMHB
	LCAvceRSNkiYWUBdYtK8RcxdjFxA5Z8ZJR7OfsgCUa8vcb3vItgcYYFQidUtL8FsNgFjic3L
	l4DZIgJ2EjdWPwRrZhY4ySRxa/kKsGYWAVWJzmkzmEFsToEAiS9nn7FDbJjKKLF//WFGkCsk
	BJQlGvvdJjAKzEJy3yyE+2YhuW8BI/MqRtHU0uSC4qT0XCO94sTc4tK8dL3k/NxNjJDY+LqD
	cekxq0OMAhyMSjy8D/6ZhgixJpYVV+YeYpTgYFYS4U31NAsR4k1JrKxKLcqPLyrNSS0+xMjE
	wSnVwJjJWspZv8nzcQ375fL9ds+WTX6WZ1Tv5nazgO/YtKib+7/UvtIQXXhT7OJGm+M+TC/f
	vziwOG6v2a6QmXEmmi9eqLf8U40333pxXpvPZN40X/V+jhmtZt9Nr9h/UtjiePUuh1KNXfzL
	mxXnDlSetOqZVtVivlHba9lzg90Lug/dXfHtK1vaQjslluKMREMt5qLiRAB9hsRIawIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-10-08 at 15:44 +0200, Javier Martinez Canillas wrote:
> Regulators can run on different operating modes (opmodes). This allows
> systems to choose the most efficient opmode for each regulator. The
> regulator core defines a set of generic modes so each system can define
> the opmode in these generic terms and drivers are responsible to map the
> generic modes to the ones supported by each hardware according to their
> data-sheet.
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
>  Documentation/devicetree/bindings/regulator/regulator.txt | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt b/Documentation/devicetree/bindings/regulator/regulator.txt
> index ccba90b..a9d6767 100644
> --- a/Documentation/devicetree/bindings/regulator/regulator.txt
> +++ b/Documentation/devicetree/bindings/regulator/regulator.txt
> @@ -23,6 +23,14 @@ Optional properties:
>    state among following defined suspend states:
>    <3>: PM_SUSPEND_MEM - Setup regulator according to regulator-state-mem
>    <4>: PM_SUSPEND_MAX - Setup regulator according to regulator-state-disk
> +- regulator-initial-mode: initial regulator operating mode. One of following:
> +	<1>: REGULATOR_MODE_FAST    - Regulator can handle fast changes.
> +	<2>: REGULATOR_MODE_NORMAL  - Normal regulator power supply mode.
> +	<4>: REGULATOR_MODE_IDLE    - Regulator runs in a more efficient mode.
> +	<8>: REGULATOR_MODE_STANDBY - Regulator runs in the most efficient mode.
> +  modes are defined in the dt-bindings/regulator/regulator.h header and can be
> +  used in device tree sources files. If no mode is defined, then the OS will not
> +  manage the operating mode and the HW default values will be used instead.
>  - regulator-state-mem sub-root node for Suspend-to-RAM mode
>    : suspend to memory, the device goes to sleep, but all data stored in memory,
>    only some external interrupt can wake the device.

I agree with the need and the idea of generic bindings for operating
modes for regulators. At least for Exynos-based boards the PMICs have
quite similar opmodes.

However the regulator mode from consumer.h (and in above doc) does not
match well with these opmodes. Example is yours patch 4/5:
 - idle ("more efficient mode") maps to "low power mode in suspend",
 - standby ("the most efficient mode") maps to "OFF in suspend".

Actually we are not enable "efficient modes" but we configure how the
regulator will behave when AP says - I'm suspending.


Another issue: is "initial_state" not doing all this already?

Best regards,
Krzysztof



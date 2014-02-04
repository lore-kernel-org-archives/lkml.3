Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbaBDN66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 08:58:58 -0500
Received: from 19.mo3.mail-out.ovh.net ([178.32.98.231]:33120 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753239AbaBDN6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 08:58:55 -0500
Message-ID: <52F0F06D.6000704@overkiz.com>
Date: Tue, 04 Feb 2014 14:51:41 +0100
From: Boris BREZILLON <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: Re: [PATCH 0/3] clk: at91: various fixes and improvements
References: <1391426731-9392-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1391426731-9392-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 17327036617219733532
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrjedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrjedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Mike,

Please do not take this series: the prog clk driver is still buggy (this was
reported by Jean-Jacques Hiblot).

Jean-Jacques is preparing a new series to fix these bugs, and I'll rebase
patch 2 and 3 of this series on top of his work.

Sorry for the inconvenience.

Best Regards,

Boris

On 03/02/2014 12:25, Boris BREZILLON wrote:
> Hello Mike,
>
> This series fixes a bug in the prog clk prepare function (the platform hangs
> when preparing a prog clk).
>
> It also implements the determine_rate callback for these prog clks and allow
> system clk to propagate the rate change to its parent.
>
> These modifications are needed to get the atmel_wm8904 driver working (this
> driver make use of prog clks), and if possible, should be merged in the next
> 3.14 release (at least the first patch of this series).
>
> Let me know if this is not possible.
>
> Thanks.
>
> Best Regards,
>
> Boris
>
> Boris BREZILLON (3):
>    clk: at91: fix programmable clk irq handling
>    clk: at91: replace prog clk round_rate with determine_rate
>    clk: at91: propagate rate change on system clks
>
>   drivers/clk/at91/clk-programmable.c |   61 ++++++++++++++++++-----------------
>   drivers/clk/at91/clk-system.c       |    3 +-
>   2 files changed, 34 insertions(+), 30 deletions(-)
>


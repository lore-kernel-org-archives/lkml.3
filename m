Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab3GJIhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 04:37:35 -0400
Received: from multi.imgtec.com ([194.200.65.239]:8060 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab3GJIhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 04:37:32 -0400
Message-ID: <51DD1D46.2000001@imgtec.com>
Date: Wed, 10 Jul 2013 09:37:26 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Chris Ball <cjb@laptop.org>, Olof Johansson <olof@lixom.net>,
        "Jaehoon Chung" <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        "Grant Grundler" <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/5] mmc: dw_mmc: Add suspend_noirq/resume_noirq callbacks
 for dw_mmc-pltfm
References: <1373391071-6312-1-git-send-email-dianders@chromium.org> <1373411961-23812-1-git-send-email-dianders@chromium.org> <1373411961-23812-3-git-send-email-dianders@chromium.org>
In-Reply-To: <1373411961-23812-3-git-send-email-dianders@chromium.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_07_10_09_37_27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

On 10/07/13 00:19, Doug Anderson wrote:
> On some devices (like exynos5420) the dw_mmc controller may be in a
> strange state after we wake up from sleep.  Add callbacks to allow for
> dealing with these quirks.  We use the "_noirq" versions of the
> callbacks since in the case of exynos5420 the strange state caused
> interrupts to fire so we need to deal with it while interrupts are
> still off.
> 
> At the moment this support is only added to dw_mmc-pltfm which calls
> straight to the callback, since nobody but exynos needs it.  We can
> add some levels of indirection (a call into the generic dw_mmc code)
> when someone finds a need.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Reviewed-by: James Hogan <james.hogan@imgtec.com>

<snip>

>  
> -SIMPLE_DEV_PM_OPS(dw_mci_pltfm_pmops, dw_mci_pltfm_suspend, dw_mci_pltfm_resume);
> +const struct dev_pm_ops dw_mci_pltfm_pmops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(dw_mci_pltfm_suspend, dw_mci_pltfm_resume)
> +	.suspend_noirq = dw_mci_pltfm_suspend_noirq,
> +	.resume_noirq = dw_mci_pltfm_resume_noirq,
> +};

Does Exynos support hibernation? I see that SET_SYSTEM_SLEEP_PM_OPS sets
freeze, thaw, poweroff, and restore callbacks too. You may not need the
hibernation specific _noirq callbacks though in which case it's probably
fine as it is.

Cheers
James


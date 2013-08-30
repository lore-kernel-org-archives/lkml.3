Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab3H3DzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 23:55:18 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:59112 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab3H3DzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 23:55:15 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-62-522017a1ba43
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>
Cc: "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Chris Ball'" <cjb@laptop.org>,
        "'James Hogan'" <james.hogan@imgtec.com>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Abhilash Kesavan'" <a.kesavan@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Olof Johansson'" <olof@lixom.net>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1377188348-3418-1-git-send-email-dianders@chromium.org>
 <1377188348-3418-3-git-send-email-dianders@chromium.org>
 <001201cea215$8c125e30$a4371a90$%jun@samsung.com>
 <521B1A87.4000500@samsung.com>
 <CAD=FV=WYMyGVmG-DXk1ke-yQCrfF74KDaZAUCW3qzf+Xfp-tpQ@mail.gmail.com>
 <000301cea486$0d813eb0$2883bc10$%jun@samsung.com>
 <CAD=FV=VXpH31X3+LnJA6ewyrYzOZ1zu_4mL=93U9WnguR=3Nhw@mail.gmail.com>
In-reply-to: <CAD=FV=VXpH31X3+LnJA6ewyrYzOZ1zu_4mL=93U9WnguR=3Nhw@mail.gmail.com>
Subject: RE: [PATCH v6 2/3] mmc: dw_mmc: Honor requests to set the clock to 0
 (turn off clock)
Date: Fri, 30 Aug 2013 12:55:12 +0900
Message-id: <000b01cea534$bae75bd0$30b61370$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6k1b3SVb7qrGY+RpGhzZYAN7j5wgAT3vWw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t8zY92F4gpBBl0rFS0er1nMZPFg3jY2
	i+2vN7JZnF12kM3i1ZEfTBbv5r1gtrjxq43V4vKuOWwWR/73M1qcuv6ZzWLVrj+MDtwesxsu
	snjsnHWX3aNn5xlGj0NX1jJ6XDnRxOrRt2UVo8fnTXIB7FFcNimpOZllqUX6dglcGVd3r2It
	6NWuOHFmP3sD4xSlLkYODgkBE4nFvYxdjJxAppjEhXvr2UBsIYFljBJ3rutBxE0kfj78DRTn
	AopPZ5T40zcRyvnDKHFp82EWkCo2AS2Jv2/eMIPYIgLaEi8frGQGKWIWaGSW+LhoFxNExzRm
	iYOnW8A6OAWCJe48vgbWISyQING0fCfYHSwCqhJr5/1gBbF5BWwlZm4/wg5hC0r8mHyPBeRs
	ZgE9ifsXtUDCzALyEpvXvGWG+EZd4tFfXRBTRMBIYtmtHIgKEYl9L94xglwgITCTQ2LJva1M
	EJsEJL5NPsQC0SorsekAM8TDkhIHV9xgmcAoMQvJ3lkIe2ch2TsLyYYFjCyrGEVTC5ILipPS
	i0z0ihNzi0vz0vWS83M3MUKifsIOxnsHrA8xJgNtn8gsJZqcD0waeSXxhsZmRhamJqbGRuaW
	ZqQJK4nzqrdYBwoJpCeWpGanphakFsUXleakFh9iZOLglGpg7F9cKfSm+JxGw/bYKDnedIOZ
	Z5c3NE//YC+34OkPnbad52N2rWfYqvJS6qrbHwbWXYcN2UUaeWXm7DuQE97FY9m+c0lu1+dY
	Buav/w58aY+snC1WwcG1lLvRq8Hp1aHWUB+Vy//iNjCzd9xuTz3480iw+B6LfQIb4nW7LU2/
	7UiWlfUQ/WSjxFKckWioxVxUnAgARIQPpBADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDKsWRmVeSWpSXmKPExsVy+t9jQd2F4gpBBvdPS1s8XrOYyeLBvG1s
	Fttfb2SzOLvsIJvFqyM/mCzezXvBbHHjVxurxeVdc9gsjvzvZ7Q4df0zm8WqXX8YHbg9Zjdc
	ZPHYOesuu0fPzjOMHoeurGX0uHKiidWjb8sqRo/Pm+QC2KMaGG0yUhNTUosUUvOS81My89Jt
	lbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgK5UUihLzCkFCgUkFhcr6dthmhAa4qZr
	AdMYoesbEgTXY2SABhLWMWZc3b2KtaBXu+LEmf3sDYxTlLoYOTkkBEwkfj78zQZhi0lcuLce
	yObiEBKYzijxp28ilPOHUeLS5sMsIFVsAloSf9+8YQaxRQS0JV4+WMkMUsQs0Mgs8XHRLiaI
	jmnMEgdPt4B1cAoES9x5fA2sQ1ggQaJp+U5GEJtFQFVi7bwfrCA2r4CtxMztR9ghbEGJH5Pv
	AfVyAE3Vk7h/UQskzCwgL7F5zVtmkLCEgLrEo7+6IKaIgJHEsls5EBUiEvtevGOcwCg0C8mc
	WQhzZiGZMwtJxwJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwWnlmfQOxlUNFocYBTgY
	lXh4G6bKBwmxJpYVV+YeYpTgYFYS4Y3fBhTiTUmsrEotyo8vKs1JLT7EmAz05URmKdHkfGDK
	yyuJNzQ2MTOyNDKzMDIxNydNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGRgnfCWdKv8sm
	3nEuF4k9tZvVzcQ2JpjxgNnZ1YtWiQedtfHRvZ/10S/kYGlE0ukHdgrc14K8V/53tUlZoHd4
	omnr/hlCf/WipKvPKttsnRf/RODsOpMfJ/+FfI+8mv6Xp+QTqxVPx/3aVbb3bzJIVPs9vLI+
	JePWi+t+ikrh+5k/vz18KC75qhJLcUaioRZzUXEiAFVnCEBvAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, August 30, 2013, Doug Anderson wrote:
> Seungwon,
> 
> On Thu, Aug 29, 2013 at 12:04 AM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> >> I'd really still rather honor the MMC subsystem's request.  It
> >> shouldn't _hurt_ to turn the clock off when the subsystem requests it,
> > Even though turning off by clock programming doesn't hurt,
> > it is costly behavior when considering low power mode of host's own support.
> 
> It is costly?  We are talking about these two commands, right?
> 
>   mci_writel(host, CLKENA, 0);
>   mci_send_cmd(slot,
>       SDMMC_CMD_UPD_CLK | SDMMC_CMD_PRV_DAT_WAIT, 0);
I mean that because host supports auto clock gating, we don't need to
clock programming with setting '0'. If MMC_CLKGATE is enabled, clock programming
will be executed with between '0' clock and working clock frequently. Actually the result is same.
Of course, if host didn't support this feature, we would have considered that manually to save the power consumption.

> 
> Do you have a reason to believe that these are more costly than all of
> the rest of the code that's executed when the user defines
> CONFIG_MMC_CLKGATE?  You're still proposing doing all of the updates
> of the clock when slot->clock is non-zero, right?  ...so at best
No, origin condition should be remained;
Required clock should be different with current clock.

> skipping this code will be 33% faster since the re-enable code
> disables and then reenables the clock.  If it's the
> "SDMMC_CMD_PRV_DAT_WAIT" that you're worried about then skipping this
> code will only be 25% faster since there are already three calls with
> SDMMC_CMD_PRV_DAT_WAIT in the enable code.
> 
> 
> > Just now, how about focusing on the problem clock isn't updated properly after suspend/resume?
> 
> I tried to do that in the original patches, but you pointed out
> (correctly) that we should do the correct fix rather than a hackier
> fix.  IMHO the most correct fix is to honor the MMC core's request to
> turn the clock off.  Partially honoring the MMC core (as you suggest)
> is certainly less hacky that my original proposal but I still think
> turning the clock off is better.
> 
> 
> >> right?  One reason to honor the mmc core is that it will make things
> >> cleaner if/when we support a voltage change operation.  The MMC core
> >> has the logic for the voltage change, and part of that involves
> >> turning off the clock.  We'll already need a bunch of special case
> >> code in dw_mmc for voltage change, but it would be nice to avoid one
> >> extra bit.
> > Turning off clock during voltage switching would be another procedure.
> > I guess it could be discussed later.
> 
> Agreed that we're not trying to get voltage switching done here, but
> forward thinking is nice.  If there's no reason _not_ to turn the
> clock off and it will help us later, let's do it. Also, we've already
> agreed that MMC_CLKGATE isn't so useful for dw_mmc, so trying to do
> something awkward to make MMC_CLKGATE slightly faster doesn't seem
> worth it.
> 
> 
> > I want to fix some minor change to prevent frequent message that Jaehoon pointed.
> 
> As far as I can tell, the frequent messages and whether or not to
> actually turn the clock off are unrelated.  I will send up a patch
> that fixes the frequent messages by caching the last value printed and
> only printing if it changed.  I have verified that this works and that
> the system still functions OK (can boot to prompt) with
> CONFIG_MMC_CLKGATE.
> 
> 
> Note: re-reading over some of the previous messages, it sounds like
> you're proposing using the patch from your email directly, AKA:
> 
> http://article.gmane.org/gmane.linux.kernel/1542482
> 
> Did you test that patch?  Did it work for you?  It doesn't actually
> compile cleanly for me (you removed the "force_clkinit" param in the
> function but not the callers).  That's easy to fix, but implies that
> this patch was just a proposal and not a tested solution.
> 
> ...but aside from not compiling cleanly, I don't think it will work
> for the same reasons that the original code didn't work.  Specifically
> it doesn't address the core problem that we need to update
> host->current_speed when the clock is 0.  Otherwise we won't re-init
> and we run into the original problem, right?  To be certain I took
> your patch and applied it, then fixed the callers of
> dw_mci_setup_bus() not to pass a second parameter.  I did a
> suspend/resume with no card in and then plugged a card in.  It didn't
> work.

Some change proposed from me are mixed with both current existing part and your new patch.
It's not whole code to replace your patch. But if it makes you confused, sorry about that.
Important thing I intended is that if required clock(slot->clock) is '0', not try to update clock.
with considering automatic clock gating. Please check first comment from me on v6.

Thanks,
Seungwon Jeon
> 
> 
> As I said above, new patch coming shortly.  As always: feel free to
> point out any glaring mistakes I made in the above.  ;)  Note that I
> will be out of communication for the next week or so and buried
> beneath email for a few days after that, so my response might be a
> little delayed.
> 
> 
> 
> -Doug
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


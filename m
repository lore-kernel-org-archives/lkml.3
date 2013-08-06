Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab3HFVc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:32:26 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:36878 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab3HFVcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:32:24 -0400
MIME-Version: 1.0
In-Reply-To: <004001ce8154$36753510$a35f9f30$%jun@samsung.com>
References: <1373411961-23812-1-git-send-email-dianders@chromium.org>
	<1373470926-19314-1-git-send-email-dianders@chromium.org>
	<1373470926-19314-3-git-send-email-dianders@chromium.org>
	<004001ce8154$36753510$a35f9f30$%jun@samsung.com>
Date: Tue, 6 Aug 2013 14:32:23 -0700
X-Google-Sender-Auth: I7P35ktf2LsGkJyt-FmR8oonH4U
Message-ID: <CAD=FV=XJeXF6qeewAyFT_C1ssaU3HjtPr6aso9cjQ9s3=k=Z_A@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] mmc: dw_mmc: Add suspend_noirq/resume_noirq
 callbacks for dw_mmc-pltfm
From: Doug Anderson <dianders@chromium.org>
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: Chris Ball <cjb@laptop.org>, Olof Johansson <olof@lixom.net>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        James Hogan <james.hogan@imgtec.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seungwon Jeon,

On Mon, Jul 15, 2013 at 5:09 AM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> On Thu, July 11, 2013, Doug Anderson wrote:
>> On some devices (like exynos5420) the dw_mmc controller may be in a
>> strange state after we wake up from sleep.  Add callbacks to allow for
>> dealing with these quirks.  We use the "_noirq" versions of the
>> callbacks since in the case of exynos5420 the strange state caused
>> interrupts to fire so we need to deal with it while interrupts are
>> still off.
>>
>> At the moment this support is only added to dw_mmc-pltfm which calls
>> straight to the callback, since nobody but exynos needs it.  We can
>> add some levels of indirection (a call into the generic dw_mmc code)
>> when someone finds a need.
> I think It would be better to add _noirq only to dw_mmc-exynos.
> That is we can add dev_pm_ops for dw_mmc-exynos's own.
> As you recognize, there is no common routine which is not introduced for dw_mmc xxx_noirq now.
> I feel like it is for handling quirk.
> If we meet use case for that in some day, it could be added commonly.
> How do you think?
>
> Thanks,
> Seungwon Jeon

Sorry for the long delay in responding.

I originally didn't do what you proposed since dw_mmc-exynos uses the
dw_mci_pltfm_pmops directly.  ...but I agree that it is cleaner, so
I've switched the code to do as you say.  New patch coming shortly.
Thank you for your review.

-Doug

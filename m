Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab3FSR3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:29:09 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:48806 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756707Ab3FSR3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:29:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDyKFroFY3-NJCFpkDYyBVx25CSfk492H_TnoS60jn2CdfWUQ@mail.gmail.com>
References: <1371146190-16786-1-git-send-email-zoran.markovic@linaro.org>
	<CAPDyKFrD=q4hOQps5ENJdmAPJyKG1cj7+P6MtXdQ8KQ1cPjnpQ@mail.gmail.com>
	<CAME+o4mM-YmcZ4pcdWo7mzrDUi2R2LhihgcnbYixOm8KnGfnBA@mail.gmail.com>
	<CAMbhsRRokPi59J8SghGL0QhUWKDqMuvfbT3TdPosXud_WxRV2Q@mail.gmail.com>
	<CAPDyKFqy9EEb6o8wYABYT6zE-7Rb0xxo8Y0DuAwooeYZp5=Grw@mail.gmail.com>
	<CAMbhsRSC5XhhSK-DAoS7_JAj7XUfaM_Topp4UcBaVwRCYXSscQ@mail.gmail.com>
	<CAPDyKFpMGS-JA47pY_n7xvqdtbPumGpc2fdnYZnSVQ_Rybre3g@mail.gmail.com>
	<CAMbhsRQwGbpa4a1RziV92qnw4VFh6+=oQiadfqa17FANEiK8_Q@mail.gmail.com>
	<CAPDyKFroFY3-NJCFpkDYyBVx25CSfk492H_TnoS60jn2CdfWUQ@mail.gmail.com>
Date: Wed, 19 Jun 2013 10:29:04 -0700
X-Google-Sender-Auth: GwVBdyibDT4ECJVmMlrAzO0iZUM
Message-ID: <CAMbhsRTR9im-BsJ-1m+DD-67LM=s0=KOoy-o+2PmnkDyLOP0Gg@mail.gmail.com>
Subject: Re: [RFC PATCH] mmc: Enable wakeup_sources for mmc core
From: Colin Cross <ccross@android.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Zoran Markovic <zoran.markovic@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-mmc@vger.kernel.org,
        San Mehat <san@google.com>, John Stultz <john.stultz@linaro.org>,
        Chris Ball <cjb@laptop.org>,
        Johan Rudholm <johan.rudholm@stericsson.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Konstantin Dorfman <kdorfman@codeaurora.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 7:21 AM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> It seems like a bad idea that an insertion of an SD card should
> trigger the display to be light up. That is indirectly in principle
> what you suggest should happen from user space once a new SD card is
> found. Right?

Most likely what will happen is the system will mount the sdcard, and
if necessary start the media scanner so that the user can see their
media on the sd card when they turn the screen on.  But that is mostly
irrelevant, the point is that the event needs to be passed to
userspace to allow it to make the decision in a timely fashion.

> I have been working with Android for several years, we never used this
> kind of setup. Instead we wait for the user to press the "display on"
> button. At that time the confirmation will be received. Not saying
> that this is the only way of doing it, but it seems to be an accepted
> solution for all our customers.

This patch is ported from the Android common tree, so you've probably
been using it.

> I agree to that this patch should have negligible impact though - if
> we get things right. I will try to review the code in more detail
> soon.
>
> Kind regards
> Ulf Hansson
>

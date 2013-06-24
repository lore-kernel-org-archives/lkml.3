Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab3FXT6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:58:42 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:59608 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab3FXT6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:58:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDyKFoX-ioDVVkfQ21epJyTqQD98xvsqBR1FXzgP9bN6_Zxjg@mail.gmail.com>
References: <1371146190-16786-1-git-send-email-zoran.markovic@linaro.org>
	<CAPDyKFrD=q4hOQps5ENJdmAPJyKG1cj7+P6MtXdQ8KQ1cPjnpQ@mail.gmail.com>
	<CAME+o4mM-YmcZ4pcdWo7mzrDUi2R2LhihgcnbYixOm8KnGfnBA@mail.gmail.com>
	<CAMbhsRRokPi59J8SghGL0QhUWKDqMuvfbT3TdPosXud_WxRV2Q@mail.gmail.com>
	<CAPDyKFqy9EEb6o8wYABYT6zE-7Rb0xxo8Y0DuAwooeYZp5=Grw@mail.gmail.com>
	<CAMbhsRSC5XhhSK-DAoS7_JAj7XUfaM_Topp4UcBaVwRCYXSscQ@mail.gmail.com>
	<CAPDyKFpMGS-JA47pY_n7xvqdtbPumGpc2fdnYZnSVQ_Rybre3g@mail.gmail.com>
	<CAMbhsRQwGbpa4a1RziV92qnw4VFh6+=oQiadfqa17FANEiK8_Q@mail.gmail.com>
	<CAPDyKFroFY3-NJCFpkDYyBVx25CSfk492H_TnoS60jn2CdfWUQ@mail.gmail.com>
	<CAMbhsRTR9im-BsJ-1m+DD-67LM=s0=KOoy-o+2PmnkDyLOP0Gg@mail.gmail.com>
	<CAPDyKFoX-ioDVVkfQ21epJyTqQD98xvsqBR1FXzgP9bN6_Zxjg@mail.gmail.com>
Date: Mon, 24 Jun 2013 12:58:39 -0700
Message-ID: <CAME+o4=WrfpvJo=jN1KZ_JHnYq9Frfk3EPcwtG10=aCwrbY+Rw@mail.gmail.com>
Subject: Re: [RFC PATCH] mmc: Enable wakeup_sources for mmc core
From: Zoran Markovic <zoran.markovic@linaro.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Colin Cross <ccross@android.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, San Mehat <san@google.com>,
        John Stultz <john.stultz@linaro.org>, Chris Ball <cjb@laptop.org>,
        Johan Rudholm <johan.rudholm@stericsson.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Konstantin Dorfman <kdorfman@codeaurora.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> This patch is ported from the Android common tree, so you've probably
>> been using it.
>
> We removed more or less all Android code in the mmc subsystem, since
> it just didn't work. :-)
>
> The "deferred resume" was very useful though, so after some rework we
> kept it and could then improve the system resume time significantly.

For what it's worth, I fixed one bug I noticed in the Android kernel:
if a system has a non-removable MMC device, a suspend/resume cycle on
this device would hold a wake lock forever. This was a visible issue
on the panda board I am using.

If there are doubts on whether or not the system should stay awake
during a MMC mount, we have the option to make the calls to
wakeup_source_register/unregister configurable. Skipping these calls
would leave the .ws field NULL, in which case
__pm_stay_awake/__pm_relax/__pm_wakeup_event would do nothing.

Thoughts?

- Zoran

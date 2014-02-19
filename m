Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbaBSEPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 23:15:46 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:55083 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbaBSEPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 23:15:45 -0500
MIME-Version: 1.0
In-Reply-To: <5303C018.1020707@wwwdotorg.org>
References: <cover.1392273722.git.viresh.kumar@linaro.org>
	<52FE71BD.3020103@wwwdotorg.org>
	<2869027.iYHxWOSS2C@vostro.rjw.lan>
	<52FEAECA.5080905@wwwdotorg.org>
	<CAKohpomhvuQQ0JN3wgLBnrSpFUjC9J9QwWZpD9nA6AFYw+paKA@mail.gmail.com>
	<5303C018.1020707@wwwdotorg.org>
Date: Wed, 19 Feb 2014 09:45:44 +0530
Message-ID: <CAKohponF7ag-tfv77JK0pDVukS6v3QeSY+G_br3FJGskMDCvVw@mail.gmail.com>
Subject: Re: [PATCH V5 0/7] cpufreq: suspend early/resume late: dpm_{suspend|resume}()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Kgene Kim <kgene.kim@samsung.com>,
        jinchoi@broadcom.com, Lan Tianyu <tianyu.lan@intel.com>,
        Sebastian Capella <sebastian.capella@linaro.org>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19-Feb-2014 1:48 AM, "Stephen Warren" <swarren@wwwdotorg.org> wrote:
>
> On 02/17/2014 02:20 AM, Viresh Kumar wrote:
> > On 15 February 2014 05:33, Stephen Warren <swarren@wwwdotorg.org> wrote:
> >> On 02/14/2014 03:23 PM, Rafael J. Wysocki wrote:
> >
> >>> Well, it would be good to verify which part, then.
> >>
> >> Patch 2/7 appears to stop that message from being printed during
> >> suspend, and perhaps reduce the number of times it's printed during
> >> resume. Patch 7/7 stops the message being printed at all.
> >>
> >> Looking at patch 7, I wonder if it's simply because tegra_target() was
> >> modified never to return -EBUSY, so the bug is still there, but it's
> >> just been hidden.
> >
> > No, the bug is removed now. Its hidden in current linus/master :)
>
> I'm not sure what that means; I still see the message:

I have given a better reply in one of the earlier mails in this thread.
And skipped a more elaborative reply now.

So this failure was always there since long time, as you disable your
target() fn early in suspend. But the message wasn't printed earlier.

A recently added core patch started printing this, so not a new bug.
But this series fixes suspend resume completely and you wouldn't see it
anymore.

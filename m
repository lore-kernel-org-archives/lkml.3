Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571Ab3DEFTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 01:19:17 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:60584 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390Ab3DEFTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 01:19:15 -0400
MIME-Version: 1.0
In-Reply-To: <1365096935-16730-1-git-send-email-dirk.brandewie@gmail.com>
References: <1365096935-16730-1-git-send-email-dirk.brandewie@gmail.com>
Date: Fri, 5 Apr 2013 10:49:14 +0530
X-Google-Sender-Auth: Jzywz1fq0_OFe513IgfYLy32uHI
Message-ID: <CAOh2x=mzQBSnBB3-10yGMdGfxMWeMcvE_t2Mvnz+fvdHv0-uaA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq/intel_pstate: Set timer timeout correctly
From: Viresh Kumar <viresh.kumar@linaro.org>
To: dirk.brandewie@gmail.com, Adam Williamson <awilliam@redhat.com>,
        Parag Warudkar <parag.lkml@gmail.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 4, 2013 at 11:05 PM,  <dirk.brandewie@gmail.com> wrote:
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
>
> The current calculation of the delay time is wrong and a cut and paste
> error from a previous experimental driver.  This can result in the
> timeout being set to jiffies + 1 which setup the driver to race with
> it's self if the apic timer interrupt happen at just the right time.
>
>
> https://bugzilla.redhat.com/show_bug.cgi?id=920289
>
> Reported-by: Adam Williamson <awilliam@redhat.com>
> Reported-by: Parag Warudkar <parag.lkml@gmail.com>
>
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
> ---
>  drivers/cpufreq/intel_pstate.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)

Looks fine, but I would like to see a Tested-by from Adam/Parag
as they haven't said anything about this patch (even in bugzilla).

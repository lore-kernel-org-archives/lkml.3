Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933972Ab3BMMJC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 07:09:02 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:33046 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933877Ab3BMMJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 07:09:00 -0500
MIME-Version: 1.0
In-Reply-To: <20130213092154.GA4481@brouette>
References: <1360675195-4017-1-git-send-email-vincent.guittot@linaro.org>
	<20130213061853.GA4043@brouette>
	<CAKfTPtDCPKeQpcS4mQc7Jp7+wK2EuvnCUqAzL7SOELVVL3jztw@mail.gmail.com>
	<20130213092154.GA4481@brouette>
Date: Wed, 13 Feb 2013 13:08:58 +0100
Message-ID: <CAKfTPtDprVAA0o6sTugYk8RiaUkGXUmSvd4RJbTEhNkKj7B-5A@mail.gmail.com>
Subject: Re: [PATCH] sched: fix env->src_cpu for active migration
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Damien Wyart <damien.wyart@gmail.com>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Damien,

Regarding your sched_domain config and especially the flags field, you
should not be impacted by my patch because
- need_active_balance is the only new place that use env->src_cpu in
the load_balance function
- and your machine will never test the condition: "env->src_cpu >
env->dst_cpu" in need_active_balance because  SD_ASYM_PACKING is not
set in your config

Have you tested the patch with others that could have modified the
load_balance function ?

Vincent

On 13 February 2013 10:21, Damien Wyart <damien.wyart@gmail.com> wrote:
> Hi,
>
>> Thanks for the test and the feedback.
>> Could you send me the sched_domain configuration of your machine with
>> the kernel that boots on your machine ?
>> It's available in /proc/sys/kernel/sched_domain/cpu*/
>
> I attach to this mail the sched_domain info, the contents of
> /proc/cpuinfo and my kernel config.
>
> --
> Damien

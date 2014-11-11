Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbaKKDkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 22:40:16 -0500
Received: from mail-oi0-f47.google.com ([209.85.218.47]:57705 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbaKKDkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 22:40:13 -0500
MIME-Version: 1.0
In-Reply-To: <1415199239-19019-4-git-send-email-prarit@redhat.com>
References: <1415199239-19019-1-git-send-email-prarit@redhat.com>
	<1415199239-19019-4-git-send-email-prarit@redhat.com>
Date: Tue, 11 Nov 2014 09:10:13 +0530
Message-ID: <CAKohpon9XOdrHW2HyctWmadT=F2NH8KLn7SMBE-hPLMAbTs+ZA@mail.gmail.com>
Subject: Re: [PATCH 3/5] cpufreq, dbs_data->usage count must be atomic
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Robert_Sch=C3=B6ne?= <robert.schoene@tu-dresden.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 November 2014 20:23, Prarit Bhargava <prarit@redhat.com> wrote:
> The usage_count value can be modified from several cpus concurrently if
> !CPUFREQ_HAVE_GOVERNOR_PER_POLICY.  This leads to a variety of panics in
> which the usage_count is negative or exceeds the number of cpus in the
> system.  It must be switched to atomic_t and protected with a mutex to make sure
> that future read/writes obtain the correct data.

I think it would be best to serialize calls to ->governor() with some
locking in place
instead of adding per-variable locks. There can be other points of
contention as well.

I have done something similar in the solution I tried. Can pick some
of those patches.

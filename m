Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbaKKDh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 22:37:28 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:43575 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbaKKDh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 22:37:27 -0500
MIME-Version: 1.0
In-Reply-To: <5460AF02.9010907@redhat.com>
References: <1415199239-19019-1-git-send-email-prarit@redhat.com>
	<1415199239-19019-3-git-send-email-prarit@redhat.com>
	<CAKohpomZNwZWjmi8hkZ6QXUeDTaXTwzx_fPz1_byh3xmmkPNrQ@mail.gmail.com>
	<5460AF02.9010907@redhat.com>
Date: Tue, 11 Nov 2014 09:07:26 +0530
Message-ID: <CAKohpomeRivb3TwkeWALL_xsf4gOBPYOnfCNdz2oVvZSAGBP4g@mail.gmail.com>
Subject: Re: [PATCH 2/5] cpufreq, fix locking around CPUFREQ_GOV_POLICY_EXIT calls
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

On 10 November 2014 17:56, Prarit Bhargava <prarit@redhat.com> wrote:

>> I still fail to understand why ? What will the _trylock() change ?
>
> viresh, afaict read_trylock will return 0 when busy with write:

Yes..

> static inline int queue_read_trylock(struct qrwlock *lock)
> {
>         u32 cnts;
>
>         cnts = atomic_read(&lock->cnts);
>         if (likely(!(cnts & _QW_WMASK))) {
>
> so the deadlock will not occur.  the show() is opened, write lock is taken, and
> if the thread is rescheduled and takes read lock the trylock will return 0, and
> the thread will return -EBUSY to userspace avoiding the deadlock.

Which deadlock? And also your changelog talks about accessing invalid pointers
without the trylock change, how can that be possible? After the read
lock is taken,
all the pointers should be valid.

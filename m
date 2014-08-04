Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbaHDJym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 05:54:42 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:38117 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaHDJyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 05:54:40 -0400
MIME-Version: 1.0
In-Reply-To: <53D25081.1010209@redhat.com>
References: <1406224491-3599-1-git-send-email-prarit@redhat.com>
	<CAKohpomHj17A4e6Sh8JSz1HPbq9r8gXUJeZ20PQ=Mhu59Vt7ZQ@mail.gmail.com>
	<53D24030.1010302@redhat.com>
	<53D25081.1010209@redhat.com>
Date: Mon, 4 Aug 2014 15:24:40 +0530
Message-ID: <CAKohpoksKz5437Yds0Rk59Rgr+rdt=UcH421MjY2BhEbMjfwQw@mail.gmail.com>
Subject: Re: [PATCH] cpufreq, store_scaling_governor requires policy->rwsem to
 be held for duration of changing governors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lenny Szubowicz <lszubowi@redhat.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 July 2014 18:11, Prarit Bhargava <prarit@redhat.com> wrote:
> Okay -- I think I got it:  The above happens only with an *older* sysfs stack
> which acquires a &buffer->mutex.  This no longer happens with the new sysfs
> stack so the above change is still no longer necessary in mainline linux.git (at
> least AFAICT).

Hmm, that's something new for me. Would it be possible to give some commits
for reference where the behavior changed? This would be quite helpful once
we face it again and need to come back to this thread :)

> In any case, the change still appears to be incorrect in that it breaks the
> rwsem locking scheme of the cpufreq policy.  I'll do some additional testing on
> various systems and get back to you in a few days.

What about breaking rwsem locking scheme?

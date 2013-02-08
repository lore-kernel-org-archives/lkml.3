Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab3BHFyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 00:54:54 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:57039 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab3BHFyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 00:54:40 -0500
MIME-Version: 1.0
In-Reply-To: <1873989.qC1mdEKIl9@vostro.rjw.lan>
References: <20130206202513.GA5626@thinkpad.lan>
	<1543919.ZBNJa64WB5@vostro.rjw.lan>
	<1873989.qC1mdEKIl9@vostro.rjw.lan>
Date: Fri, 8 Feb 2013 11:24:39 +0530
Message-ID: <CAKohpokvXoBEHqb+axzMJhB3K02bZEzPGF1RO6pyJwsC2Y-8cQ@mail.gmail.com>
Subject: Re: [BUG] cpufreq: sleeping function called from invalid context at kernel/workqueue.c:2811
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Artem Savkov <artem.savkov@gmail.com>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 February 2013 06:11, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: cpufreq: Move sysfs_remove_link() from under a spinlock
>
> Commit 73bf0fc "cpufreq: Don't remove sysfs link for policy->cpu"
> attempted to fix a bug in __cpufreq_remove_dev() by avoiding to
> remove the link to the "cpufreq" directory for policy->cpu, but it
> rearranged the code in such a way that sysfs_remove_link() ended up
> under a spinlock, which caused complaints about sleeping in atomic
> context to be emitted into the kernel log during system suspend.
>
> To fix this, revert commit 73bf0fc partially and move the
> sysfs_remove_link() in question to a separate block executed for
> cpus > 1 outside of the spinlock.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

BTW, i have dropped this patch completely as i got another lock fixing
patch :)

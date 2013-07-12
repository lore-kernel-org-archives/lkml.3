Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab3GLHSO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 03:18:14 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53393 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757132Ab3GLHSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 03:18:11 -0400
MIME-Version: 1.0
In-Reply-To: <20130711221527.547.46447.stgit@srivatsabhat.in.ibm.com>
References: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com>
	<20130711221527.547.46447.stgit@srivatsabhat.in.ibm.com>
Date: Fri, 12 Jul 2013 12:48:10 +0530
Message-ID: <CAKohpomVo5FEN1fOHQQ9jQuLnrRfHcNkH7QcnJG7x6x-Xd7J-A@mail.gmail.com>
Subject: Re: [PATCH 1/8] cpufreq: Revert commit a66b2e to fix cpufreq
 regression during suspend/resume
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, toralf.foerster@gmx.de, robert.jarzmik@intel.com,
        durgadoss.r@intel.com, tianyu.lan@intel.com, lantianyu1986@gmail.com,
        dirk.brandewie@gmail.com, stern@rowland.harvard.edu,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 July 2013 03:45, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> commit a66b2e (cpufreq: Preserve sysfs files across suspend/resume) has
> unfortunately caused several things in the cpufreq subsystem to break subtly
> after a suspend/resume cycle.
>
> The intention of that patch was to retain the file permissions of the
> cpufreq related sysfs files across suspend/resume. To achieve that, the commit
> completely removed the calls to cpufreq_add_dev() and __cpufreq_remove_dev()
> during suspend/resume transitions. But the problem is that those functions
> do 2 kinds of things:
>   1. Low-level initialization/tear-down that are critical to the correct
>      functioning of cpufreq-core.
>   2. Kobject and sysfs related initialization/teardown.
>
> Ideally we should have reorganized the code to cleanly separate these two
> responsibilities, and skipped only the sysfs related parts during
> suspend/resume. Since we skipped the entire callbacks instead (which also
> included some CPU and cpufreq-specific critical components), cpufreq
> subsystem started behaving erratically after suspend/resume.
>
> So revert the commit to fix the regression. We'll revisit and address the
> original goal of that commit separately, since it involves quite a bit of
> careful code reorganization and appears to be non-trivial.
>
> (While reverting the commit, note that another commit f51e1eb "cpufreq:
> Fix cpufreq regression after suspend/resume" already reverted part of the
> original set of changes. So revert only the remaining ones).
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
>
>  drivers/cpufreq/cpufreq.c       |    4 +++-
>  drivers/cpufreq/cpufreq_stats.c |    6 ++----
>  2 files changed, 5 insertions(+), 5 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

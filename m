Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab3G3JJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:09:37 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:45317 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758360Ab3G3JJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:09:31 -0400
MIME-Version: 1.0
In-Reply-To: <20130729225504.20863.79224.stgit@srivatsabhat.in.ibm.com>
References: <20130729225213.20863.56722.stgit@srivatsabhat.in.ibm.com>
	<20130729225504.20863.79224.stgit@srivatsabhat.in.ibm.com>
Date: Tue, 30 Jul 2013 14:39:30 +0530
Message-ID: <CAKohpo=0E4mR3FLJwuZ=6LbGMg7zQUZhnzjBKfm3ohSTw=p5Uw@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] cpufreq: Preserve policy structure across suspend/resume
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

On 30 July 2013 04:25, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> To perform light-weight cpu-init and teardown in the cpufreq subsystem
> during suspend/resume, we need to separate out the 2 main functionalities
> of the cpufreq CPU hotplug callbacks, as outlined below:
>
> 1. Init/tear-down of core cpufreq and CPU-specific components, which are
>    critical to the correct functioning of the cpufreq subsystem.
>
> 2. Init/tear-down of cpufreq sysfs files during suspend/resume.
>
> The first part requires accurate updates to the policy structure such as
> its ->cpus and ->related_cpus masks, whereas the second part requires that
> the policy->kobj structure is not released or re-initialized during
> suspend/resume.
>
> To handle both these requirements, we need to allow updates to the policy
> structure throughout suspend/resume, but prevent the structure from getting
> freed up. Also, we must have a mechanism by which the cpu-up callbacks can
> restore the policy structure, without allocating things afresh. (That also
> helps avoid memory leaks).
>
> To achieve this, we use 2 schemes:
> a. Use a fallback per-cpu storage area for preserving the policy structures
>    during suspend, so that they can be restored during resume appropriately.
>
> b. Use the 'frozen' flag to determine when to free or allocate the policy
>    structure vs when to restore the policy from the saved fallback storage.
>    Thus we can successfully preserve the structure across suspend/resume.
>
> Effectively, this helps us complete the separation of the 'light-weight'
> and the 'full' init/tear-down sequences in the cpufreq subsystem, so that
> this can be made use of in the suspend/resume scenario.
>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
>
>  drivers/cpufreq/cpufreq.c |   69 +++++++++++++++++++++++++++++++++++----------
>  1 file changed, 53 insertions(+), 16 deletions(-)
>

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

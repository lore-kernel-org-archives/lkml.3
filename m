Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116Ab3GLHKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 03:10:00 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:53085 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756686Ab3GLHJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 03:09:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130711221605.547.69988.stgit@srivatsabhat.in.ibm.com>
References: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com>
	<20130711221605.547.69988.stgit@srivatsabhat.in.ibm.com>
Date: Fri, 12 Jul 2013 12:39:58 +0530
Message-ID: <CAKohponVobWCLNf3ryPiEXpmru+qrp=EYLyX0zLh2SSabpf-SQ@mail.gmail.com>
Subject: Re: [PATCH 3/8] cpufreq: Add helper to perform alloc/free of policy structure
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

On 12 July 2013 03:46, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> Separate out the allocation of the cpufreq policy structure (along with
> its error handling) to a helper function. This makes the code easier to
> read and also helps with some upcoming code reorganization.
>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
>
>  drivers/cpufreq/cpufreq.c |   50 ++++++++++++++++++++++++++++++++-------------
>  1 file changed, 35 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index f8c3100..ca14dc2 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -943,6 +943,37 @@ static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
>  }
>  #endif
>
> +static struct cpufreq_policy *cpufreq_policy_alloc(void)
> +{
> +       struct cpufreq_policy *policy;
> +
> +       policy = kzalloc(sizeof(struct cpufreq_policy), GFP_KERNEL);

sizeof(*policy) ??

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387AbaFIVH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 17:07:28 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:56215 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932226AbaFIVHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 17:07:24 -0400
Date: Mon, 9 Jun 2014 14:07:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Stratos Karafotis <stratosk@semaphore.gr>
cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] cpufreq: intel_pstate: Make intel_pstate_kobject
 local
In-Reply-To: <53962096.1060202@semaphore.gr>
Message-ID: <alpine.DEB.2.02.1406091405540.30620@chino.kir.corp.google.com>
References: <53962096.1060202@semaphore.gr>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014, Stratos Karafotis wrote:

> Since we never remove sysfs entry, we can make the intel_pstate_kobject
> local.
> 

For even more savings, this function and 
intel_pstate_debug_expose_params() can be annotated with __init and freed 
after bootstrap.

> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> ---
>  drivers/cpufreq/intel_pstate.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index fa44f0f..9533fff 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -387,10 +387,10 @@ static struct attribute *intel_pstate_attributes[] = {
>  static struct attribute_group intel_pstate_attr_group = {
>  	.attrs = intel_pstate_attributes,
>  };
> -static struct kobject *intel_pstate_kobject;
>  
>  static void intel_pstate_sysfs_expose_params(void)
>  {
> +	struct kobject *intel_pstate_kobject;
>  	int rc;
>  
>  	intel_pstate_kobject = kobject_create_and_add("intel_pstate",

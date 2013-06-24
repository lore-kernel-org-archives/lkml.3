Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590Ab3FXULm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 16:11:42 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60141 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab3FXULl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 16:11:41 -0400
X-Originating-IP: 108.223.40.66
Date: Mon, 24 Jun 2013 13:11:44 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [lm-sensors] [PATCH 26/32] hwmon: delete __cpuinit usage from
 all hwmon files
Message-ID: <20130624201144.GA13922@roeck-us.net>
References: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
 <1372102237-8757-27-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372102237-8757-27-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 03:30:31PM -0400, Paul Gortmaker wrote:
> The __cpuinit type of throwaway sections might have made sense
> some time ago when RAM was more constrained, but now the savings
> do not offset the cost and complications.  For example, the fix in
> commit 5e427ec2d0 ("x86: Fix bit corruption at CPU resume time")
> is a good example of the nasty type of bugs that can be created
> with improper use of the various __init prefixes.
> 
> After a discussion on LKML[1] it was decided that cpuinit should go
> the way of devinit and be phased out.  Once all the users are gone,
> we can then finally remove the macros themselves from linux/init.h.
> 
> This removes all the drivers/hwmon uses of the __cpuinit macros
> from all C files.
> 
> [1] https://lkml.org/lkml/2013/5/20/589
> 
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> Cc: lm-sensors@lm-sensors.org
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Acked-by: Guenter Roeck <linux@roeck-us.net>

> ---
> 
> [This commit is part of the __cpuinit removal work.  If you don't see
>  any problems with it, then you don't have to do anything ; it will be
>  submitted with all the rest of the __cpuinit removal work.  On the
>  other hand, if you want to carry this patch in with your other pending
>  changes so as to handle conflicts with other pending work yourself, then
>  that is fine too, as the commits can largely be treated independently.
>  For more information, please see: https://lkml.org/lkml/2013/6/20/513 ]
> 
>  drivers/hwmon/coretemp.c    | 39 ++++++++++++++++++---------------------
>  drivers/hwmon/via-cputemp.c |  8 ++++----
>  2 files changed, 22 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
> index ade35cf..2e5e2dc 100644
> --- a/drivers/hwmon/coretemp.c
> +++ b/drivers/hwmon/coretemp.c
> @@ -195,7 +195,7 @@ struct tjmax {
>  	int tjmax;
>  };
>  
> -static const struct tjmax __cpuinitconst tjmax_table[] = {
> +static const struct tjmax tjmax_table[] = {
>  	{ "CPU  230", 100000 },		/* Model 0x1c, stepping 2	*/
>  	{ "CPU  330", 125000 },		/* Model 0x1c, stepping 2	*/
>  	{ "CPU CE4110", 110000 },	/* Model 0x1c, stepping 10 Sodaville */
> @@ -211,7 +211,7 @@ struct tjmax_model {
>  
>  #define ANY 0xff
>  
> -static const struct tjmax_model __cpuinitconst tjmax_model_table[] = {
> +static const struct tjmax_model tjmax_model_table[] = {
>  	{ 0x1c, 10, 100000 },	/* D4xx, K4xx, N4xx, D5xx, K5xx, N5xx */
>  	{ 0x1c, ANY, 90000 },	/* Z5xx, N2xx, possibly others
>  				 * Note: Also matches 230 and 330,
> @@ -226,8 +226,7 @@ static const struct tjmax_model __cpuinitconst tjmax_model_table[] = {
>  	{ 0x36, ANY, 100000 },	/* Atom Cedar Trail/Cedarview (N2xxx, D2xxx) */
>  };
>  
> -static int __cpuinit adjust_tjmax(struct cpuinfo_x86 *c, u32 id,
> -				  struct device *dev)
> +static int adjust_tjmax(struct cpuinfo_x86 *c, u32 id, struct device *dev)
>  {
>  	/* The 100C is default for both mobile and non mobile CPUs */
>  
> @@ -317,8 +316,7 @@ static int __cpuinit adjust_tjmax(struct cpuinfo_x86 *c, u32 id,
>  	return tjmax;
>  }
>  
> -static int __cpuinit get_tjmax(struct cpuinfo_x86 *c, u32 id,
> -			       struct device *dev)
> +static int get_tjmax(struct cpuinfo_x86 *c, u32 id, struct device *dev)
>  {
>  	int err;
>  	u32 eax, edx;
> @@ -367,8 +365,8 @@ static int create_name_attr(struct platform_data *pdata,
>  	return device_create_file(dev, &pdata->name_attr);
>  }
>  
> -static int __cpuinit create_core_attrs(struct temp_data *tdata,
> -				       struct device *dev, int attr_no)
> +static int create_core_attrs(struct temp_data *tdata, struct device *dev,
> +			     int attr_no)
>  {
>  	int err, i;
>  	static ssize_t (*const rd_ptr[TOTAL_ATTRS]) (struct device *dev,
> @@ -401,7 +399,7 @@ exit_free:
>  }
>  
>  
> -static int __cpuinit chk_ucode_version(unsigned int cpu)
> +static int chk_ucode_version(unsigned int cpu)
>  {
>  	struct cpuinfo_x86 *c = &cpu_data(cpu);
>  
> @@ -417,7 +415,7 @@ static int __cpuinit chk_ucode_version(unsigned int cpu)
>  	return 0;
>  }
>  
> -static struct platform_device __cpuinit *coretemp_get_pdev(unsigned int cpu)
> +static struct platform_device *coretemp_get_pdev(unsigned int cpu)
>  {
>  	u16 phys_proc_id = TO_PHYS_ID(cpu);
>  	struct pdev_entry *p;
> @@ -434,8 +432,7 @@ static struct platform_device __cpuinit *coretemp_get_pdev(unsigned int cpu)
>  	return NULL;
>  }
>  
> -static struct temp_data __cpuinit *init_temp_data(unsigned int cpu,
> -						  int pkg_flag)
> +static struct temp_data *init_temp_data(unsigned int cpu, int pkg_flag)
>  {
>  	struct temp_data *tdata;
>  
> @@ -453,8 +450,8 @@ static struct temp_data __cpuinit *init_temp_data(unsigned int cpu,
>  	return tdata;
>  }
>  
> -static int __cpuinit create_core_data(struct platform_device *pdev,
> -				unsigned int cpu, int pkg_flag)
> +static int create_core_data(struct platform_device *pdev, unsigned int cpu,
> +			    int pkg_flag)
>  {
>  	struct temp_data *tdata;
>  	struct platform_data *pdata = platform_get_drvdata(pdev);
> @@ -524,7 +521,7 @@ exit_free:
>  	return err;
>  }
>  
> -static void __cpuinit coretemp_add_core(unsigned int cpu, int pkg_flag)
> +static void coretemp_add_core(unsigned int cpu, int pkg_flag)
>  {
>  	struct platform_device *pdev = coretemp_get_pdev(cpu);
>  	int err;
> @@ -607,7 +604,7 @@ static struct platform_driver coretemp_driver = {
>  	.remove = coretemp_remove,
>  };
>  
> -static int __cpuinit coretemp_device_add(unsigned int cpu)
> +static int coretemp_device_add(unsigned int cpu)
>  {
>  	int err;
>  	struct platform_device *pdev;
> @@ -651,7 +648,7 @@ exit:
>  	return err;
>  }
>  
> -static void __cpuinit coretemp_device_remove(unsigned int cpu)
> +static void coretemp_device_remove(unsigned int cpu)
>  {
>  	struct pdev_entry *p, *n;
>  	u16 phys_proc_id = TO_PHYS_ID(cpu);
> @@ -667,7 +664,7 @@ static void __cpuinit coretemp_device_remove(unsigned int cpu)
>  	mutex_unlock(&pdev_list_mutex);
>  }
>  
> -static bool __cpuinit is_any_core_online(struct platform_data *pdata)
> +static bool is_any_core_online(struct platform_data *pdata)
>  {
>  	int i;
>  
> @@ -681,7 +678,7 @@ static bool __cpuinit is_any_core_online(struct platform_data *pdata)
>  	return false;
>  }
>  
> -static void __cpuinit get_core_online(unsigned int cpu)
> +static void get_core_online(unsigned int cpu)
>  {
>  	struct cpuinfo_x86 *c = &cpu_data(cpu);
>  	struct platform_device *pdev = coretemp_get_pdev(cpu);
> @@ -723,7 +720,7 @@ static void __cpuinit get_core_online(unsigned int cpu)
>  	coretemp_add_core(cpu, 0);
>  }
>  
> -static void __cpuinit put_core_offline(unsigned int cpu)
> +static void put_core_offline(unsigned int cpu)
>  {
>  	int i, indx;
>  	struct platform_data *pdata;
> @@ -771,7 +768,7 @@ static void __cpuinit put_core_offline(unsigned int cpu)
>  		coretemp_device_remove(cpu);
>  }
>  
> -static int __cpuinit coretemp_cpu_callback(struct notifier_block *nfb,
> +static int coretemp_cpu_callback(struct notifier_block *nfb,
>  				 unsigned long action, void *hcpu)
>  {
>  	unsigned int cpu = (unsigned long) hcpu;
> diff --git a/drivers/hwmon/via-cputemp.c b/drivers/hwmon/via-cputemp.c
> index 76f157b..38944e9 100644
> --- a/drivers/hwmon/via-cputemp.c
> +++ b/drivers/hwmon/via-cputemp.c
> @@ -221,7 +221,7 @@ struct pdev_entry {
>  static LIST_HEAD(pdev_list);
>  static DEFINE_MUTEX(pdev_list_mutex);
>  
> -static int __cpuinit via_cputemp_device_add(unsigned int cpu)
> +static int via_cputemp_device_add(unsigned int cpu)
>  {
>  	int err;
>  	struct platform_device *pdev;
> @@ -262,7 +262,7 @@ exit:
>  	return err;
>  }
>  
> -static void __cpuinit via_cputemp_device_remove(unsigned int cpu)
> +static void via_cputemp_device_remove(unsigned int cpu)
>  {
>  	struct pdev_entry *p;
>  
> @@ -279,8 +279,8 @@ static void __cpuinit via_cputemp_device_remove(unsigned int cpu)
>  	mutex_unlock(&pdev_list_mutex);
>  }
>  
> -static int __cpuinit via_cputemp_cpu_callback(struct notifier_block *nfb,
> -				 unsigned long action, void *hcpu)
> +static int via_cputemp_cpu_callback(struct notifier_block *nfb,
> +				    unsigned long action, void *hcpu)
>  {
>  	unsigned int cpu = (unsigned long) hcpu;
>  
> -- 
> 1.8.1.2
> 
> 
> _______________________________________________
> lm-sensors mailing list
> lm-sensors@lm-sensors.org
> http://lists.lm-sensors.org/mailman/listinfo/lm-sensors
> 

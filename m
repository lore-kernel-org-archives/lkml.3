Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbaBZQlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 11:41:52 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:42171 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaBZQlu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:41:50 -0500
X-Originating-IP: 50.43.14.201
Date: Wed, 26 Feb 2014 08:41:42 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org
Subject: Re: [PATCH v2] drivers: cpufreq: Mark function as static in cpufreq.c
Message-ID: <20140226164142.GA18079@thin>
References: <linux-pm@vger.kernel.org20140226154625.GA10701@rashika>
 <1393432706-25708-1-git-send-email-rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1393432706-25708-1-git-send-email-rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 10:08:26PM +0530, Rashika Kheria wrote:
> Mark function as static in cpufreq.c because it is not
> used outside this file.
> 
> This eliminates the following warning in cpufreq.c:
> drivers/cpufreq/cpufreq.c:355:9: warning: no previous prototype for ‘show_boost’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

I don't see any uses of this function in cpufreq.c; have uses appeared
in a development branch?

>  drivers/cpufreq/cpufreq.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 08ca8c9..54fd670 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -352,7 +352,7 @@ EXPORT_SYMBOL_GPL(cpufreq_notify_post_transition);
>  /*********************************************************************
>   *                          SYSFS INTERFACE                          *
>   *********************************************************************/
> -ssize_t show_boost(struct kobject *kobj,
> +static ssize_t show_boost(struct kobject *kobj,
>  				 struct attribute *attr, char *buf)
>  {
>  	return sprintf(buf, "%d\n", cpufreq_driver->boost_enabled);
> -- 
> 1.7.9.5
> 

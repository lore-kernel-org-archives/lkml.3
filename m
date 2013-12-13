Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab3LMI5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 03:57:44 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:49631 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab3LMI5n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 03:57:43 -0500
X-Originating-IP: 50.43.14.201
Date: Fri, 13 Dec 2013 00:57:35 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        device-drivers-devel@blackfin.uclinux.org
Subject: Re: [PATCH 4/5] drivers: misc: Mark functions as static in
 ad525x_dpot.c
Message-ID: <20131213085734.GD4386@leaf>
References: <40521f78bafae3cc4e796c540d3c497d79eeb63e.1386915618.git.rashika.kheria@gmail.com>
 <e96ca2e8c4c331f556363a7dc2046a07da230e3c.1386915618.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e96ca2e8c4c331f556363a7dc2046a07da230e3c.1386915618.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 12:27:10PM +0530, Rashika Kheria wrote:
> This patch marks the function ad_dpot_add_files() and
> ad_dpot_remove_files() as static in ad525x_dpot.c because they are not
> used outside this file.
> 
> Thus, it also eliminates the following warnings in ad525x_dpot.c:
> drivers/misc/ad525x_dpot.c:644:5: warning: no previous prototype for ‘ad_dpot_add_files’ [-Wmissing-prototypes]
> drivers/misc/ad525x_dpot.c:669:13: warning: no previous prototype for ‘ad_dpot_remove_files’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/misc/ad525x_dpot.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/misc/ad525x_dpot.c b/drivers/misc/ad525x_dpot.c
> index 0daadcf..d3eee11 100644
> --- a/drivers/misc/ad525x_dpot.c
> +++ b/drivers/misc/ad525x_dpot.c
> @@ -641,7 +641,7 @@ static const struct attribute_group ad525x_group_commands = {
>  	.attrs = ad525x_attributes_commands,
>  };
>  
> -int ad_dpot_add_files(struct device *dev,
> +static int ad_dpot_add_files(struct device *dev,
>  		unsigned features, unsigned rdac)
>  {
>  	int err = sysfs_create_file(&dev->kobj,
> @@ -666,7 +666,7 @@ int ad_dpot_add_files(struct device *dev,
>  	return err;
>  }
>  
> -inline void ad_dpot_remove_files(struct device *dev,
> +static inline void ad_dpot_remove_files(struct device *dev,
>  		unsigned features, unsigned rdac)
>  {
>  	sysfs_remove_file(&dev->kobj,
> -- 
> 1.7.9.5
> 

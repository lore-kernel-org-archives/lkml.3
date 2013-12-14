Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab3LNUec (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 15:34:32 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:53131 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab3LNUeb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 15:34:31 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 14 Dec 2013 12:34:25 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>
Subject: Re: [PATCH 3/3] drivers: rapidio: Remove unused function
 rio_remove_sysfs_dev_files() in rio-sysfs.c
Message-ID: <20131214203425.GJ17601@leaf>
References: <8522e3b2fefdb6625e9d7ae651cfa2dfd4733293.1386926041.git.rashika.kheria@gmail.com>
 <63f565ae73de586db2277390618fa781535a55f9.1386926041.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <63f565ae73de586db2277390618fa781535a55f9.1386926041.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 06:23:10PM +0530, Rashika Kheria wrote:
> This patch removes the function rio_remove_sysfs_dev_files() in
> rio-sysfs.c because it is unused.
> 
> Thus, it also eliminates the following warning in rio-sysfs.c:
> drivers/rapidio/rio-sysfs.c:295:6: warning: no previous prototype for ‘rio_remove_sysfs_dev_files’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/rapidio/rio-sysfs.c |   16 ----------------
>  1 file changed, 16 deletions(-)
> 
> diff --git a/drivers/rapidio/rio-sysfs.c b/drivers/rapidio/rio-sysfs.c
> index e0221c6..8929b9e 100644
> --- a/drivers/rapidio/rio-sysfs.c
> +++ b/drivers/rapidio/rio-sysfs.c
> @@ -286,22 +286,6 @@ int rio_create_sysfs_dev_files(struct rio_dev *rdev)
>  	return err;
>  }
>  
> -/**
> - * rio_remove_sysfs_dev_files - cleanup RIO specific sysfs files
> - * @rdev: device whose entries we should free
> - *
> - * Cleanup when @rdev is removed from sysfs.
> - */
> -void rio_remove_sysfs_dev_files(struct rio_dev *rdev)
> -{
> -	device_remove_bin_file(&rdev->dev, &rio_config_attr);
> -	if (rdev->pef & RIO_PEF_SWITCH) {
> -		device_remove_file(&rdev->dev, &dev_attr_routes);
> -		device_remove_file(&rdev->dev, &dev_attr_lnext);
> -		device_remove_file(&rdev->dev, &dev_attr_hopcount);
> -	}
> -}
> -
>  static ssize_t bus_scan_store(struct bus_type *bus, const char *buf,
>  				size_t count)
>  {
> -- 
> 1.7.9.5
> 

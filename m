Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbaLHERd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 23:17:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:51276 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991AbaLHERb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 23:17:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="426326529"
Message-ID: <1418012224.19126.22.camel@rzhang1-toshiba>
Subject: Re: [PATCH] thermal: Fix error path in thermal_init()
From: Zhang Rui <rui.zhang@intel.com>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Eduardo Valentin <edubezval@gmail.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Mon, 08 Dec 2014 12:17:04 +0800
In-Reply-To: <1417641621-5674-1-git-send-email-luis.henriques@canonical.com>
References: <1417641621-5674-1-git-send-email-luis.henriques@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-03 at 21:20 +0000, Luis Henriques wrote:
> thermal_unregister_governors() and class_unregister() were being called in
> the wrong order.
> 
> Fixes: 80a26a5c22b9 ("Thermal: build thermal governors into thermal_sys module")
> Cc: stable@vger.kernel.org
> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>

applied.

thanks,
rui
> ---
>  drivers/thermal/thermal_core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index 43b90709585f..488e9bfd996b 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -1835,10 +1835,10 @@ static int __init thermal_init(void)
>  
>  exit_netlink:
>  	genetlink_exit();
> -unregister_governors:
> -	thermal_unregister_governors();
>  unregister_class:
>  	class_unregister(&thermal_class);
> +unregister_governors:
> +	thermal_unregister_governors();
>  error:
>  	idr_destroy(&thermal_tz_idr);
>  	idr_destroy(&thermal_cdev_idr);



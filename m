Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab3LNU50 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 15:57:26 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:49704 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab3LNU5Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 15:57:25 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 14 Dec 2013 12:57:17 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, devel@linuxdriverproject.org
Subject: Re: [PATCH] drivers: hv: Mark the function hv_synic_free_cpu() as
 static in hv.c
Message-ID: <20131214205717.GR17601@leaf>
References: <20131214133006.GA8773@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131214133006.GA8773@rashika>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 07:00:06PM +0530, Rashika Kheria wrote:
> This patch marks the function hv_synic_free_cpu() as static in hv.c
> because it is not used outside this file.
> 
> Thus, it also eliminates the following warning in hv.c:
> drivers/hv/hv.c:304:6: warning: no previous prototype for ‘hv_synic_free_cpu’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/hv/hv.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
> index f0c5e07..bcb4950 100644
> --- a/drivers/hv/hv.c
> +++ b/drivers/hv/hv.c
> @@ -301,7 +301,7 @@ err:
>  	return -ENOMEM;
>  }
>  
> -void hv_synic_free_cpu(int cpu)
> +static void hv_synic_free_cpu(int cpu)
>  {
>  	kfree(hv_context.event_dpc[cpu]);
>  	if (hv_context.synic_event_page[cpu])
> -- 
> 1.7.9.5
> 

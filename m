Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab3LNU2W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 15:28:22 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:34045 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab3LNU2U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 15:28:20 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 14 Dec 2013 12:28:12 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <bp@alien8.de>, linux-edac@vger.kernel.org
Subject: Re: [PATCH 1/3] drivers: edac: Mark the function
 amd64_decode_bus_error() as static in amd64_edac.c
Message-ID: <20131214202812.GC17601@leaf>
References: <7cddbd4c69ed493f183383e98853181aaf75b26b.1387029387.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7cddbd4c69ed493f183383e98853181aaf75b26b.1387029387.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 07:28:24PM +0530, Rashika Kheria wrote:
> This patch marks the function amd64_decode_bus_error() as static in
> amd64_edac.c because it is not used outside this file.
> 
> Thus, it also eliminates the following warning in amd64_edac.c:
> drivers/edac/amd64_edac.c:2038:6: warning: no previous prototype for ‘amd64_decode_bus_error’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/edac/amd64_edac.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index b53d0de..52b34ea 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -2035,7 +2035,7 @@ static inline void __amd64_decode_bus_error(struct mem_ctl_info *mci,
>  	__log_bus_error(mci, &err, ecc_type);
>  }
>  
> -void amd64_decode_bus_error(int node_id, struct mce *m)
> +static void amd64_decode_bus_error(int node_id, struct mce *m)
>  {
>  	__amd64_decode_bus_error(mcis[node_id], m);
>  }
> -- 
> 1.7.9.5
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbaGHS7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 14:59:33 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46588 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907AbaGHS7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 14:59:32 -0400
Date: Tue, 8 Jul 2014 14:59:24 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
Cc: Wei Liu <wei.liu2@citrix.com>, Ian Campbell <Ian.Campbell@citrix.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [Xen-devel] [PATCH net-next v4] xen-netback: Adding debugfs
 "io_ring_qX" files
Message-ID: <20140708185923.GA32404@laptop.dumpdata.com>
References: <1404845354-16237-1-git-send-email-zoltan.kiss@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404845354-16237-1-git-send-email-zoltan.kiss@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -246,8 +415,12 @@ static void backend_create_xenvif(struct backend_info *be)
>  
>  static void backend_disconnect(struct backend_info *be)
>  {
> -	if (be->vif)
> +	if (be->vif) {
> +#ifdef CONFIG_DEBUG_FS
> +		xenvif_debugfs_delif(be->vif);
> +#endif /* CONFIG_DEBUG_FS */
>  		xenvif_disconnect(be->vif);
> +	}
>  }
>  
>  static void backend_connect(struct backend_info *be)
> @@ -560,6 +733,9 @@ static void connect(struct backend_info *be)
>  			be->vif->num_queues = queue_index;
>  			goto err;
>  		}
> +#ifdef CONFIG_DEBUG_FS
> +		xenvif_debugfs_addif(queue);
> +#endif /* CONFIG_DEBUG_FS */

You really like those /* CONFIG_DEBUG_FS */ comments, eh :-)

>  	}
>  
>  	/* Initialisation completed, tell core driver the number of
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel

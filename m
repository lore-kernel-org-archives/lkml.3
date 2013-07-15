Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab3GONiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 09:38:52 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53943 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755502Ab3GONiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 09:38:50 -0400
Message-ID: <1373895529.2062.15.camel@joe-AO722>
Subject: Re: [PATCH-v2 06/17] staging/lustre: remove HIPQUAD
From: Joe Perches <joe@perches.com>
To: Peng Tao <bergwolf@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Andreas Dilger <andreas.dilger@intel.com>
Date: Mon, 15 Jul 2013 06:38:49 -0700
In-Reply-To: <1373893695-4094-7-git-send-email-bergwolf@gmail.com>
References: <1373893695-4094-1-git-send-email-bergwolf@gmail.com>
	 <1373893695-4094-7-git-send-email-bergwolf@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-15 at 21:08 +0800, Peng Tao wrote:
[]
> We should just remove HIPQUAD and replace it with %pI4.

HIPQUAD and NIPQUAD were host and network order variants.
Perhaps you need %pI4h for the host uses?

> diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
[]
> @@ -2574,8 +2574,8 @@ kiblnd_dev_need_failover(kib_dev_t *dev)
>  	rc = rdma_resolve_addr(cmid, (struct sockaddr *)&srcaddr,
>  			       (struct sockaddr *)&dstaddr, 1);
>  	if (rc != 0 || cmid->device == NULL) {
> -		CERROR("Failed to bind %s:%u.%u.%u.%u to device(%p): %d\n",
> -		       dev->ibd_ifname, HIPQUAD(dev->ibd_ifip),
> +		CERROR("Failed to bind %s:%pI4 to device(%p): %d\n",
> +		       dev->ibd_ifname, &dev->ibd_ifip,
>  		       cmid->device, rc);

Like this one?


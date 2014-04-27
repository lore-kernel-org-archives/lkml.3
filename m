Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbaD0WGE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 18:06:04 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:32845 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaD0WGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 18:06:01 -0400
Date: Sun, 27 Apr 2014 23:05:48 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Dmitry Eremin <dmitry.eremin@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: Re: [PATCH 1/5] staging/lustre/lnet: fix potential null pointer
 dereference
Message-ID: <20140427230548.347fbb21@alan.etchedpixels.co.uk>
In-Reply-To: <1398633446-16719-2-git-send-email-green@linuxhacker.ru>
References: <1398633446-16719-1-git-send-email-green@linuxhacker.ru>
	<1398633446-16719-2-git-send-email-green@linuxhacker.ru>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Reviewed-by: John L. Hammond <john.hammond@intel.com>
> Reviewed-by: Isaac Huang <he.huang@intel.com>
> Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
> ---
>  drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
> index 21d36ee..516f623 100644
> --- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
> +++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
> @@ -829,14 +829,14 @@ ksocknal_select_ips(ksock_peer_t *peer, __u32 *peerips, int n_peerips)
>  				best_npeers = iface->ksni_npeers;
>  			}
>  
> +			LASSERT(best_iface != NULL);
> +

And this solves the problem how ???

These dont' appear that helpful. If we dereference a NULL point we'll
already get a suitably spectacular oops and call trace dump.

Alan

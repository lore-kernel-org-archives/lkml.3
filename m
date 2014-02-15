Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbaBOUki (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 15:40:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53586 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbaBOUkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 15:40:37 -0500
Date: Sat, 15 Feb 2014 12:41:58 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] staging: r8188eu: delete unnecessary field
 initialization
Message-ID: <20140215204158.GA15040@kroah.com>
References: <1392449773-23429-2-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392449773-23429-2-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 08:36:12AM +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> On success, the function netdev_alloc_skb initializes the dev field of its
> result to its first argument, so this doesn't have to be done in the
> calling context.
> 
> The semantic patch that fixes this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression skb,privn,e;
> @@
> 
> skb = netdev_alloc_skb(privn,...);
> ... when strict
> (
> -skb->dev = privn;
> |
> ?skb = e
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  drivers/staging/rtl8188eu/hal/usb_ops_linux.c |    1 -
>  1 file changed, 1 deletion(-)

No longer applies to my tree :(


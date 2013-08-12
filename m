Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab3HLTOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 15:14:47 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:56025 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab3HLTOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 15:14:45 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+EEn/zbY5Yf3g+wpqy6Z4rOCvAB61iFwg=
Date: Mon, 12 Aug 2013 15:14:07 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Andrew Lunn <andrew@lunn.ch>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 15/16] arch/arm/mach-kirkwood: Avoid using
 ARRAY_AND_SIZE(e) as a function argument
Message-ID: <20130812191407.GS25111@titan.lakedaemon.net>
References: <1376239917-15594-1-git-send-email-Julia.Lawall@lip6.fr>
 <1376239917-15594-16-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376239917-15594-16-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 11, 2013 at 06:51:56PM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Replace ARRAY_AND_SIZE(e) in function argument position to avoid hiding the
> arity of the called function.
> 
> The semantic match that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression e,f;
> @@
> 
> f(...,
> - ARRAY_AND_SIZE(e)
> + e,ARRAY_SIZE(e)
>   ,...)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
> Not compiled.

compiled fine on arm.

>  arch/arm/mach-kirkwood/openrd-setup.c    |    3 ++-
>  arch/arm/mach-kirkwood/rd88f6281-setup.c |    4 +++-
>  2 files changed, 5 insertions(+), 2 deletions(-)

Applied to mvebu/boards

thx,

Jason.

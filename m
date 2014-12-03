Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933776AbaLCAOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 19:14:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44496 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933489AbaLCAOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 19:14:09 -0500
Date: Tue, 2 Dec 2014 16:14:08 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: dborkman@redhat.com, herbert@gondor.apana.org.au,
        kernel-janitors@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 8/8] wusb: replace memset by memzero_explicit
Message-ID: <20141203001408.GB21569@kroah.com>
References: <1417366774-32412-1-git-send-email-Julia.Lawall@lip6.fr>
 <1417366774-32412-9-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417366774-32412-9-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 30, 2014 at 05:59:34PM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Memset on a local variable may be removed when it is called just before the
> variable goes out of scope.  Using memzero_explicit defeats this
> optimization.  A simplified version of the semantic patch that makes this
> change is as follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> identifier x;
> type T;
> @@
> 
> {
> ... when any
> T x[...];
> ... when any
>     when exists
> - memset
> + memzero_explicit
>   (x,
> -0,
>   ...)
> ... when != x
>     when strict
> }
> // </smpl>
> 
> This change was suggested by Daniel Borkmann <dborkman@redhat.com>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
> Daniel Borkmann suggested that these patches could go through Herbert Xu's
> cryptodev tree.

Why?  There's no dependancy on anything in the cryptodev tree,
memzero_explicit is in Linus's tree now.

thanks,

greg k-h

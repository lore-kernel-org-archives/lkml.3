Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751135AbaG1DOO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 23:14:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42094 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaG1DON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 23:14:13 -0400
Date: Sun, 27 Jul 2014 20:13:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Anil Belur <askb23@gmail.com>
Cc: daeseok.youn@gmail.com, shaun@xresource.ca, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] drivers: staging: cxt1e1: linux.c - missing __user
 annotation
Message-ID: <20140728031346.GA7585@kroah.com>
References: <1406516909-5338-1-git-send-email-askb23@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406516909-5338-1-git-send-email-askb23@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 08:38:29AM +0530, Anil Belur wrote:
> From: Anil Belur <askb23@gmail.com>
> 
> - Some of the functions internally call copy_{to,from}_user() but does
>   not use '__user'. this patch fixes missing __user annotations.
> - this patch fixes the following sparse errors:
> drivers/staging/cxt1e1/linux.c:488:33: warning: incorrect type in argument 2 (different address spaces)
> drivers/staging/cxt1e1/linux.c:488:33:    expected void const [noderef] <asn:1>*from
> drivers/staging/cxt1e1/linux.c:488:33:    got void *data
> drivers/staging/cxt1e1/linux.c:499:26: warning: incorrect type in argument 1 (different address spaces)
> drivers/staging/cxt1e1/linux.c:499:26:    expected void [noderef] <asn:1>*to
> drivers/staging/cxt1e1/linux.c:499:26:    got void *data
> drivers/staging/cxt1e1/linux.c:512:33: warning: incorrect type in argument 2 (different address spaces)
> drivers/staging/cxt1e1/linux.c:512:33:    expected void const [noderef] <asn:1>*from
> drivers/staging/cxt1e1/linux.c:512:33:    got void *data
> drivers/staging/cxt1e1/linux.c:534:33: warning: incorrect type in argument 2 (different address spaces)
> drivers/staging/cxt1e1/linux.c:534:33:    expected void const [noderef] <asn:1>*from
> drivers/staging/cxt1e1/linux.c:534:33:    got void *data
> drivers/staging/cxt1e1/linux.c:550:33: warning: incorrect type in argument 2 (different address spaces)
> drivers/staging/cxt1e1/linux.c:550:33:    expected void const [noderef] <asn:1>*from
> drivers/staging/cxt1e1/linux.c:550:33:    got void *data
> drivers/staging/cxt1e1/linux.c:558:26: warning: incorrect type in argument 1 (different address spaces)
> drivers/staging/cxt1e1/linux.c:558:26:    expected void [noderef] <asn:1>*to
> drivers/staging/cxt1e1/linux.c:558:26:    got void *data
> drivers/staging/cxt1e1/linux.c:571:33: warning: incorrect type in argument 2 (different address spaces)
> drivers/staging/cxt1e1/linux.c:571:33:    expected void const [noderef] <asn:1>*from
> drivers/staging/cxt1e1/linux.c:571:33:    got void *data
> drivers/staging/cxt1e1/linux.c:580:26: warning: incorrect type in argument 1 (different address spaces)
> drivers/staging/cxt1e1/linux.c:580:26:    expected void [noderef] <asn:1>*to
> drivers/staging/cxt1e1/linux.c:580:26:    got void *data
> drivers/staging/cxt1e1/linux.c:593:33: warning: incorrect type in argument 2 (different address spaces)
> drivers/staging/cxt1e1/linux.c:593:33:    expected void const [noderef] <asn:1>*from
> drivers/staging/cxt1e1/linux.c:593:33:    got void *data
> drivers/staging/cxt1e1/linux.c:601:26: warning: incorrect type in argument 1 (different address spaces)
> drivers/staging/cxt1e1/linux.c:601:26:    expected void [noderef] <asn:1>*to
> drivers/staging/cxt1e1/linux.c:601:26:    got void *data
> drivers/staging/cxt1e1/linux.c:612:33: warning: incorrect type in argument 2 (different address spaces)
> drivers/staging/cxt1e1/linux.c:612:33:    expected void const [noderef] <asn:1>*from
> drivers/staging/cxt1e1/linux.c:612:33:    got void *data
> drivers/staging/cxt1e1/linux.c:620:26: warning: incorrect type in argument 1 (different address spaces)
> drivers/staging/cxt1e1/linux.c:620:26:    expected void [noderef] <asn:1>*to
> drivers/staging/cxt1e1/linux.c:620:26:    got void *data
> drivers/staging/cxt1e1/linux.c:631:33: warning: incorrect type in argument 2 (different address spaces)
> drivers/staging/cxt1e1/linux.c:631:33:    expected void const [noderef] <asn:1>*from
> drivers/staging/cxt1e1/linux.c:631:33:    got void *data
> drivers/staging/cxt1e1/linux.c:647:33: warning: incorrect type in argument 2 (different address spaces)
> drivers/staging/cxt1e1/linux.c:647:33:    expected void const [noderef] <asn:1>*from
> drivers/staging/cxt1e1/linux.c:647:33:    got void *data
> drivers/staging/cxt1e1/linux.c:673:34: warning: incorrect type in argument 2 (different address spaces)
> drivers/staging/cxt1e1/linux.c:673:34:    expected void const [noderef] <asn:1>*from
> drivers/staging/cxt1e1/linux.c:673:34:    got void *data
> drivers/staging/cxt1e1/linux.c:681:26: warning: incorrect type in argument 1 (different address spaces)
> drivers/staging/cxt1e1/linux.c:681:26:    expected void [noderef] <asn:1>*to
> drivers/staging/cxt1e1/linux.c:681:26:    got void *data
> drivers/staging/cxt1e1/linux.c:691:47: warning: incorrect type in argument 2 (different address spaces)
> drivers/staging/cxt1e1/linux.c:691:47:    expected void const [noderef] <asn:1>*from
> drivers/staging/cxt1e1/linux.c:691:47:    got void *data
> drivers/staging/cxt1e1/linux.c:738:33: warning: incorrect type in argument 2 (different address spaces)
> drivers/staging/cxt1e1/linux.c:738:33:    expected void const [noderef] <asn:1>*from
> drivers/staging/cxt1e1/linux.c:738:33:    got void *data
> drivers/staging/cxt1e1/linux.c:785:33: warning: incorrect type in argument 2 (different address spaces)
> drivers/staging/cxt1e1/linux.c:785:33:    expected void const [noderef] <asn:1>*from
> drivers/staging/cxt1e1/linux.c:785:33:    got void *data
> drivers/staging/cxt1e1/linux.c:839:14: warning: incorrect type in assignment (different address spaces)
> drivers/staging/cxt1e1/linux.c:839:14:    expected void *data
> drivers/staging/cxt1e1/linux.c:839:14:    got void [noderef] <asn:1>*
> drivers/staging/cxt1e1/linux.c:840:34: warning: incorrect type in argument 2 (different address spaces)
> drivers/staging/cxt1e1/linux.c:840:34:    expected void const [noderef] <asn:1>*from
> drivers/staging/cxt1e1/linux.c:840:34:    got void *data
> drivers/staging/cxt1e1/linux.c:891:42: warning: incorrect type in argument 1 (different address spaces)
> drivers/staging/cxt1e1/linux.c:891:42:    expected void [noderef] <asn:1>*to
> drivers/staging/cxt1e1/linux.c:891:42:    got void *data
> 
> Signed-off-by: Anil Belur <askb23@gmail.com>
> ---
>  drivers/staging/cxt1e1/linux.c | 30 +++++++++++++++---------------
>  1 file changed, 15 insertions(+), 15 deletions(-)

This file is no longer in my tree, or in linux-next :(

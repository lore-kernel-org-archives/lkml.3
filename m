Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbaH3Ums (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 16:42:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53864 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaH3Umr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 16:42:47 -0400
Date: Sat, 30 Aug 2014 13:42:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andreea-Cristina Bernat <bernat.ada@gmail.com>
Cc: Larry.Finger@lwfinger.net, oat.elena@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] rtl8188eu: Replace rcu_dereference() with
 rcu_access_pointer()
Message-ID: <20140830204246.GA16563@kroah.com>
References: <20140817114336.GA24984@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140817114336.GA24984@ada>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2014 at 02:43:37PM +0300, Andreea-Cristina Bernat wrote:
> The "rcu_dereference()" call is used directly in a condition.
> Since its return value is never dereferenced it is recommended to use
> "rcu_access_pointer()" instead of "rcu_dereference()".
> Therefore, this patch makes the replacement.
> 
> The following Coccinelle semantic patch was used:
> @@
> @@
> 
> (
>  if(
>  (<+...
> - rcu_dereference
> + rcu_access_pointer
>   (...)
>   ...+>)) {...}
> |
>  while(
>  (<+...
> - rcu_dereference
> + rcu_access_pointer
>   (...)
>   ...+>)) {...}
> )
> 
> Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
> ---
>  drivers/staging/rtl8188eu/core/rtw_mlme.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

This patch fails to apply to my tree, can you refresh it against the
staging-next branch of the staging.git tree on kernel.org and resend?

thanks,

greg k-h

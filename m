Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaH3VEf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 17:04:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53979 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaH3VEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 17:04:33 -0400
Date: Sat, 30 Aug 2014 14:04:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andreea-Cristina Bernat <bernat.ada@gmail.com>
Cc: Larry.Finger@lwfinger.net, navin.patidar@gmail.com, davem@davemloft.net,
        jasowang@redhat.com, stsp@users.sourceforge.net, dborkman@redhat.com,
        Jes.Sorensen@redhat.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] os_dep: Replace rcu_dereference() with
 rcu_access_pointer()
Message-ID: <20140830210433.GA23431@kroah.com>
References: <20140817133916.GA12655@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140817133916.GA12655@ada>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2014 at 04:39:16PM +0300, Andreea-Cristina Bernat wrote:
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
>  drivers/staging/rtl8188eu/os_dep/os_intfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

This also doesn't apply :(

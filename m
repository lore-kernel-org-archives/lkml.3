Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab3LNUq1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 15:46:27 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:59368 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab3LNUq0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 15:46:26 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 14 Dec 2013 12:46:20 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [PATCH] drivers: memstick: Mark function
 memstick_debug_get_tpc_name() as static in r592.c
Message-ID: <20131214204620.GL17601@leaf>
References: <20131214130717.GA8361@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131214130717.GA8361@rashika>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 06:37:18PM +0530, Rashika Kheria wrote:
> This patch marks the function memstick_debug_get_tpc_name() as static in
> host/r592.c because it is not used outside this file.
> 
> Thus, it also eliminates the following warning in host/r592.c:
> drivers/memstick/host/r592.c:50:13: warning: no previous prototype for ‘memstick_debug_get_tpc_name’ [-Wmissing-prototypes]

In this case, memstick_debug_get_tpc_name is exported.  However, nothing
in the kernel uses it.  Thus, I'd suggest additionally deleting the
EXPORT_SYMBOL for it, leaving it as a static function only used
internally within that file.

>  drivers/memstick/host/r592.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/memstick/host/r592.c b/drivers/memstick/host/r592.c
> index 31727bf..1cd9307 100644
> --- a/drivers/memstick/host/r592.c
> +++ b/drivers/memstick/host/r592.c
> @@ -47,7 +47,7 @@ static const char *tpc_names[] = {
>   * memstick_debug_get_tpc_name - debug helper that returns string for
>   * a TPC number
>   */
> -const char *memstick_debug_get_tpc_name(int tpc)
> +static const char *memstick_debug_get_tpc_name(int tpc)
>  {
>  	return tpc_names[tpc-1];
>  }
> -- 
> 1.7.9.5
> 

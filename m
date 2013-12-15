Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab3LOUNQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 15:13:16 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:54130 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab3LOUNP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 15:13:15 -0500
X-Originating-IP: 50.43.14.201
Date: Sun, 15 Dec 2013 12:13:06 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [PATCH v2] drivers: memstick: Mark function
 memstick_debug_get_tpc_name() as static in r592.c
Message-ID: <20131215201305.GA9804@leaf>
References: <20131214130717.GA8361@rashika>
 <1387135382-26920-1-git-send-email-rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1387135382-26920-1-git-send-email-rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 12:53:02AM +0530, Rashika Kheria wrote:
> This patch marks the function memstick_debug_get_tpc_name() as static in
> host/r592.c because it is not used outside this file. It also removes the
> EXPORT_SYMBOL because the function is not used anywhere else in the
> kernel.
> 
> Thus, it also eliminates the following warning in host/r592.c:
> drivers/memstick/host/r592.c:50:13: warning: no previous prototype for ‘memstick_debug_get_tpc_name’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/memstick/host/r592.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/memstick/host/r592.c b/drivers/memstick/host/r592.c
> index 31727bf..d03aacb 100644
> --- a/drivers/memstick/host/r592.c
> +++ b/drivers/memstick/host/r592.c
> @@ -47,12 +47,10 @@ static const char *tpc_names[] = {
>   * memstick_debug_get_tpc_name - debug helper that returns string for
>   * a TPC number
>   */
> -const char *memstick_debug_get_tpc_name(int tpc)
> +static const char *memstick_debug_get_tpc_name(int tpc)
>  {
>  	return tpc_names[tpc-1];
>  }
> -EXPORT_SYMBOL(memstick_debug_get_tpc_name);
> -
>  
>  /* Read a register*/
>  static inline u32 r592_read_reg(struct r592_device *dev, int address)
> -- 
> 1.7.9.5
> 

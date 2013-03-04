Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab3CDChD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 21:37:03 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:36758 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685Ab3CDCg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 21:36:59 -0500
Message-ID: <1362364613.3221.144.camel@thor.lan>
Subject: Re: [PATCH] tty/serial: Fix uninitialized variable warning
From: Peter Hurley <peter@hurleysoftware.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sun, 03 Mar 2013 21:36:53 -0500
In-Reply-To: <1362360907-4439-1-git-send-email-grant.likely@secretlab.ca>
References: <1362360907-4439-1-git-send-email-grant.likely@secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-04 at 09:35 +0800, Grant Likely wrote:
> drivers/tty/serial/8250/8250.c: In function 'serial_unlink_irq_chain':
> drivers/tty/serial/8250/8250.c:1676:19: warning: 'i' may be used uninitialized in this function
> 
> There isn't an actual bug here since the function tests the condition
> that would cause i to be uninitialized before dereferencing i. However,
> at least some versions of GCC complain as shown above. (in my case,
> powerpc gcc 2.5.2). Initializing i to NULL makes it clear to GCC and the
> casual code reviewer that i will not be dereferenced to a random
> address.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> Greg, some may argue that this is a tool problem, not a kernel problem,
> but it is useful to me. If anyone objects I'm not going to spend any
> time championing for this patch.
> 
> g.
> 
>  drivers/tty/serial/8250/8250.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
> index 0efc815..cbbedcf 100644
> --- a/drivers/tty/serial/8250/8250.c
> +++ b/drivers/tty/serial/8250/8250.c
> @@ -1673,7 +1673,7 @@ static int serial_link_irq_chain(struct uart_8250_port *up)
>  
>  static void serial_unlink_irq_chain(struct uart_8250_port *up)
>  {
> -	struct irq_info *i;
> +	struct irq_info *i = NULL;

struct irq_info *uninitialized_var(i);

For gcc, the uninitialized_var() #define is in
include/linux/compiler-gcc.h

Regards,
Peter Hurley



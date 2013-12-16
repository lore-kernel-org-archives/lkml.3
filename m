Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab3LPLLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 06:11:22 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:36439 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab3LPLLU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 06:11:20 -0500
X-Originating-IP: 50.43.14.201
Date: Mon, 16 Dec 2013 03:11:13 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 2/2] drivers: tty: Mark the function hvc_poll_init() as
 static in hvc_console.c
Message-ID: <20131216111113.GB23211@leaf>
References: <0d40902c95942d272a70b1d85b4e311d0cc7afa4.1387191158.git.rashika.kheria@gmail.com>
 <0dc41f5b30bf9b5c94e658387ffaf092736c26b2.1387191158.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0dc41f5b30bf9b5c94e658387ffaf092736c26b2.1387191158.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 04:31:28PM +0530, Rashika Kheria wrote:
> Mark the function hvc_poll_init() as static in hvc/hvc_console.c because
> it is not used outside this file.
> 
> This eliminates the following warning in hvc/hvc_console.c:
> drivers/tty/hvc/hvc_console.c:791:5: warning: no previous prototype for ‘hvc_poll_init’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/tty/hvc/hvc_console.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
> index 9eba119..50b4688 100644
> --- a/drivers/tty/hvc/hvc_console.c
> +++ b/drivers/tty/hvc/hvc_console.c
> @@ -788,7 +788,7 @@ static int hvc_tiocmset(struct tty_struct *tty,
>  }
>  
>  #ifdef CONFIG_CONSOLE_POLL
> -int hvc_poll_init(struct tty_driver *driver, int line, char *options)
> +static int hvc_poll_init(struct tty_driver *driver, int line, char *options)
>  {
>  	return 0;
>  }
> -- 
> 1.7.9.5
> 

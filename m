Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374Ab3FDUNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 16:13:22 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42686 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab3FDUNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 16:13:20 -0400
Date: Tue, 4 Jun 2013 22:13:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Wang YanQing <udknight@gmail.com>, gregkh@linuxfoundation.org,
        sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TTY:vt: convert remain take_over_console's users to
 do_take_over_console
Message-ID: <20130604201317.GA16303@amd.pavel.ucw.cz>
References: <20130521051511.GA11435@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130521051511.GA11435@udknight>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2013-05-21 13:15:12, Wang YanQing wrote:
> Impact:
> 1:convert all remain take_over_console to do_take_over_console

This is step backwards.

> --- a/arch/alpha/kernel/console.c
> +++ b/arch/alpha/kernel/console.c
> @@ -61,7 +61,9 @@ locate_and_init_vga(void *(*sel_func)(void *, void *))
>  
>  	/* Set the VGA hose and init the new console. */
>  	pci_vga_hose = hose;
> -	take_over_console(&vga_con, 0, MAX_NR_CONSOLES-1, 1);
> +	console_lock();
> +	do_take_over_console(&vga_con, 0, MAX_NR_CONSOLES-1, 1);
> +	console_unlock();
>  }

Original was better.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

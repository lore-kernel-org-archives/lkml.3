Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaBXNCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 08:02:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58059 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbaBXNCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 08:02:08 -0500
Date: Mon, 24 Feb 2014 14:02:05 +0100
From: David Sterba <dsterba@suse.cz>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        Beat Bolli <bbolli@ewanet.ch>, Pavel Roskin <proski@gnu.org>,
        linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Felipe Balbi <balbi@ti.com>, Grant Edwards <grant.b.edwards@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Hal Murray <murray+fedora@ip-64-139-1-69.sjc.megapath.net>,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>, stable@vger.kernel.org
Subject: Re: [PATCH] tty: Fix low_latency BUG
Message-ID: <20140224130205.GD16073@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Peter Hurley <peter@hurleysoftware.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
	Beat Bolli <bbolli@ewanet.ch>, Pavel Roskin <proski@gnu.org>,
	linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
	Felipe Balbi <balbi@ti.com>,
	Grant Edwards <grant.b.edwards@gmail.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Hal Murray <murray+fedora@ip-64-139-1-69.sjc.megapath.net>,
	Alan Cox <gnomes@lxorguk.ukuu.org.uk>, stable@vger.kernel.org
References: <1393072281-5814-1-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393072281-5814-1-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 22, 2014 at 07:31:21AM -0500, Peter Hurley wrote:
> --- a/drivers/tty/ipwireless/tty.c
> +++ b/drivers/tty/ipwireless/tty.c
> @@ -176,9 +176,6 @@ void ipwireless_tty_received(struct ipw_tty *tty, unsigned char *data,
>  				": %d chars not inserted to flip buffer!\n",
>  				length - work);
>  
> -	/*
> -	 * This may sleep if ->low_latency is set
> -	 */

This is a no-op change for the ipwireless driver itself, nevertheless
here goes the maintainer's

Acked-by: David Sterba <dsterba@suse.cz>

>  	if (work)
>  		tty_flip_buffer_push(&tty->port);
>  }


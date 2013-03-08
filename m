Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246Ab3CHPDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 10:03:14 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:57728 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757966Ab3CHPDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 10:03:13 -0500
Message-ID: <1362754976.4219.29.camel@thor.lan>
Subject: Re: [PATCH 05/16] TTY: add tty_port_tty_wakeup helper
From: Peter Hurley <peter@hurleysoftware.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@linuxfoundation.org, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org
Date: Fri, 08 Mar 2013 10:02:56 -0500
In-Reply-To: <1362658360-26629-5-git-send-email-jslaby@suse.cz>
References: <1362658360-26629-1-git-send-email-jslaby@suse.cz>
	 <1362658360-26629-5-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-07 at 13:12 +0100, Jiri Slaby wrote:
> It allows for cleaning up on a considerable amount of places. They did
> port_get, wakeup, kref_put. Now the only thing needed is to call
> tty_port_tty_wakeup which does exactly that.
> 
> One exception is ifx6x60 where tty_wakeup was open-coded. We now call
> tty_wakeup properly there.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> ---
>  arch/um/drivers/line.c                  |  8 +-------

	Cc: Jeff Dike <jdike@addtoit.com>
	Cc: Richard Weinberger <richard@nod.at>

>  drivers/isdn/capi/capi.c                |  7 +------

	Cc: Karsten Keil <isdn@linux-pingi.de>

>  drivers/isdn/gigaset/interface.c        |  6 +-----

	Cc: Hansjoerg Lipp <hjlipp@web.de>
	Cc: Tilman Schmidt <tilman@imap.cc>
	Cc: gigaset307x-common@lists.sourceforge.net
	Cc: netdev@vger.kernel.org

>  drivers/net/usb/hso.c                   | 13 ++-----------

	Cc: Jan Dumon <j.dumon@option.com>
	Cc: linux-usb@vger.kernel.org

>  drivers/s390/char/sclp_tty.c            |  9 ++-------
>  drivers/s390/char/sclp_vt220.c          |  8 +-------

	Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
	Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
	Cc: linux390@de.ibm.com
	Cc: linux-s390@vger.kernel.org

>  drivers/staging/fwserial/fwserial.c     | 10 ++--------

	Cc: Me :)

>  drivers/staging/serqt_usb2/serqt_usb2.c |  7 +------

	Cc: YAMANE Toshiaki <yamanetoshi@gmail.com>
	Cc: Devendra Naga <devendra.aaru@gmail.com>

and so on...

Same for the other mega-patches.

>  drivers/tty/ehv_bytechan.c              |  6 +-----
>  drivers/tty/hvc/hvsi.c                  |  7 +------
>  drivers/tty/nozomi.c                    |  6 +-----
>  drivers/tty/serial/ifx6x60.c            | 33 ++-------------------------------
>  drivers/tty/tty_port.c                  | 16 ++++++++++++++++
>  drivers/usb/class/cdc-acm.c             |  7 +------
>  drivers/usb/serial/digi_acceleport.c    | 17 +++--------------
>  drivers/usb/serial/io_edgeport.c        | 28 +++++-----------------------
>  drivers/usb/serial/keyspan_pda.c        |  6 ++----
>  drivers/usb/serial/mos7720.c            |  8 ++------
>  drivers/usb/serial/mos7840.c            |  7 ++-----
>  drivers/usb/serial/ti_usb_3410_5052.c   |  7 ++-----
>  drivers/usb/serial/usb-serial.c         | 10 +---------
>  include/linux/tty.h                     |  1 +
>  22 files changed, 51 insertions(+), 176 deletions(-)



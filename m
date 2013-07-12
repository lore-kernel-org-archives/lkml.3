Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572Ab3GLKaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 06:30:30 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:39821 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757244Ab3GLKa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 06:30:29 -0400
Date: Fri, 12 Jul 2013 11:30:26 +0100
From: Gustavo Padovan <gustavo@padovan.org>
To: Gianluca Anzolin <gianluca@sottospazio.it>
Cc: jslaby@suse.cz, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix refcount leak in tty_port.c
Message-ID: <20130712103026.GC2065@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Gianluca Anzolin <gianluca@sottospazio.it>, jslaby@suse.cz,
	gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
References: <20130709083535.GA30227@debian.seek.priv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130709083535.GA30227@debian.seek.priv>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gianluca,

* Gianluca Anzolin <gianluca@sottospazio.it> [2013-07-09 10:35:35 +0200]:

> Hello,
> 
> In linux 3.10 in the file drivers/tty/tty_port.c the function
> tty_port_tty_hangup may leak a tty reference:
> 
>         struct tty_struct *tty = tty_port_tty_get(port);
> 
>         if (tty && (!check_clocal || !C_CLOCAL(tty))) {
>                 tty_hangup(tty);
>                 tty_kref_put(tty);
>         }
> 
> If tty != NULL and the second condition is false we never call tty_kref_put and
> the reference is leaked.
> 
> Fix by nesting two if statements.
> 
> Signed-off-by: Gianluca Anzolin <gianluca@sottospazio.it>

As mentioned by Gianluca this is a regression of aa27a094 and we depend on
this patch to go ahead with some fixes in the bluetooth subsystem.

Gianluca, it might help if you send a proper git inline formated patch,
mentioning the issue and which regression you are fixing. It makes
maintainer's life easier. Also add my Ack to the patch:

Acked-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>

	Gustavo

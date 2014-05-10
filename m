Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437AbaEJTgs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 15:36:48 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:38996 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757282AbaEJTgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 15:36:47 -0400
X-Originating-IP: 50.43.32.211
Date: Sat, 10 May 2014 12:36:40 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit
 and 32-bit ports
Message-ID: <20140510193640.GC12079@thin>
References: <20140509191914.GA7286@jtriplet-mobl1>
 <20140510171845.GA799@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140510171845.GA799@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 10, 2014 at 07:18:45PM +0200, Greg Kroah-Hartman wrote:
> On Fri, May 09, 2014 at 12:19:16PM -0700, Josh Triplett wrote:
> > @@ -827,6 +898,9 @@ static const struct memdev {
> >  #ifdef CONFIG_PRINTK
> >  	[11] = { "kmsg", 0644, &kmsg_fops, NULL },
> >  #endif
> > +#ifdef CONFIG_DEVPORT
> > +	 [12] = { "ioports", 0, &ioports_fops, NULL },
> 
> Odd extra space?

Copy/paste from the "port" device, which apparently has that space to
make "[4]" and "11" line up at the ones digit.  Will fix.

- Josh Triplett

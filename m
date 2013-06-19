Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934809Ab3FSO0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 10:26:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33530 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756731Ab3FSO0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 10:26:50 -0400
Date: Wed, 19 Jun 2013 07:27:31 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>, Jeff Mahoney <jeffm@suse.com>,
        jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-usb@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-geode@lists.infradead.org, linux-fbdev@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH] build some drivers only when compile-testing
Message-ID: <20130619142731.GA7979@kroah.com>
References: <1369214326-6558-1-git-send-email-jslaby@suse.cz>
 <20130523022327.GB6159@kroah.com>
 <519D8876.9050405@suse.com>
 <51BF6BFF.7050705@suse.cz>
 <51C1595D.60706@ti.com>
 <51C159F8.8090604@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C159F8.8090604@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 09:12:56AM +0200, Jiri Slaby wrote:
> On 06/19/2013 09:10 AM, Tomi Valkeinen wrote:
> > On 17/06/13 23:05, Jiri Slaby wrote:
> > 
> >> The last point I inclined to the Greg's argument to remove the
> >> EXPERT dependency.
> >> 
> >> So currently I have what is attached... Comments?
> > 
> > The patch looks a bit odd with the USB_CHIPIDEA_IMX parts. You're
> > not adding COMPILE_TEST there, but you're adding a totally new
> > config option, and also changing the Makefile.
> 
> Look:
> 
> +config USB_CHIPIDEA_IMX
> +       bool "ChipIdea IMX support"
> +       depends on OF_DEVICE && (ARM || COMPILE_TEST)

Ah, what about all of the chipidea chips on x86 boxes (yes, they are
rare, but they are present, so you can't just turn them off for that
whole platform here.

I'd leave chipidea alone, it's getting more prelevant, not on a desktop
or server, but in SoC systems, which is x86 for a lot of devices.

thanks,

greg k-h

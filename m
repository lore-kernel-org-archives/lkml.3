Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759706Ab3CHXLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 18:11:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754510Ab3CHXLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 18:11:46 -0500
Date: Fri, 8 Mar 2013 18:11:01 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 8250.nr_uarts broken in 3.7
Message-ID: <20130308231100.GN13719@hansolo.jdub.homelinux.org>
References: <5138E56B.6090308@suse.cz>
 <20130307191005.GH13719@hansolo.jdub.homelinux.org>
 <20130307211426.GI13719@hansolo.jdub.homelinux.org>
 <20130307231242.GC4280@kroah.com>
 <20130308010140.GJ13719@hansolo.jdub.homelinux.org>
 <20130308013923.GA12474@kroah.com>
 <20130308212722.GL13719@hansolo.jdub.homelinux.org>
 <513A6A65.9050706@suse.cz>
 <20130308224950.GM13719@hansolo.jdub.homelinux.org>
 <513A6D1F.5000202@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <513A6D1F.5000202@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 11:58:39PM +0100, Jiri Slaby wrote:
> On 03/08/2013 11:49 PM, Josh Boyer wrote:
> > On Fri, Mar 08, 2013 at 11:47:01PM +0100, Jiri Slaby wrote:
> >> Yeah, I agree this is ugly. Just re-definining MODULE_PARAM_PREFIX at
> >> the end of the file should do the trick (followed by
> >> "module_param(nr_uarts, uint, 0644)").
> > 
> > For some reason, I thought I had tried that.  Maybe I didn't.  I'll look
> > into it again.
> 
> I see. Because we would re-define some global variables. What if we put

Right.  For the peanut gallery, you get this error:

CC      drivers/tty/serial/8250/8250.o
drivers/tty/serial/8250/8250.c:3351:1: error: redefinition of ‘__check_share_irqs’
drivers/tty/serial/8250/8250.c:3333:1: note: previous definition of ‘__check_share_irqs’ was here
drivers/tty/serial/8250/8250.c:3351:1: error: redefinition of ‘__param_perm_check_share_irqs’
drivers/tty/serial/8250/8250.c:3333:1: note: previous definition of ‘__param_perm_check_share_irqs’ was here
drivers/tty/serial/8250/8250.c:3351:1: error: redefinition of ‘__param_str_share_irqs’
drivers/tty/serial/8250/8250.c:3333:1: note: previous definition of ‘__param_str_share_irqs’ was here
drivers/tty/serial/8250/8250.c:3351:1: error: redefinition of ‘__param_share_irqs’
drivers/tty/serial/8250/8250.c:3333:1: note: previous definition of ‘__param_share_irqs’ was here

for each variable you redefine like that.

> module_param into a function?

Not sure what you mean by that.

josh

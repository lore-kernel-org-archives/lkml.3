Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab3CTOmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 10:42:35 -0400
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:41429 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125Ab3CTOmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 10:42:33 -0400
Subject: Re: linux-next: build failure after merge of the tty tree
To: jslaby@suse.cz (Jiri Slaby)
Date: Wed, 20 Mar 2013 10:42:32 -0400
Cc: sfr@canb.auug.org.au (Stephen Rothwell), greg@kroah.com (Greg KH),
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <5149C4E8.5020707@suse.cz>
X-Mailer: ELM [version 2.5.8.59.gd925]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20130320144233.10125800E4@viridian.itc.virginia.edu>
From: wfp5p@viridian.itc.virginia.edu (Bill Pemberton)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby writes:
> 
> On 03/20/2013 01:51 PM, Bill Pemberton wrote:
> > Jiri Slaby writes:
> >>
> >>> drivers/usb/serial/quatech2.c: In function 'qt2_process_read_urb': 
> >>> drivers/usb/serial/quatech2.c:661:18: error: 'struct
> >>> qt2_port_private' has no member named 'is_open' 
> >>> drivers/usb/serial/quatech2.c:705:15: error: 'struct
> >>> qt2_port_private' has no member named 'is_open'
> >>>
> >>> Caused by commit e4408ce3c23f ("TTY: quatech2, remove unneeded 
> >>> is_open").  grep is your friend (or searching while editting the
> >>> file).
> >>
> >> I think this is caused by another commit. Bill added a check for
> >> is_open meanwhile I removed that member completely. Bill, could you
> >> fix that up, please?
> >>
> > 
> > Is it legal to call tty_flip_buffer_push() without an open tty?  If
> > so, I can get rid of the is_open logic completely.  Otherwise, I need
> > to either keep is_open or otherwise check for a valid tty before
> > calling tty_flip_buffer_push().
> 
> Yeah, it is legal to call that, as long as you have a valid tty_port.
> Now, the data are queued and later flushed. The plan is to throw the
> data directly on ingress in a way the drivers don't need to care.
> 

Ok, for the unopened ports there *should* never be any actual data to
push so the push is really doing nothing anyhow in these cases.  It's
coming from the device sending an initial change port command.

Anyhow, so my patch adding more is_open logic can be dropped and then
yours will apply fine.  What's the best way for me to handle this?
Send a revert for my patch so yours will apply or send an updated
version of your patch that removes my additions?


-- 
Bill

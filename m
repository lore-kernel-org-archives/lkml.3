Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934316Ab3CTMvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 08:51:39 -0400
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:40211 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932771Ab3CTMvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 08:51:38 -0400
Subject: Re: linux-next: build failure after merge of the tty tree
To: jslaby@suse.cz (Jiri Slaby)
Date: Wed, 20 Mar 2013 08:51:37 -0400
Cc: sfr@canb.auug.org.au (Stephen Rothwell), greg@kroah.com (Greg KH),
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <5149707F.5050003@suse.cz>
X-Mailer: ELM [version 2.5.8.59.gd925]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20130320125137.EDCD3802B0@viridian.itc.virginia.edu>
From: wfp5p@viridian.itc.virginia.edu (Bill Pemberton)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby writes:
> 
> > drivers/usb/serial/quatech2.c: In function 'qt2_process_read_urb': 
> > drivers/usb/serial/quatech2.c:661:18: error: 'struct
> > qt2_port_private' has no member named 'is_open' 
> > drivers/usb/serial/quatech2.c:705:15: error: 'struct
> > qt2_port_private' has no member named 'is_open'
> > 
> > Caused by commit e4408ce3c23f ("TTY: quatech2, remove unneeded 
> > is_open").  grep is your friend (or searching while editting the
> > file).
> 
> I think this is caused by another commit. Bill added a check for
> is_open meanwhile I removed that member completely. Bill, could you
> fix that up, please?
> 

Is it legal to call tty_flip_buffer_push() without an open tty?  If
so, I can get rid of the is_open logic completely.  Otherwise, I need
to either keep is_open or otherwise check for a valid tty before
calling tty_flip_buffer_push().

-- 
Bill

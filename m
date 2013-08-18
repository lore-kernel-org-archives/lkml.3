Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246Ab3HRUs7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:48:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43907 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868Ab3HRUs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:48:56 -0400
Date: Sun, 18 Aug 2013 13:50:42 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [ 41/45] m68k: Truncate base in do_div()
Message-ID: <20130818205042.GA22572@kroah.com>
References: <20130818203620.996166594@linuxfoundation.org>
 <20130818203623.850246787@linuxfoundation.org>
 <CAMuHMdWP2f_9526y9g5n=vf_Nga5XyC36JZhi7f5mMqMV4mW+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdWP2f_9526y9g5n=vf_Nga5XyC36JZhi7f5mMqMV4mW+w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 18, 2013 at 10:39:01PM +0200, Geert Uytterhoeven wrote:
> On Sun, Aug 18, 2013 at 10:36 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > 3.10-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Andreas Schwab <schwab@linux-m68k.org>
> >
> > commit ea077b1b96e073eac5c3c5590529e964767fc5f7 upstream.
> >
> > Explicitly truncate the second operand of do_div() to 32 bits to guard
> > against bogus code calling it with a 64-bit divisor.
> >
> > [Thorsten]
> >
> > After upgrading from 3.2 to 3.10, mounting a btrfs volume fails with:
> >
> > btrfs: setting nodatacow, compression disabled
> > btrfs: enabling auto recovery
> > btrfs: disk space caching is enabled
> 
> What happened to the rest of the commit message?

It looks like quilt will cut off the rest of the message after it sees
the "*** ZERO DIVIDE ***   FORMAT=2" line.

I don't know why it does that, never noticed that before, I'll go fix
this up, thanks.

greg k-h

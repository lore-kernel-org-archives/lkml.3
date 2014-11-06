Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303AbaKFCx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 21:53:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39192 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaKFCx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 21:53:26 -0500
Date: Wed, 5 Nov 2014 18:53:26 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Peter Hurley <peter@hurleysoftware.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH -next 05/10] tty: Document defunct ASYNC_* bits in uapi
 header
Message-ID: <20141106025326.GA21796@kroah.com>
References: <1413492867-20679-1-git-send-email-peter@hurleysoftware.com>
 <1413492867-20679-6-git-send-email-peter@hurleysoftware.com>
 <5440D781.1080308@suse.cz>
 <54410F19.3040607@hurleysoftware.com>
 <54411A30.6070401@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54411A30.6070401@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 03:31:28PM +0200, Jiri Slaby wrote:
> On 10/17/2014, 02:44 PM, Peter Hurley wrote:
> > Hi Jiri,
> > 
> > On 10/17/2014 04:46 AM, Jiri Slaby wrote:
> >> On 10/16/2014, 10:54 PM, Peter Hurley wrote:
> >>> Note the serial_struct flags for which the kernel ignores and performs
> >>> no action. The flags cannot be removed since they form part of the
> >>> userspace interface via the TIOCSSERIAL/TIOCGSERIAL ioctls.
> >>
> >> Hello,
> >>
> >> would it make sense to mark them deprecated somehow? At build time
> > 
> > A build warning when the macro is expanded would be best, but my
> > c-preprocessor-fu is terrible, so I have no idea how to make that work.
> 
> We can define a deprecated type like:
> 
> typedef __u32 __attribute__((deprecated)) depr_tty_t
> 
> and then do define:
> 
> #define ASYNCB_FLAG_1 (depr_tty_t)1
> #define ASYNCB_FLAG_2 (depr_tty_t)2
> 
> Etc.
> 
> However, I do not know if it is desirable AND whether all compilers out
> there used in userspace support that attribute.
> 
> >> or
> >> at least warn in the serial core that "current->comm is using a
> >> deprecated flag"_ratelimited()?
> > 
> > If we just print the message at TIOCSSERIAL if any of the deprecated
> > bits are set, that would be ok. Probably the only issue would be that
> > setserial could cause this message at will, so log flooding would be
> > a concern.
> 
> That's why _ratelimited(). So something like the patch attached. But it
> needs to be put to a separate function, out of the line.
> 
> /me currently builds a kernel to see who, if anybody, uses the flags on
> a up-to-date system...

What ever happened with this test?  Care to resend it as a "real" patch
so we can annoy userspace?  :)

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab3HLPwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 11:52:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54523 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756890Ab3HLPwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 11:52:21 -0400
Date: Mon, 12 Aug 2013 08:53:47 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Belisko Marek <marek.belisko@gmail.com>
Subject: Re: [PATCH tty-next] n_tty: Fix termios_rwsem lockdep false positive
Message-ID: <20130812155347.GA20696@kroah.com>
References: <20130731114726.GA11570@cpv436-motbuntu.spb.ea.mot-mobility.com>
 <1376222663-5666-1-git-send-email-peter@hurleysoftware.com>
 <20130812092810.GA26400@cpv436-motbuntu.spb.ea.mot-mobility.com>
 <20130812105041.GA2268@swordfish>
 <5208DB32.40304@hurleysoftware.com>
 <20130812131949.GA2297@swordfish>
 <5208E575.1080008@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5208E575.1080008@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 09:39:01AM -0400, Peter Hurley wrote:
> On 08/12/2013 09:19 AM, Sergey Senozhatsky wrote:
> >On (08/12/13 08:55), Peter Hurley wrote:
> >>>>>[..]
> >>>>>  drivers/tty/n_tty.c | 25 +++++++++++--------------
> >>>>>  1 file changed, 11 insertions(+), 14 deletions(-)
> >>>>>
> >>>
> >>>I hate to do this, but isn't it actually my patch posted here
> >>>https://lkml.org/lkml/2013/8/1/510
> >>>
> >>>which was tagged as `wrong'?
> >>
> >>Sergey,
> >>
> >>My apologies; I was mistaken regarding this problem being a lockdep
> >>regression (although it's still a false positive from lockdep). Once
> >>I had worked around some issues with the nouveau driver, I was able to
> >>reproduce the lockdep report on 3.10.
> >>
> >no problem.
> >
> >>I included Artem's lockdep report in the changelog because I received
> >>that first, on 30 July.
> >>
> >>My patch below is not the same as your patch of 1 Aug. This patch
> >>preserves the protected access of termios.c_cc[VMIN] and termios.c_cc[VTIME]
> >>(via the MIN_CHAR() and TIME_CHAR() macros).
> >
> >fair enough. v3 was protecting VMIN/VTIME (my bad, I noticed this a bit later),
> >but I didn't submit it since v2 did not get positive response.
> >
> >>If you'd prefer, I could add to changelog:
> >>
> >>    Patch based on original posted here https://lkml.org/lkml/2013/8/1/510
> >>    by Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> >
> >if you don't mind, that would be great.
> 
> Ok.
> 
> Greg,
> Should I re-spin a v2 to include the note above
> (or can you add it with Artem's Tested-by)?

I'll add it, no need to resend.

greg k-h

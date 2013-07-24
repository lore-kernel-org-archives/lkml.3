Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab3GXWPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:15:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55609 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab3GXWPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:15:19 -0400
Date: Wed, 24 Jul 2013 15:15:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Gianluca Anzolin <gianluca@sottospazio.it>,
        Gustavo Padovan <gustavo@padovan.org>, linux-kernel@vger.kernel.org,
        jslaby@suse.cz
Subject: Re: [PATCH] Fix refcount leak in tty_port.c
Message-ID: <20130724221518.GA21709@kroah.com>
References: <20130709083535.GA30227@debian.seek.priv>
 <20130712103026.GC2065@joana>
 <51E00CF1.6070302@hurleysoftware.com>
 <51EFE0A3.80709@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EFE0A3.80709@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 10:11:47AM -0400, Peter Hurley wrote:
> On 07/12/2013 10:04 AM, Peter Hurley wrote:
> >On 07/12/2013 06:30 AM, Gustavo Padovan wrote:
> >>Hi Gianluca,
> >>
> >>* Gianluca Anzolin <gianluca@sottospazio.it> [2013-07-09 10:35:35 +0200]:
> >>
> >>>Hello,
> >>>
> >>>In linux 3.10 in the file drivers/tty/tty_port.c the function
> >>>tty_port_tty_hangup may leak a tty reference:
> >>>
> >>>         struct tty_struct *tty = tty_port_tty_get(port);
> >>>
> >>>         if (tty && (!check_clocal || !C_CLOCAL(tty))) {
> >>>                 tty_hangup(tty);
> >>>                 tty_kref_put(tty);
> >>>         }
> >>>
> >>>If tty != NULL and the second condition is false we never call tty_kref_put and
> >>>the reference is leaked.
> >
> >Good catch.
> >
> >>>Fix by nesting two if statements.
> >>>
> >>>Signed-off-by: Gianluca Anzolin <gianluca@sottospazio.it>
> >>
> >>As mentioned by Gianluca this is a regression of aa27a094 and we depend on
> >>this patch to go ahead with some fixes in the bluetooth subsystem.
> >
> >Gustavo,
> >
> >There's no direct dependency; ie., there aren't merge issues here.
> >We should progress with the fixes to rfcomm independent of this patch.
> >
> >>Gianluca, it might help if you send a proper git inline formated patch,
> >>mentioning the issue and which regression you are fixing.  It makes
> >>maintainer's life easier.
> >
> >As Gustavo points out, please inline the patch otherwise commenters
> >have to do it for you.
> 
> Gianluca,
> 
> I think Greg may be expecting you to address the comments from myself
> and Gustavo before accepting this patch.
> 
> Greg, is that the case?

Yes, I thought a new version was coming, so I dropped this one.  Can
someone please fix this up and resend?

thanks,

greg k-h

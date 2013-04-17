Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965286Ab3DQQTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 12:19:36 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:63508 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965260Ab3DQQTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 12:19:34 -0400
Date: Wed, 17 Apr 2013 09:18:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kent Yoder <shpedoikal@gmail.com>
Cc: Duncan Laurie <dlaurie@chromium.org>, Dirk Hohndel <dirk@hohndel.org>,
        Kent Yoder <key@linux.vnet.ibm.com>,
        Luigi Semenzato <semenzato@chromium.org>,
        TPM Device Driver List <tpmdd-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] TPM: Retry SaveState command in suspend path
Message-ID: <20130417161848.GA8752@kroah.com>
References: <1363557399-11822-1-git-send-email-dlaurie@chromium.org>
 <CAM0nabGd1kPJaEOUNS9A1GOYP757F2SezgqYjK1p3N4AvX0PsA@mail.gmail.com>
 <20130416235751.GA9531@kroah.com>
 <CAM0nabG_iOcThp-9QvupWEi38q0y9Zg7pOpdmue6X7yEw7FRfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0nabG_iOcThp-9QvupWEi38q0y9Zg7pOpdmue6X7yEw7FRfw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 09:54:24AM -0500, Kent Yoder wrote:
> On Tue, Apr 16, 2013 at 6:57 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Tue, Mar 19, 2013 at 10:00:02AM -0500, Kent Yoder wrote:
> >> Hi Duncan,
> >>
> >> On Sun, Mar 17, 2013 at 4:56 PM, Duncan Laurie <dlaurie@chromium.org> wrote:
> >> > If the TPM has already been sent a SaveState command before the driver
> >> > is loaded it may have problems sending that same command again later.
> >> >
> >> > This issue is seen with the Chromebook Pixel due to a firmware bug in
> >> > the legacy mode boot path which is sending the SaveState command
> >> > before booting the kernel.  More information is available at
> >> > http://crbug.com/203524
> >> >
> >> > This change introduces a retry of the SaveState command in the suspend
> >> > path in order to work around this issue.  A future firmware update
> >> > should fix this but this is also a trivial workaround in the driver
> >> > that has no effect on systems that do not show this problem.
> >>
> >>   I'm not convinced that this needs to be upstream.  The simplest
> >> route would seem to be to carry this out of tree until your firmware
> >> is fixed.
> >
> > Really?  We have machines that we are using right now that need this fix
> > in order to work properly.
> >
> > The kernel handles buggy firmware/bioses all the time, we need to work
> > properly on all hardware, we can't count on a firmware update ever
> > getting pushed out publically, and for those of us using this hardware,
> > we want it to work.
> 
>   That makes sense -- on first read I thought this was an issue with
> Chrome OS only.  I see now this is an issue with reinstalling other
> OS's over Chrome.  I've staged this over here:
> 
> git://github.com/shpedoikal/linux.git tpmdd-04-17-13
> 
> and I'll push this to James later today.

Thank you very much, it's appreciated.  I'll watch out for it to hit
Linus's tree and add it to the -stable releases as well.

greg k-h

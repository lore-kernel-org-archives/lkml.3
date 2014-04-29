Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbaD2P0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 11:26:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757346AbaD2P0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 11:26:32 -0400
Date: Tue, 29 Apr 2014 17:26:17 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, Laurent Navet <laurent.navet@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: line6: fix possible overrun
Message-ID: <20140429152616.GA2316@mguzik.redhat.com>
References: <1398532162-23006-1-git-send-email-laurent.navet@gmail.com>
 <20140426204704.GB17562@mguzik.redhat.com>
 <20140426213137.GM26890@mwanda>
 <20140426215945.GC17562@mguzik.redhat.com>
 <20140427173932.GP26890@mwanda>
 <20140427200042.GA23846@mguzik.redhat.com>
 <20140427224425.GQ26890@mwanda>
 <s5h38gw9or4.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <s5h38gw9or4.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 04:47:11PM +0200, Takashi Iwai wrote:
> At Mon, 28 Apr 2014 01:44:25 +0300,
> Dan Carpenter wrote:
> > 
> > On Sun, Apr 27, 2014 at 10:00:43PM +0200, Mateusz Guzik wrote:
> > > > >  and a WARN_ON + -EINVAL in line6_init_audio to catch future
> > > > >  offenders.
> > > > 
> > > > Returning -EINVAL is a bad idea because it would break the driver
> > > > completely and make it unusable.
> > > > 
> > > 
> > > Well I would vote for returning the error anyway.
> > 
> > I'm trying to be polite, but you are talking about adding regressions
> > deliberately...
> > 
> > It's very rare for people to deliberately add regressions to the kernel.
> > I have only seen it one time before.
> 
> I don't think Dan would be against returning -EINVAL if all the
> offender codes have been fixed (e.g. truncating strings to fit with
> the fixed arrays) at first.  Then it'd be a good help to catch any
> future bugs.  But, having -EINVAL without fixing the caller side means
> essentially that you're introducing the breakage intentionally
> although you know it certainly breaks, which is obviously bad.
> 
> 

We clearly have a serious miscommunication here (and apparently it
started with me not addressing the concern of complete driver breakage).

line6_init_audio consumers have to be fixed first, no doubt about that.

I was only commenting on catching *future* offenders, which I thought
would implictly mean *afterwards*.

With that in mind it would seem we are in agreement after all. :-)

As far getting this done maybe OP is interested.

-- 
Mateusz Guzik

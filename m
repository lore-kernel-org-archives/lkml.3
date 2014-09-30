Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbaI3VGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:06:39 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36541 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaI3VGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:06:37 -0400
Date: Tue, 30 Sep 2014 23:06:34 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Tejun Heo <tj@kernel.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wu Zhangjin <falcon@meizu.com>, Takashi Iwai <tiwai@suse.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, hare@suse.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Benjamin Poirier <bpoirier@suse.de>,
        Santosh Rastapur <santosh@chelsio.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tim Gardner <tim.gardner@canonical.com>,
        Pierre Fersing <pierre-fersing@pierref.org>,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
        Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        Cas ey Leedom <leedom@chelsio.com>,
        Hariprasad S <hariprasad@chelsio.com>,
        MPT-FusionLinux.pdl@avagotech.com,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC v2 3/6] kthread: warn on kill signal if not OOM
Message-ID: <20140930210634.GC14283@amd>
References: <20140905174925.GA12991@mtj.dyndns.org>
 <20140911202354.GA2598@core.coreip.homeip.net>
 <20140922194906.GB9868@amd>
 <2306678.TJaWkZCAc8@dtor-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2306678.TJaWkZCAc8@dtor-glaptop>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon 2014-09-22 13:23:54, Dmitry Torokhov wrote:
> On Monday, September 22, 2014 09:49:06 PM Pavel Machek wrote:
> > On Thu 2014-09-11 13:23:54, Dmitry Torokhov wrote:
> > > On Thu, Sep 11, 2014 at 12:59:25PM -0700, James Bottomley wrote:

> > > > Yes, but we mostly do this anyway.  SCSI for instance does asynchronous
> > > > scanning of attached devices (once the cards are probed)
> > > 
> > > What would it do it card was a bit slow to probe?
> > > 
> > > > but has a sync
> > > > point for ordering.
> > > 
> > > Quite often we do not really care about ordering of devices. I mean,
> > > does it matter if your mouse is discovered before your keyboard or
> > > after?
> > 
> > Actually yes, I suspect it does.
> > 
> > I do evtest /dev/input/eventX by hand, occassionaly. It would be
> > annoying if they moved between reboots.
> 
> I am sorry but you will have to cope with such annoyances. It' snot like we 
> fail to boot the box here.
> 
> The systems are now mostly hot-pluggable and userland is supposed to
> handle it, and it does, at least for input devices. If you want stable naming
> use udev facilities to rename devices as needed or add needed symlinks (by-id, 
> etc.).

Well, it would be nice if udev was not mandatory. Do the sync points
for ordering actually cost us something?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

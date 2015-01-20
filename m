Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbbATNZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 08:25:08 -0500
Received: from mail.sig21.net ([80.244.240.74]:48089 "EHLO mail.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbbATNZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 08:25:06 -0500
Date: Tue, 20 Jan 2015 14:24:37 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: arnd@arndb.de, ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk,
        teg@jklm.no, jkosina@suse.cz, luto@amacapital.net,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        daniel@zonque.org, dh.herrmann@gmail.com, tixxdz@opendz.org
Subject: Re: [PATCH v3 00/13] Add kdbus implementation
Message-ID: <20150120132437.GB7545@sig21.net>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
 <20150119180642.GA27957@sig21.net>
 <20150119183806.GA8479@kroah.com>
 <20150119201906.GA337@sig21.net>
 <20150119203155.GA15441@kroah.com>
 <20150119233812.GA1874@sig21.net>
 <20150120011359.GE865@kroah.com>
 <20150120105712.GA6260@sig21.net>
 <20150120112609.GA17198@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150120112609.GA17198@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-21-Score: -2.9 (--)
X-Spam-21-Report: No, score=-2.9 required=8.0 tests=ALL_TRUSTED=-1,BAYES_00=-1.9,URIBL_BLOCKED=0.001 autolearn=ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 07:26:09PM +0800, Greg Kroah-Hartman wrote:
> On Tue, Jan 20, 2015 at 11:57:12AM +0100, Johannes Stezenbach wrote:
> > 
> > So I did some googling and found in QNX servers create a channel
> > to receive messages, and clients connect to this channel.
> > Multiple clients can connect to the channel.
> 
> Hence, a bus :)
> 
> > But it is not a bus -- no multicast/broadcast, and no name
> > service or policy rules like D-Bus has.  To me it looks
> > to be similar in functionality to UNIX domain sockets.
> 
> It's not as complex as D-Bus, but it's still subscribing to things and
> getting messages.

Apparently you don't read what I write, probably you're not interested
in this discussion anymore...
QNX uses the term "channel" but it does not refer to a bus
or subscription facility, it is more like a socket in listening state.

> > My guess is that the people porting from QNX were just confused
> > and their use of D-Bus was in error.  Maybe they should've used
> > plain sockets, capnproto, ZeroMQ or whatever.
> 
> I tend to trust that they knew what they were doing, they wouldn't have
> picked D-Bus for no good reason.

The automotive developers I had the pleasure to work with would
use anything which is available via a mouse click in the
commercial Embedded Linux SDK IDE of their choice :)
Let's face it: QNX has a single IPC solution while Linux has
a confusing multitude of possibilities.

> > Well, IMHO you got it backwards.  Before adding a complex new IPC
> > API to the kernel you should do the homework and gather some
> > evidence that there will be enough users to justify the addition.
> 
> systemd wants this today for early boot.  It will remove lots of code
> and enable a lot of good things to happen.  The first email in this
> thread describes this quite well, is that not sufficient?

The first mail in this thread doesn't even mention systemd,
instead it has a lot of "marketing" buzzwords.
Of course it is no secret that systemd is the driving force
behind kdbus, but no public record exists to explain why
kdbus was chosen and designed the way it is, what alternatives
were considered and rejected etc.  (or if there is, please send a link)

> > FWIW, my gut feeling was that the earlier attempts to add a new
> > IPC primitve like multicast UNIX domain sockets
> > http://thread.gmane.org/gmane.linux.kernel/1255575/focus=1257999
> > were a much saner approach.  But now I think the comments
> > from this old thread have not been addressed, instead the
> > new approach just made the thing more complex and
> > put in ipc/ instead of net/ to bypass the guards.
> 
> Not at all, the networking maintainers said that that proposal was not
> acceptable to them at all and it should not be done in the networking
> stack at all.  So this was solution was created instead, which provides
> a lot more things than the old networking patches did, which shows that
> the networking developers were right to reject it.

Please read the gmane thread to the end.  It seems there were
several indications that D-Bus can be improved in userspace
using existing kernel facilities.  Havoc Pennington's mail
I quoted in my first response also contains some hints
about it.  I have no idea if any of this has ever been
pursued.  While adding complexity to critical net/ code paths
is probematic and a good reason to reject it, this was not
the only reason, the major one being "not neccessary".


Thanks,
Johannes

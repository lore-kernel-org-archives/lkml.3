Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbaJ0QKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:10:01 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:34098 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbaJ0QJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:09:58 -0400
X-Originating-IP: 83.155.44.161
Message-ID: <1414426146.30379.62.camel@hadess.net>
Subject: Re: A desktop environment[1] kernel wishlist
From: Bastien Nocera <hadess@hadess.net>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 27 Oct 2014 17:09:06 +0100
In-Reply-To: <CALCETrVYK=GBHbcoJr-zz4tUWv7sdxb-6v7TuuOgcHPCq7s9Pg@mail.gmail.com>
References: <1413881397.30379.7.camel@hadess.net>
	 <5446B3CC.1080904@amacapital.net> <1414418126.30379.47.camel@hadess.net>
	 <CALCETrWQ5r39aqP+MFZuD__5HiNAc+cDQoghsDSEc9oVsmsyvQ@mail.gmail.com>
	 <1414424723.30379.59.camel@hadess.net>
	 <CALCETrVYK=GBHbcoJr-zz4tUWv7sdxb-6v7TuuOgcHPCq7s9Pg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 (3.12.7-1.fc21) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-27 at 09:08 -0700, Andy Lutomirski wrote:
> On Mon, Oct 27, 2014 at 8:45 AM, Bastien Nocera <hadess@hadess.net> wrote:
> > On Mon, 2014-10-27 at 08:12 -0700, Andy Lutomirski wrote:
> >> On Oct 27, 2014 6:56 AM, "Bastien Nocera" <hadess@hadess.net> wrote:
> >> >
> >> > On Tue, 2014-10-21 at 12:28 -0700, Andy Lutomirski wrote:
> >> > > On 10/21/2014 01:49 AM, Bastien Nocera wrote:
> >> > > > Hey,
> >> > > >
> >> > > > GNOME has had discussions with kernel developers in the past, and,
> >> > > > fortunately, in some cases we were able to make headway.
> >> > > >
> >> > > > There are however a number of items that we still don't have solutions
> >> > > > for, items that kernel developers might not realise we'd like to rely
> >> > > > on, or don't know that we'd make use of if merged.
> >> > > >
> >> > > > I've posted this list at:
> >> > > > https://wiki.gnome.org/BastienNocera/KernelWishlist
> >> > > >
> >> > > > Let me know on-list or off-list if you have any comments about those, so
> >> > > > I can update the list.
> >> > >
> >> > > I don't know much about desktop environment infrastructure, but I think
> >> > > the kernel probably already has a lot of what's needed for LinuxApps.
> >> > >
> >> > > Tools like Sandstorm [1] (shameless plug, but it's a good example here)
> >> > > can already sandbox normal-ish programs, and those sandboxes can be
> >> > > launched without privilege [2].
> >> > >
> >> > > Why is kdbus needed?
> >> >
> >> > Because it sucks less than passing fd's and using home-made protocols on
> >> > top of it.
> >>
> >> For securely communicating with a container, "it sucks less" is hard
> >> to use as a design criterion.
> >
> > Sucking less is a requirement when it comes to being able to use it. At
> > the very least, when it comes to security, the fact that the protocol
> > can be captured and analysed in wireshark is already of great help to
> > inspect what each component of the system is doing. More so than passing
> > fd's and using a custom protocol on the server and client sides.
> >
> >> What's wrong with fds, and how does kdbus solve it?
> >
> > By having a well-known protocol and defined semantics on top of that
> > communication channel. I could try and re-explain why kdbus is needed,
> > but I wouldn't do as good a job as the people working on it, so best to
> > refer to the individual threads about kdbus on this list.
> >
> 
> I didn't do a good job asking the question, then.
> 
> What's wrong with fds in the context of communicating with a
> container?  What does kdbus do container-wise that helps?

Nothing's wrong with using fd's. They're just a very poor API.


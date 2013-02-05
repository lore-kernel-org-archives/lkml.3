Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930Ab3BEWSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:18:48 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:52719 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757871Ab3BEWLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:11:53 -0500
Date: Tue, 5 Feb 2013 14:11:39 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
To: Ben Pfaff <blp@cs.stanford.edu>
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Jesse Gross <jesse@nicira.com>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: No sysfs directory for openvswitch module when built-in
Message-ID: <20130205141139.0189f159@nehalam.linuxnetplumber.net>
In-Reply-To: <20130205191554.GA7573@blp.benpfaff.org>
References: <CAM_iQpVgEchb8UsxUP=w6OMbYx=zuP2yv=QwFhe8rPCbNBreVg@mail.gmail.com>
	<20130204081920.00e9f22e@nehalam.linuxnetplumber.net>
	<87lib3gunm.fsf@blp.benpfaff.org>
	<CAM_iQpXSv7ddFtF53JGu=QdaNgY7c4O9Wuq4PmVRczTBiE_rSg@mail.gmail.com>
	<20130205191554.GA7573@blp.benpfaff.org>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2013 11:15:54 -0800
Ben Pfaff <blp@cs.stanford.edu> wrote:

> On Tue, Feb 05, 2013 at 06:49:45PM +0800, Cong Wang wrote:
> > On Tue, Feb 5, 2013 at 2:08 PM, Ben Pfaff <blp@cs.stanford.edu> wrote:
> > > Stephen Hemminger <stephen@networkplumber.org> writes:
> > >
> > >> On Tue, 29 Jan 2013 22:15:18 +0800
> > >> Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >>
> > >>> Hello, Rusty, Jesse,
> > >>>
> > >>> I met an interesting problem when I compile openvswitch module as a
> > >>> built-in (actually I compile ALL kernel modules as built-in), there is
> > >>> no /sys/module/openvswitch/ directory created by the kernel in this
> > >>> case.
> > >>>
> > >>> What's worse, the user-space init script thinks openvswitch module is
> > >>> not loaded by checking the exist of this directory, therefore refuses
> > >>> to start.
> > >>
> > >> Shouldn't the OVS init script be testing for some other API.
> > >
> > > I agree that's a bug in the OVS init script.  I will fix it.
> > 
> > Thanks for taking care of it, Ben!
> 
> I posted a patch to ovs-dev for review:
>         http://openvswitch.org/pipermail/dev/2013-February/025128.html

Good. The ovsctl test is actually more reliable than the /sys/module
because it means that there isn't some other part broken in the API.

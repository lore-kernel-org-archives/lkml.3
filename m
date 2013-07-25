Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab3GYUdB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 16:33:01 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:57796 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752685Ab3GYUdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 16:33:00 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/2CqqckJVHaK3wqt34OmQOUsKo2VvERGs=
Date: Thu, 25 Jul 2013 16:32:28 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Rob Herring <robherring2@gmail.com>
Cc: Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Domenico Andreoli <cavokz@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: DT bindings as ABI [was: Do we have people interested in
 device tree janitoring / cleanup?]
Message-ID: <20130725203228.GX23879@titan.lakedaemon.net>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
 <CAL_JsqJQWOLC9f1igEpsgJB2X8mFDpqLDaFFRjGGVHctjWZLgQ@mail.gmail.com>
 <20130725193135.GT23879@titan.lakedaemon.net>
 <CAL_Jsq+vWbTb8wNEDCR2c_M6sBnKW6e5HGk48QzmXSujQUdddA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+vWbTb8wNEDCR2c_M6sBnKW6e5HGk48QzmXSujQUdddA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 03:16:14PM -0500, Rob Herring wrote:
> On Thu, Jul 25, 2013 at 2:31 PM, Jason Cooper <jason@lakedaemon.net> wrote:
> > On Thu, Jul 25, 2013 at 02:11:31PM -0500, Rob Herring wrote:
> >> On Thu, Jul 25, 2013 at 11:09 AM, Olof Johansson <olof@lixom.net> wrote:
> >
> >> > One problem that needs to be solved is obviously how a binding
> >> > graduates from tentative to locked. This work isn't going to be very
> >> > interesting to most people, I suspect. Think standards committee type
> >> > work.
> >>
> >> I think a time based stabilization period would be better than a
> >> separate directory to apply bindings too. Or time plus periodic review
> >> perhaps.
> >
> > The only problem with a time-based versus separate directory is how do
> > users who've downloaded the tree determine which bindings are stable?
> > If they pull a tarball, or receive an SDK, there is most likely no git
> > history attached.
> 
> Well, if time based includes moving the binding out of the kernel,
> then that is what defines it as stable or not. I guess that is a form
> of a separate directory.

One of the things I've been trying to square up in my head is how to
retain the history of the binding when moving to the new tree.  My
current idea was to clone the kernel tree, add one patch deleting
everything but the bindings and dts files, and one more patch moving
things where we want them (arch/{powerpc,arm}/boot/dts -> dts).

Then, as needed, we could merge a kernel version tag and delete
everything we don't need (code) in the merge commit.

The downside of this is it would be messy, the upside is that we could
closely track the kernel tree (until the bindings and dts are moved
out), and retain the history of the bindings and dts files.

> I don't think we want to be moving bindings twice: tentative -> stable
> and kernel -> DT repo.

agreed.

> The policy could be as simple as an binding without change in at least
> N kernel releases is moved out and stable.

If the cloned tree idea works, we could just merge version tags that are
two or three behind the most recent version.

thx,

Jason.

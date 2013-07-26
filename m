Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351Ab3GZLi1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 07:38:27 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:39857 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab3GZLiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 07:38:20 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+x7XYqMr6lTChzUi/uNn33Yshapq7WsBU=
Date: Fri, 26 Jul 2013 07:38:09 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>, Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Domenico Andreoli <cavokz@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: DT bindings as ABI [was: Do we have people interested in
 device tree janitoring / cleanup?]
Message-ID: <20130726113809.GB29916@titan.lakedaemon.net>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
 <CAL_JsqJQWOLC9f1igEpsgJB2X8mFDpqLDaFFRjGGVHctjWZLgQ@mail.gmail.com>
 <20130725193135.GT23879@titan.lakedaemon.net>
 <20130725231848.GJ24642@n2100.arm.linux.org.uk>
 <CAKON4OwwOnP9kbN0JqR5L+F1svTucAQvz0RDwqU+Gy9UAFwHog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKON4OwwOnP9kbN0JqR5L+F1svTucAQvz0RDwqU+Gy9UAFwHog@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 08:27:15PM -0400, jonsmirl@gmail.com wrote:
> On Thu, Jul 25, 2013 at 7:18 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Thu, Jul 25, 2013 at 03:31:35PM -0400, Jason Cooper wrote:
> >> On Thu, Jul 25, 2013 at 02:11:31PM -0500, Rob Herring wrote:
> >> > On Thu, Jul 25, 2013 at 11:09 AM, Olof Johansson <olof@lixom.net> wrote:
> >>
> >> > > One problem that needs to be solved is obviously how a binding
> >> > > graduates from tentative to locked. This work isn't going to be very
> >> > > interesting to most people, I suspect. Think standards committee type
> >> > > work.
> >> >
> >> > I think a time based stabilization period would be better than a
> >> > separate directory to apply bindings too. Or time plus periodic review
> >> > perhaps.
> >>
> >> The only problem with a time-based versus separate directory is how do
> >> users who've downloaded the tree determine which bindings are stable?
> >> If they pull a tarball, or receive an SDK, there is most likely no git
> >> history attached.
> >>
> >> I think the idea of a 'tentative' directory (or 'locked') is churnish,
> >> but necessary.  If I DL'd a tarball and had to type 'tentative' to get
> >> to the binding doc I wanted, that would be a pretty clear clue to be
> >> delicate about how I trust/use/plan with that binding.
> >
> > It's actually extremely simple.  If the bindings are in development,
> > they must not appear in a -final released kernel.  Anything that appears
> > in a -final kernel becomes part of the ABI at that point.
> >
> > That obviously does not mean you remove them in the last -rc and put
> > them back during the merge window!
> >
> > That's how we handle every other ABI thing in the kernel tree, why should
> > DT files be any different?  (I've added Linus and Grant to this discussion.)
> >
> > As I've already stated, it is intended to eventually remove the DT files
> > from the kernel tree and have them as a separately maintained project,
> > which means they will be independent of the kernel version.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> Having a schema system for the device trees is closely related to this
> discussion.  In this case the schema would probably be equal to the
> stable set of nodes. This has been discussed before on the device tree
> mailing list. The dtc compiler would take this schema and validate the
> trees it compiles against it issuing warnings for 'non-standard'
> usage. Over time the schema would be updated to allow these usages
> when everyone agrees to it. Note that there would be a single schema
> describing all possible legal Linux device trees.

s/Linux// ?

> The scheme is also quite useful for new tree developers since it will
> show them the universe of device tree attributes that have already
> been standardized. By using comments, you could probably turn the
> device tree documentation into the schema source files.

One more note on schema, since DT is a description of hardware, it would
be useful to have two comments, a url to the datasheet, and a canonical
name of the datasheet suitable for $searchengine.  Where available, of
course.

thx,

Jason.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757743Ab3GYTLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 15:11:37 -0400
Received: from mail-qe0-f43.google.com ([209.85.128.43]:43743 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757010Ab3GYTLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 15:11:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
Date: Thu, 25 Jul 2013 14:11:31 -0500
Message-ID: <CAL_JsqJQWOLC9f1igEpsgJB2X8mFDpqLDaFFRjGGVHctjWZLgQ@mail.gmail.com>
Subject: Re: DT bindings as ABI [was: Do we have people interested in device
 tree janitoring / cleanup?]
From: Rob Herring <robherring2@gmail.com>
To: Olof Johansson <olof@lixom.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Domenico Andreoli <cavokz@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 11:09 AM, Olof Johansson <olof@lixom.net> wrote:
> [I'm adding LKML and ksummit-discuss to this thread, since the ACPI/DT
> discussions have been covered there and this overlaps some with that]
>
> On Thu, Jul 25, 2013 at 7:38 AM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
>> On Thu, Jul 25, 2013 at 03:27:02PM +0100, Russell King - ARM Linux wrote:
>>> Remember the stated assertion when DT was first added to the kernel: the
>>> DT descriptions _will_ become a separately maintained project which is
>>> independent of the kernel.  They will _not_ be kernel version specific.
>>
>> I'm looking forward to this.
>>
>> Question for the DT guys: what are the plans here? Are we going to get
>> rid of the .dts files inside the kernel tree?
>
> In the discussions we had in Dublin, a couple of options on how to
> lock in bindings were discussed. I'm a little surprised that Grant
> didn't cover them in his initial emails on the new maintainership
> model, but maybe he wanted the new group to handle it. And they didn't
> bring it up yet either. So I am. :-)
>
> Until now, we have been working under the assumption that the bindings
> are _NOT LOCKED_. I.e. they can change as needed, and we _ARE_
> assuming that the device tree has to match the kernel. That has been a
> good choice as people get up to speed on what is a good binding and
> not, and has given us much-needed room to adjust things as needed.
> That obviously has to change, but doing so needs to be done carefully.

I would argue that little has gone in (if reviewed) with the
expectation that the binding will change. Many of the common bindings
have had many rounds of review and they have not changed. My position
any time I see an incompatible change has been that it require anyone
affected to be okay with the change. This has pretty much been limited
to specific platforms from what I've seen.

One area we've gotten into trouble is using ePAPR based bindings and
then deciding those aren't sufficient. For cpu bindings, we've gone
from the cores are describable we don't need them in DT to following
ePAPR to some level to more fully describing cpu info including
topology.

> It's likely that we still want to have a period in which a binding is
> tentative and can be changed. Sometimes we don't know what we really
> want until after we've used it a while, and sometimes we, like
> everybody else, make mistakes on what is a good idea and not. The
> alternative is to grind most new binding proposals to a halt while we
> spend mind-numbing hours and hours on polishing every single aspect of
> the binding to a perfect shine, since we can't go back and fix it.
>
> So, there really seems to be a need for a layered approach, one in
> which a binding "graduates" from being tentative to being locked in.
> I'm refraining from using the terms "staging" and "stable" here, since
> they have overloaded meaning in the kernel world that doesn't apply
> here.

+1

Tentative must still be reviewed to the same level bindings which have
been reviewed up to now were.

> One problem that needs to be solved is obviously how a binding
> graduates from tentative to locked. This work isn't going to be very
> interesting to most people, I suspect. Think standards committee type
> work.

I think a time based stabilization period would be better than a
separate directory to apply bindings too. Or time plus periodic review
perhaps.

> A possible way to handle this is to have exactly that: A group of
> people that essentially constitute the "standards committee" that meet
> on a regular basis to review and approve new bindings. They should be
> people not just doing ARM Linux work, but other stakeholders in these
> bindings too. One of the things they should probably do is sift
> through our current in-kernel bindings and select those who seem ready
> to be locked in, review/discuss/decide upon that and once the decision
> is made, that specific binding does become part of the static,
> never-ever-change ABI of firmware-to-kernel interfaces.   That might
> also be the time that the binding is moved from the kernel to a
> separate repo, but that's a technicality that we'll let the DT
> maintainers decide among themselves, IMHO.

Seems like a good plan.

Rob

>
> I think that captures most of what we discussed in person. Others
> might have changed their opinions since then, so I'm definitely not
> claiming that any of this was an official decision made by anybody.
> It's just one proposal on how to handle these things moving forward.
>
>
> -Olof
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

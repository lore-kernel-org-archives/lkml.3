Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab3GZA1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 20:27:21 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:64404 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560Ab3GZA1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 20:27:18 -0400
MIME-Version: 1.0
In-Reply-To: <20130725231848.GJ24642@n2100.arm.linux.org.uk>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
	<CAL_JsqJQWOLC9f1igEpsgJB2X8mFDpqLDaFFRjGGVHctjWZLgQ@mail.gmail.com>
	<20130725193135.GT23879@titan.lakedaemon.net>
	<20130725231848.GJ24642@n2100.arm.linux.org.uk>
Date: Thu, 25 Jul 2013 20:27:15 -0400
Message-ID: <CAKON4OwwOnP9kbN0JqR5L+F1svTucAQvz0RDwqU+Gy9UAFwHog@mail.gmail.com>
Subject: Re: DT bindings as ABI [was: Do we have people interested in device
 tree janitoring / cleanup?]
From: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 7:18 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, Jul 25, 2013 at 03:31:35PM -0400, Jason Cooper wrote:
>> On Thu, Jul 25, 2013 at 02:11:31PM -0500, Rob Herring wrote:
>> > On Thu, Jul 25, 2013 at 11:09 AM, Olof Johansson <olof@lixom.net> wrote:
>>
>> > > One problem that needs to be solved is obviously how a binding
>> > > graduates from tentative to locked. This work isn't going to be very
>> > > interesting to most people, I suspect. Think standards committee type
>> > > work.
>> >
>> > I think a time based stabilization period would be better than a
>> > separate directory to apply bindings too. Or time plus periodic review
>> > perhaps.
>>
>> The only problem with a time-based versus separate directory is how do
>> users who've downloaded the tree determine which bindings are stable?
>> If they pull a tarball, or receive an SDK, there is most likely no git
>> history attached.
>>
>> I think the idea of a 'tentative' directory (or 'locked') is churnish,
>> but necessary.  If I DL'd a tarball and had to type 'tentative' to get
>> to the binding doc I wanted, that would be a pretty clear clue to be
>> delicate about how I trust/use/plan with that binding.
>
> It's actually extremely simple.  If the bindings are in development,
> they must not appear in a -final released kernel.  Anything that appears
> in a -final kernel becomes part of the ABI at that point.
>
> That obviously does not mean you remove them in the last -rc and put
> them back during the merge window!
>
> That's how we handle every other ABI thing in the kernel tree, why should
> DT files be any different?  (I've added Linus and Grant to this discussion.)
>
> As I've already stated, it is intended to eventually remove the DT files
> from the kernel tree and have them as a separately maintained project,
> which means they will be independent of the kernel version.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Having a schema system for the device trees is closely related to this
discussion.  In this case the schema would probably be equal to the
stable set of nodes. This has been discussed before on the device tree
mailing list. The dtc compiler would take this schema and validate the
trees it compiles against it issuing warnings for 'non-standard'
usage. Over time the schema would be updated to allow these usages
when everyone agrees to it. Note that there would be a single schema
describing all possible legal Linux device trees.

The scheme is also quite useful for new tree developers since it will
show them the universe of device tree attributes that have already
been standardized. By using comments, you could probably turn the
device tree documentation into the schema source files.

-- 
Jon Smirl
jonsmirl@gmail.com

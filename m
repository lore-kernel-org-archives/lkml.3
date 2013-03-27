Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab3C0TKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 15:10:32 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:61612 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab3C0TKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 15:10:30 -0400
Message-ID: <51534421.4050300@gmail.com>
Date: Wed, 27 Mar 2013 14:10:25 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "nico@linaro.org" <nico@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3] [RFC] arm: use PSCI if available
References: <1364388639-11210-1-git-send-email-stefano.stabellini@eu.citrix.com> <51531F76.2090200@gmail.com> <20130327170555.GA20990@mudshark.cambridge.arm.com> <201303271750.52015.arnd@arndb.de> <20130327181206.GD20990@mudshark.cambridge.arm.com>
In-Reply-To: <20130327181206.GD20990@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2013 01:12 PM, Will Deacon wrote:
> On Wed, Mar 27, 2013 at 05:50:51PM +0000, Arnd Bergmann wrote:
>> On Wednesday 27 March 2013, Will Deacon wrote:
>>> The channel is common, sure, but I wouldn't expect the semantics of each
>>> call to be identical between firmware implementations (going back to my
>>> previous examples of CPU IDs and implementation-defined state parameters).
>>>
>>> If a platform happens to have an id-mapping from smp_operations to psci,
>>> then I still think there should be an indirection in there so that we have
>>> the flexibility to change the smp_operations if we wish and not give
>>> platforms the false impression that these two things are equivalent.
>>
>> I think the only reasonably implementation for psci is if we can assume
>> that each callback with a specific property name has a well-defined behavior,
>> and we should mandate that every platform that implements the callbacks
>> we need for SMP actually implements them according to the spec.
>>
>> What would be the point of a standard psci interface if the specific
>> implementation are not required to follow the same semantics?
> 
> The interface *is* standard. The functions have well-defined headers and can
> be called in the same way between implementations. The difference is in the
> semantics of the parameters. For example:
> 
>   int cpu_off(u32 power_state);
> 
> If you look at the power_state parameter, it's actually a struct (see struct
> psci_power_state) with a u16 id field. The current specification describes
> that field as `This is platform specific, the number is understood by the
> firmware, and used to program the power controller.'.
> 
> So unless we get everybody to agree on the definition of that field, we
> can't blindly plug the interfaces together. Furthermore, there are other
> parameters like this and, as new functions are specified, I would expect
> them to grow.

Which is why I've said I think the ID field is a bad idea. I've used it
in my implementation, but only in the case of system level reset,
power-off, and suspend. I don't see how it would be used otherwise.

I guess you could define a value of 0 must be supported at a minimum and
then default implementation would at least work to some level.

Rob

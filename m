Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab3C2Tb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 15:31:56 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:63042 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235Ab3C2Tby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 15:31:54 -0400
Message-ID: <5155EC28.8050608@gmail.com>
Date: Fri, 29 Mar 2013 14:31:52 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 2/2] arm: prefer PSCI for SMP bringup
References: <1364575371-8926-2-git-send-email-stefano.stabellini@eu.citrix.com> <alpine.LFD.2.03.1303291320580.1372@syhkavp.arg> <alpine.DEB.2.02.1303291735080.4430@kaball.uk.xensource.com> <alpine.LFD.2.03.1303291349150.1372@syhkavp.arg>
In-Reply-To: <alpine.LFD.2.03.1303291349150.1372@syhkavp.arg>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2013 12:53 PM, Nicolas Pitre wrote:
> On Fri, 29 Mar 2013, Stefano Stabellini wrote:
> 
>> On Fri, 29 Mar 2013, Nicolas Pitre wrote:
>>> On Fri, 29 Mar 2013, Stefano Stabellini wrote:
>>>
>>>> If PSCI initializes correctly and PSCI SMP operations are available, use them.
>>>> This is required for SMP support in Dom0 on Xen.
>>>>
>>>> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>>>> CC: will.deacon@arm.com
>>>> CC: arnd@arndb.de
>>>> CC: marc.zyngier@arm.com
>>>> CC: linux@arm.linux.org.uk
>>>> CC: nico@linaro.org
>>>
>>> I'd suggest you also include in your series the patch I posted earlier 
>>> providing a runtime mdesc->smp_init method as well.
>>
>> OK.
>>
>>
>>> This way the 
>>> priority order would be:
>>>
>>> - If mdesc->smp_init is non null then use that.
>>>
>>> - Otherwise, if PSCI is available then use that.
>>>
>>> - Otherwise use mdesc->smp.
>>>
>>> This way, if the PSCI default has to be overriden (like in the MCPM case 
>>> because it needs to wrap PSCI itself, or to cover Rob's concern) then 
>>> this can be achieved at run time on a per mdesc basis.
>>
>> Actually that's not a bad idea, it could make everybody happy.
>> What about the following, in this precise order:
>>
>> - if a xen hypervisor node is present on device tree, use PSCI;
>> - otherwise if mdesc->smp_init is non null then use it;
>> - otherwise if PSCI is available then use it;
>> - otherwise use mdesc->smp.
>>
>> It's the most practical solution to satisfy everybody's needs.
> 
> Maybe I'm missing something obvious, but why can't xen declare a mdesc 
> of its own?  Given it is going to tweak the DT passed to the kernel 
> anyway that shouldn't be a problem.

Xen does have it's own mdesc. It is (or will be) mach-virt, but that is
only for DomU guests. For Dom0, you still need all the platform specific
code except smp_ops. However, I'm doubtful this would work without other
changes on more complicated platforms like OMAP.

I would say wait to add this until you have platforms that actually need
the first case.

Rob

> 
> That would be more eleguant than adding xen exception hooks in generic 
> code.
> 
> 
> Nicolas
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 


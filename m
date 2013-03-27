Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab3C0QUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 12:20:37 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:32814 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab3C0QUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 12:20:36 -0400
Message-ID: <51531C50.1010106@gmail.com>
Date: Wed, 27 Mar 2013 11:20:32 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>, "nico@linaro.org" <nico@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3] [RFC] arm: use PSCI if available
References: <1364388639-11210-1-git-send-email-stefano.stabellini@eu.citrix.com> <5152F591.40201@arm.com>
In-Reply-To: <5152F591.40201@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2013 08:35 AM, Marc Zyngier wrote:
> On 27/03/13 12:50, Stefano Stabellini wrote:
>> Check for the presence of PSCI before setting smp_ops, use PSCI if it is
>> available.
>>
>> This is useful because at least when running on Xen it's possible to have a
>> PSCI node for example on a Versatile Express or an Exynos5 machine. In these
>> cases the PSCI SMP calls should be the ones to be called.
>>
>> Remove virt_smp_ops and platsmp.c from mach-virt because they aren't needed
>> anymore.

[...]

>> +static void __cpuinit psci_secondary_init(unsigned int cpu)
>> +{
>> +	gic_secondary_init(0);
>> +}
> 
> So here we end-up with a dependency between SMP, PSCI, and GIC.
> I really can't see that being a good idea, even I like the general
> direction of this series.
> 

The GIC dependency should be removed with Catalin's series to use
notifiers for GIC cpu interface init.

Rob

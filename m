Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642Ab3HSNC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 09:02:59 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:41750 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab3HSNC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 09:02:57 -0400
Message-ID: <5212177C.8000709@gmail.com>
Date: Mon, 19 Aug 2013 08:02:52 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jonas Bonn <jonas@southpole.se>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Michal Simek <monstr@monstr.eu>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [RFC PATCH v2 3/4] powerpc: refactor of_get_cpu_node to support
 other architectures
References: <1376586580-5409-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1376674791-28244-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1376674791-28244-2-git-send-email-Sudeep.KarkadaNagesha@arm.com> <2032060.4bgTKOdEX2@flatron> <1376777376.25016.11.camel@pasglop> <20130819101922.GI3719@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130819101922.GI3719@e106331-lin.cambridge.arm.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2013 05:19 AM, Mark Rutland wrote:
> On Sat, Aug 17, 2013 at 11:09:36PM +0100, Benjamin Herrenschmidt wrote:
>> On Sat, 2013-08-17 at 12:50 +0200, Tomasz Figa wrote:
>>> I wonder how would this handle uniprocessor ARM (pre-v7) cores, for
>>> which 
>>> the updated bindings[1] define #address-cells = <0> and so no reg 
>>> property.
>>>
>>> [1] - http://thread.gmane.org/gmane.linux.ports.arm.kernel/260795
>>
>> Why did you do that in the binding ? That sounds like looking to create
>> problems ... 
>>
>> Traditionally, UP setups just used "0" as the "reg" property on other
>> architectures, why do differently ?
> 
> The decision was taken because we defined our reg property to refer to
> the MPIDR register's Aff{2,1,0} bitfields, and on UP cores before v7
> there's no MPIDR register at all. Given there can only be a single CPU
> in that case, describing a register that wasn't present didn't seem
> necessary or helpful.

What exactly reg represents is up to the binding definition, but it
still should be present IMO. I don't see any issue with it being
different for pre-v7.

Rob

> 
> Thanks,
> Mark.
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 


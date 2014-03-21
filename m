Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760724AbaCUJoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 05:44:34 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:57650 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760135AbaCUJo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 05:44:29 -0400
Message-ID: <532C09F7.3010003@codethink.co.uk>
Date: Fri, 21 Mar 2014 10:44:23 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Jisheng Zhang <jszhang@marvell.com>
CC: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/2] ARM: berlin: SMP support
References: <1395347986-30203-1-git-send-email-sebastian.hesselbarth@gmail.com> <20140321111457.6bed5091@xhacker>
In-Reply-To: <20140321111457.6bed5091@xhacker>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/03/14 04:14, Jisheng Zhang wrote:
> On Thu, 20 Mar 2014 13:39:44 -0700
> Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:
>
>> This is a small patch set for SMP support on Marvell Berlin BG2
>> and recently provided BG2Q. Nothing spectacular, as it basically
>> copies SMP holding pen mechanism from mach-prima2 and plat-versatile
>> with minor Berlin specific code for SCU and general purpose registers
>> used by secondary CPUs to get their boot address.
>>
>> There was some IRC discussion with Alexandre about using
>> scu_get_base() instead of a DT node. Although BG2Q is true A9
>> and provides SCU base; BG2 with PJ4b does not and I decided to
>> depend on a DT node for SCU in both cases, which is fine I guess.
>>
>> I tested this on BG2, and BG2CD (which is UP). I expect the
>> Free-Electrons guys to test on BG2Q.
>
> Although BG2Q and future SoCs will go through PSCI code path finally. But
> currently, it's OK to use the pen mechanism.
>
> So for both of these two patches,

Can you not just avoid starting CPUs until the kernel asks
them to be booted?

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius

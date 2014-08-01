Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbaHAOv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 10:51:57 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:33128 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754623AbaHAOvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 10:51:53 -0400
Message-ID: <53DBA986.90705@arm.com>
Date: Fri, 01 Aug 2014 15:51:50 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
CC: Mark Rutland <Mark.Rutland@arm.com>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Harish.Kasiviswanathan@amd.com" <Harish.Kasiviswanathan@amd.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 4/4 V3] irqchip: gicv2m: Add support for multiple MSI
 for ARM64 GICv2m
References: <1404947104-21345-1-git-send-email-suravee.suthikulpanit@amd.com> <1404947104-21345-5-git-send-email-suravee.suthikulpanit@amd.com> <87vbqej2rj.fsf@approximate.cambridge.arm.com> <53DBA603.9030509@amd.com>
In-Reply-To: <53DBA603.9030509@amd.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suravee,

On 01/08/14 15:36, Suravee Suthikulanit wrote:
> On 7/30/2014 10:16 AM, Marc Zyngier wrote:
>> Why do we need this complexity at all? Is there any case where we'd want
>> to limit ourselves to a single vector for MSI?
> 
> I think the ARM64 GICv2m should not be the limitation for the devices 
> multiple MSI if there is no real hardware/design limitation.
> 
>> arm64 is a new enough architecture so that we can expect all interrupt controllers to cope
>> with that.
> 
> I am not sure if I understand this comment.
> 
> We are not forcing all interrupt controllers for ARM64 to handle 
> multi-MSI.  They have the option to support if multi-MSI if they want 
> to. I just think that we should not put the architectural limit here.

Let me be clearer: I think we should put the burden of *not* handling
multi-MSI on interrupt controllers. Here, you're making the
architectural default to be "I don't support multi-MSI", hence having to
override global vectors and such for well behaved MSI controllers like
GICv2m and GICv3 ITS.

Let's only support multi-MSI for the time being. If someone comes up
with a silly old MSI controller that can't deal with it, we'll address
the issue at that problem.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

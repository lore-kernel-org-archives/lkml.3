Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab3FJQhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 12:37:33 -0400
Received: from kymasys.com ([64.62.140.43]:49428 "HELO kymasys.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753322Ab3FJQh2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 12:37:28 -0400
Subject: Re: [PATCH 00/31] KVM/MIPS: Implement hardware virtualization via the MIPS-VZ extensions.
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=US-ASCII
From: Sanjay Lal <sanjayl@kymasys.com>
In-Reply-To: <51B50E87.2060501@gmail.com>
Date: Mon, 10 Jun 2013 09:37:30 -0700
Cc: Gleb Natapov <gleb@redhat.com>, David Daney <ddaney@caviumnetworks.com>,
        David Daney <ddaney.cavm@gmail.com>, kvm@vger.kernel.org,
        linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Content-Transfer-Encoding: 7BIT
Message-Id: <1CA521E6-00F2-4992-9F90-5B408C80C9B1@kymasys.com>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com> <51B26974.5000306@caviumnetworks.com> <20130609073115.GE4725@redhat.com> <51B50E87.2060501@gmail.com>
To: David Daney <david.s.daney@gmail.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 9, 2013, at 4:23 PM, David Daney wrote:

> On 06/09/2013 12:31 AM, Gleb Natapov wrote:
>> On Fri, Jun 07, 2013 at 04:15:00PM -0700, David Daney wrote:
>>> I should also add that I will shortly send patches for the kvm tool
>>> required to drive this VM as well as a small set of patches that
>>> create a para-virtualized MIPS/Linux guest kernel.
>>> 
>>> The idea is that because there is no standard SMP linux system, we
>>> create a standard para-virtualized system that uses a handful of
>>> hypercalls, but mostly just uses virtio devices.  It has no emulated
>>> real hardware (no 8250 UART, no emulated legacy anything...)
>>> 
>> Virtualization is useful for running legacy code. Why dismiss support
>> for non pv guests so easily?
> 
> Just because we create standard PV system devices, doesn't preclude emulating real hardware.  In fact Sanjay Lal's work includes QEMU support for doing just this for a MIPS malta board.  I just wanted a very simple system I could implement with the kvm tool in a couple of days, so that is what I initially did.
> 
> The problem is that almost nobody has real malta boards, they are really only of interest because QEMU implements a virtual malta board.
> 
> Personally, I see the most interesting us cases of MIPS KVM being a deployment platform for new services, so legacy support is not so important to me.  That doesn't mean that other people wouldn't want some sort of legacy support.  The problem with 'legacy' on MIPS is that there are hundreds of legacies to choose from (Old SGI and DEC hardware, various network hardware from many different vendors, etc.).  Which would you choose?
> 
>>  How different MIPS SMP systems are?
> 
> o Old SGI heavy metal (several different system architectures).
> 
> o Cavium OCTEON SMP SoCs.
> 
> o Broadcom (several flavors) SoCs
> 
> o Loongson
> 
> 
> Come to think of it, Emulating SGI hardware might be an interesting case.  There may be old IRIX systems and applications that could be running low on real hardware.  Some of those systems take up a whole room and draw a lot of power.  They might run faster and at much lower power consumption on a modern 48-Way SMP SoC based system.
> 
>>  What
>> about running non pv UP systems?
> 
> See above.  I think this is what Sanjay Lal is doing.


The KVM implementation from MIPS (currently in mainline) supports UP systems in trap and emulate mode.  The patch set I posted earlier adding VZ support also supports SMP.  We leverage the Malta board emulation in QEMU to offer full non-PV virtualization:

UP system: Malta board with a MIPS 24K processor
SMP system: Malta board with a 1074K CMP processor cluster with a GIC.

When it comes to PV/non-PV support, I see the two implementations as complementary.  If people want full legacy system emulation without any kernel modifications, then they can run the full QEMU/KVM stack, while people interested in pure PV solutions can run the lkvm version.

Regards
Sanjay







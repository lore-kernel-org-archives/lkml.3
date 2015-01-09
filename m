Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579AbbAIRq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:46:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758140AbbAIRq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:46:57 -0500
Date: Fri, 9 Jan 2015 18:45:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pratyush Anand <panand@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>, "tixy@linaro.org" <tixy@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "sandeepa.prabhu@linaro.org" <sandeepa.prabhu@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "anil.s.keshavamurthy@intel.com" <anil.s.keshavamurthy@intel.com>,
        "masami.hiramatsu.pt@hitachi.com" <masami.hiramatsu.pt@hitachi.com>,
        "wcohen@redhat.com" <wcohen@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC 8/8] ARM64: Add uprobe support
Message-ID: <20150109174524.GA13161@redhat.com>
References: <cover.1420038188.git.panand@redhat.com> <0694af6935f9c6873ef8d25ad51630a40a74a116.1420038188.git.panand@redhat.com> <20150108170324.GT11583@arm.com> <54AEC470.50509@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AEC470.50509@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08, Pratyush Anand wrote:
>
> On Thursday 08 January 2015 10:33 PM, Will Deacon wrote:
>>
>> I'm assuming that means you don't support compat (AArch32) tasks with this?
>
> Hummm.. Yes, compat not yet supported.
>
> I will come back on this.

I obviously do not know how difficult is to support the compat tasks, and
in any case I leave this to you and Will.

But if this is not simple, perhaps the initial implementation could simply
nack the probe in arch_uprobe_analyze_insn() if this mm is not 64-bit.
Although I do not see something like is_64bit_mm() in arch/arm64... So may be
the first version can even ignore this problem and just document the fact
that AArch32 tasks are not supported.

Oleg.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbaCLJXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 05:23:12 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:64319 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbaCLJXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 05:23:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140312070523.GL30956@twins.programming.kicks-ass.net>
References: <20140311235329.GA28624@quad>
	<20140312070523.GL30956@twins.programming.kicks-ass.net>
Date: Wed, 12 Mar 2014 10:23:08 +0100
Message-ID: <CABPqkBRDu9_pwJszj6VDiwcrgyK9_UVHg4dc3sbhox9FYbDbtA@mail.gmail.com>
Subject: Re: [PATCH v2] perf/x86/uncore: fix compilation warning in snb_uncore_imc_init_box()
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 8:05 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Mar 12, 2014 at 12:53:30AM +0100, Stephane Eranian wrote:
>>  #ifdef CONFIG_PHYS_ADDR_T_64BIT
>> -     pci_read_config_dword(pdev, SNB_UNCORE_PCI_IMC_BAR_OFFSET+4, &addr_hi);
>> -     addr = ((resource_size_t)addr_hi << 32) | addr_lo;
>> +       pci_read_config_dword(pdev, where + 4, &pci_dword);
>> +       addr |= ((resource_size_t)pci_dword << 32);
>>  #endif
>
> Indent fail there; fixed it.
>
> FWIW; I thought of an even more horrible solution:
>
>         resource_size_t addr;
>         u32 *addr_ptr = &addr;
>
>         pci_read_config_dword(pdev, SNB_UNCORE_PCI_IMC_BAR_OFFSET, &addr_ptr[0]);
> #ifdef ..
>         pci_read_config_dword(pdev, SNB_UNCORE_PCI_IMC_BAR_OFFSET+4, &addr_ptr[1]);
> #endif
>
> :-)
Yeah, I really don't like that one. Always confused with little vs.
big endian or alignement!

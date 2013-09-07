Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750980Ab3IGDrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 23:47:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33508 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807Ab3IGDrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 23:47:39 -0400
Message-ID: <522AA189.6030406@zytor.com>
Date: Fri, 06 Sep 2013 20:46:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, X86 ML <x86@kernel.org>
Subject: Re: linux-next: Tree for Sep 3 (x86_init.c)
References: <20130903182937.f32c2acb338c72bea55b14a7@canb.auug.org.au> <5226316B.5050805@infradead.org>
In-Reply-To: <5226316B.5050805@infradead.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2013 11:58 AM, Randy Dunlap wrote:
> On 09/03/13 01:29, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20130902:
>>
> 
> on i386, when
> CONFIG_SMP is not enabled
> CONFIG_X86_UP_APIC is not enabled
> 
> arch/x86/built-in.o:(.data+0x540): undefined reference to `native_setup_msi_irqs'
> arch/x86/built-in.o:(.data+0x548): undefined reference to `native_teardown_msi_irq'
> 
> Looks like recent changes for CONFIG_PCI_MSI should not be built for the config
> that is listed above.
> 
> Full randconfig file is attached.
> 

Specifically, CONFIG_PCI_MSI probably needs to depend on APIC support,
which is compiled out in the above case.

	-hpa



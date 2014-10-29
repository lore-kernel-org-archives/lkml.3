Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbaJ2H7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 03:59:20 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:48660 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbaJ2H7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 03:59:19 -0400
Date: Wed, 29 Oct 2014 08:59:15 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: tglx@linutronix.de, jiang.liu@linux.intel.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [tip:x86/urgent] ix86: Fix build failure when !CONFIG_X86_IO_APIC
Message-ID: <20141029075915.GB7322@gmail.com>
References: <54184CC802000078000355EE@mail.emea.novell.com>
 <tip-a425cf83e39f99a70168c184e79cea8c67ba7c12@git.kernel.org>
 <544FAC9F0200007800042CA6@mail.emea.novell.com>
 <20141029075042.GA7322@gmail.com>
 <5450AAF30200007800042F64@mail.emea.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5450AAF30200007800042F64@mail.emea.novell.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@suse.com> wrote:

> >>> On 29.10.14 at 08:50, <mingo@kernel.org> wrote:
> 
> > * Jan Beulich <JBeulich@suse.com> wrote:
> > 
> >> >>> On 28.10.14 at 12:18, <tipbot@zytor.com> wrote:
> >> > Commit-ID:  a425cf83e39f99a70168c184e79cea8c67ba7c12
> >> > Gitweb:     
> > http://git.kernel.org/tip/a425cf83e39f99a70168c184e79cea8c67ba7c12 
> >> > Author:     Jan Beulich <JBeulich@suse.com>
> >> > AuthorDate: Tue, 16 Sep 2014 13:44:24 +0100
> >> > Committer:  Ingo Molnar <mingo@kernel.org>
> >> > CommitDate: Tue, 28 Oct 2014 12:01:09 +0100
> >> > 
> >> > ix86: Fix build failure when !CONFIG_X86_IO_APIC
> >> > 
> >> > mp_should_keep_irq() isn't really IO-APIC related, and
> >> > considering that it's being used solely in arch/x86/pci/ likely
> >> > both declaration and definition got misplaced even without
> >> > considering the resulting build failure:
> >> > 
> >> >   .../arch/x86/pci/irq.c: In function ‘pirq_disable_irq’:
> >> >   .../arch/x86/pci/irq.c:1259: error: implicit declaration of function 
> >> > ‘mp_should_keep_irq’
> >> >   make[3]: *** [arch/x86/pci/irq.o] Error 1
> >> > 
> >> > Move them to better places.
> >> 
> >> Ingo,
> >> 
> >> the build failure had got addressed by a different patch 
> >> already, albeit that patch seems far from ideal to me. I.e. I 
> >> still think cleanup along the lines of the patch here is 
> >> desirable, but I need to submit one that actually builds (the 
> >> build failure the test robot encountered is a direct result of 
> >> the clash between the two patches). I have that patch ready, 
> >> but didn't want to submit before I got around to test it with 
> >> 3.18-rc.
> > 
> > Okay, I've removed it from x86/urgent. Note that it also 
> > generated this build failure:
> > 
> > ./arch/x86/include/asm/io_apic.h:240:20: error: static declaration of 
> > ‘mp_should_keep_irq’ follows non-static declaration
> 
> Right - that's the one I was referring to above (actually iirc there
> are two relatively similar build failures resulting from the conflict).

Okay. I didn't mind your cleanup, so please follow it up and I'll 
apply it.

Thanks,

	Ingo

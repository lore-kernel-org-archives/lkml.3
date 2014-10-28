Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaJ1NsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 09:48:09 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:49409 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbaJ1NsH (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Tue, 28 Oct 2014 09:48:07 -0400
Message-Id: <544FAC9F0200007800042CA6@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Tue, 28 Oct 2014 13:47:59 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@kernel.org>
Cc: <tglx@linutronix.de>, <jiang.liu@linux.intel.com>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [tip:x86/urgent] ix86: Fix build failure when
 !CONFIG_X86_IO_APIC
References: <54184CC802000078000355EE@mail.emea.novell.com>
 <tip-a425cf83e39f99a70168c184e79cea8c67ba7c12@git.kernel.org>
In-Reply-To: <tip-a425cf83e39f99a70168c184e79cea8c67ba7c12@git.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.10.14 at 12:18, <tipbot@zytor.com> wrote:
> Commit-ID:  a425cf83e39f99a70168c184e79cea8c67ba7c12
> Gitweb:     http://git.kernel.org/tip/a425cf83e39f99a70168c184e79cea8c67ba7c12 
> Author:     Jan Beulich <JBeulich@suse.com>
> AuthorDate: Tue, 16 Sep 2014 13:44:24 +0100
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Tue, 28 Oct 2014 12:01:09 +0100
> 
> ix86: Fix build failure when !CONFIG_X86_IO_APIC
> 
> mp_should_keep_irq() isn't really IO-APIC related, and
> considering that it's being used solely in arch/x86/pci/ likely
> both declaration and definition got misplaced even without
> considering the resulting build failure:
> 
>   .../arch/x86/pci/irq.c: In function ‘pirq_disable_irq’:
>   .../arch/x86/pci/irq.c:1259: error: implicit declaration of function 
> ‘mp_should_keep_irq’
>   make[3]: *** [arch/x86/pci/irq.o] Error 1
> 
> Move them to better places.

Ingo,

the build failure had got addressed by a different patch already,
albeit that patch seems far from ideal to me. I.e. I still think cleanup
along the lines of the patch here is desirable, but I need to submit
one that actually builds (the build failure the test robot encountered
is a direct result of the clash between the two patches). I have that
patch ready, but didn't want to submit before I got around to test it
with 3.18-rc.

Jan

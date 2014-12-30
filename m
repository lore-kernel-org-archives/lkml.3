Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbaL3Ecn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 23:32:43 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:37339 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaL3Ecl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 23:32:41 -0500
MIME-Version: 1.0
In-Reply-To: <20141229110324.50f1339b@mschwide>
References: <1419700667-24888-1-git-send-email-bobby.prani@gmail.com> <20141229110324.50f1339b@mschwide>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Mon, 29 Dec 2014 23:32:10 -0500
Message-ID: <CAJhHMCDan+qaaZjVUucA-sUS8A3vSTYuVHg8XQv4rsHXxAzKLw@mail.gmail.com>
Subject: Re: [PATCH] srcu: Isolate srcu sections using CONFIG_SRCU
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "supporter:S390" <linux390@de.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Anton Blanchard <anton@samba.org>,
        Scott Wood <scottwood@freescale.com>,
        Andy Fleming <afleming@freescale.com>,
        Tiejun Chen <tiejun.chen@windriver.com>,
        Daniel Walter <dwalter@google.com>,
        Jens Freimann <jfrei@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "open list:LINUX FOR POWERPC..." <linuxppc-dev@lists.ozlabs.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:S390" <linux-s390@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2014 at 5:03 AM, Martin Schwidefsky
<schwidefsky@de.ibm.com> wrote:
> On Sat, 27 Dec 2014 12:17:43 -0500
> Pranith Kumar <bobby.prani@gmail.com> wrote:
>
>> @@ -65,10 +65,13 @@
>>  #include <asm/kexec.h>
>>  #include <asm/mmu_context.h>
>>  #include <asm/code-patching.h>
>> -#include <asm/kvm_ppc.h>
>>  #include <asm/hugetlb.h>
>>  #include <asm/epapr_hcalls.h>
>>
>> +#if IS_ENABLED(CONFIG_KVM)
>> +#include <asm/kvm_ppc.h>
>> +#endif
>> +
>>  #ifdef DEBUG
>>  #define DBG(fmt...) udbg_printf(fmt)
>>  #else
>
> I always cringe when I see an include protected by an #ifdef.
> Is this really necessary? All that is done in asm-offsets.c is
> to calculate offsets, the code where the two offsets in question
> are used (entry64.S) does have the #ifdef for CONFIG_KVM.

I agree that this is not the ideal way to do this. But, it has been
the way things were already being done. If you see
arch/powerpc/kernel/asm-offsets.c, there are quite some includes which
are within ifdefs.

I've considered other alternatives (though not in-depth) and found
that they will require quite some refactoring. One simple idea is to
move this #ifdef to within kvm_ppc.h. That should make the inclusion
of this file a no-op in all the places where this is being included
without KVM being enabled. But I am not 100% sure of that approach.

Any suggestions are welcome.

-- 
Pranith

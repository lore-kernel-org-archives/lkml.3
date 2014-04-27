Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbaD0G4A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 02:56:00 -0400
Received: from si-002-i43.relay.mailchannels.net ([184.154.112.208]:63677 "EHLO
	relay.mailchannels.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752879AbaD0Gz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 02:55:59 -0400
X-Sender-Id: totalchoicehosting|x-authuser|oren%2bscalemp.com
X-Sender-Id: totalchoicehosting|x-authuser|oren%2bscalemp.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: totalchoicehosting%7Cx-authuser%7Coren%252bscalemp.com
X-MailChannels-Auth-Id: totalchoicehosting
Message-ID: <535CA9F6.7010101@scalemp.com>
Date: Sun, 27 Apr 2014 09:55:50 +0300
From: Oren Twaig <oren@scalemp.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Shai Fultheim <shai@scalemp.com>
Subject: Re: [PATCH v2] X86: Hook apic vector allocation domain only when
 interrupt routing are set to ignore
References: <1398376326-3055-1-git-send-email-oren@scalemp.com> <20140425080137.GC19588@gmail.com> <535A421F.4010108@scalemp.com> <20140426060959.GA1944@gmail.com>
In-Reply-To: <20140426060959.GA1944@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AuthUser: oren+scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On 04/26/2014 09:09 AM, Ingo Molnar wrote:
> I still don't see a clear explanation of what the _user_ saw and sees
> before and after the change. What is the effect of the patch: correct
> IRQ routing (i.e. before the change IRQs would end up on the wrong
> CPU), lower overhead IRQ routing (i.e. before the change IRQ routing
> overhead was more expensive), or something else?
>
> You don't spell this out clearly and it's a crucial piece of
> information that comes before every other explanation.
>
I see.. I tried to explain the entire flow and that was confusing - I'll explain
only the patch.

As you stated, in general, the patch corrects IRQ routing in case a vSMP
Foundation box is detected but the Interrupt Routing Comply (IRC) is set to
"comply".

Before the patch:
When a vSMP Foundation box was detected and IRC was set to "comply", users (and
kernel) couldn't effectively set the destination of the IRQs. This is because
the hook inside vsmp_64.c always setup all CPUs as the IRQ destination using
cpumask_setall() as the return value for IRQ allocation mask. Later, this
"overrided" mask caused the kernel to set the IRQ destination to the lowest
online CPU in the mask (CPU0 usually).

After the patch:
When the IRC is set to "comply", Users (and kernel) can control the destination
of the IRQs as we will not be changing the default
"apic->vector_allocation_domain".

Thanks,
   Oren

> Thanks,
>
>     Ingo



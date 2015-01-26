Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093AbbAZKqO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:46:14 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:56552 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943AbbAZKqJ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:14:2>);
	Mon, 26 Jan 2015 05:46:09 -0500
Message-Id: <54C628FB02000078000595C0@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Mon, 26 Jan 2015 10:46:03 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: "Andy Lutomirski" <luto@amacapital.net>,
        "David Vrabel" <david.vrabel@citrix.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, <rostedt@goodmis.org>,
        "Masami Hiramatsu" <masami.hiramatsu.pt@hitachi.com>, <x86@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>, <paulmck@linux.vnet.ibm.com>,
        <xen-devel@lists.xenproject.org>, <boris.ostrovsky@oracle.com>,
        <konrad.wilk@oracle.com>, "Ingo Molnar" <mingo@redhat.com>,
        "Borislav Petkov" <bp@suse.de>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [RFC v4 2/2] x86/xen: allow privcmd hypercalls
 to be preempted
References: <1421972951-3940-1-git-send-email-mcgrof@do-not-panic.com>
 <1421972951-3940-3-git-send-email-mcgrof@do-not-panic.com>
 <54C23442.9000008@citrix.com> <20150123185812.GX17887@wotan.suse.de>
In-Reply-To: <20150123185812.GX17887@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 23.01.15 at 19:58, <mcgrof@suse.com> wrote:
> On Fri, Jan 23, 2015 at 11:45:06AM +0000, David Vrabel wrote:
>> On 23/01/15 00:29, Luis R. Rodriguez wrote:
>> > @@ -1243,6 +1247,25 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
>> >  	set_irq_regs(old_regs);
>> >  }
>> >  
>> > +/*
>> > + * CONFIG_PREEMPT=n kernels can end up triggering the softlock
>> > + * TASK_UNINTERRUPTIBLE hanger check (default 120 seconds)
>> > + * when certain multicalls are used [0] on large systems, in
>> > + * that case we need a way to voluntarily preempt. This is
>> > + * only an issue on CONFIG_PREEMPT=n kernels.
>> 
>> Rewrite this comment as;
>> 
>> * Some hypercalls issued by the toolstack can take many 10s of
> 
> Its not just hypercalls though, this is all about the interactions
> with multicalls no?

multicalls are just a special case of hypercalls.

Jan


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaKZOQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:16:08 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:49098 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751290AbaKZOQH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:16:07 -0500
Date: Wed, 26 Nov 2014 09:15:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, Paolo Bonzini <pbonzini@redhat.com>,
        nick <xerofoify@gmail.com>, gleb@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Another Obsolete Fix me in trace.h?
Message-ID: <20141126091543.52dc5bfe@gandalf.local.home>
In-Reply-To: <20141126124022.GC6795@potion.brq.redhat.com>
References: <5472B5B5.5090201@gmail.com>
	<54730475.9040000@redhat.com>
	<54730B33.1080101@siemens.com>
	<20141124210000.GB6795@potion.brq.redhat.com>
	<20141124161901.6266925c@gandalf.local.home>
	<20141124214939.GA6671@potion.brq.redhat.com>
	<20141126124022.GC6795@potion.brq.redhat.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2014 13:40:26 +0100
Radim Krčmář <rkrcmar@redhat.com> wrote:

> 2014-11-24 22:49+0100, Radim Krčmář:
> > 2014-11-24 16:19-0500, Steven Rostedt:
> > > That wouldn't be too hard to implement.
> > 
> > I'll look at the patch tommorrow.
> 
> The kernel part is trivial.
> Most of the code is going to be in tools/lib/traceevent/event-parse.c.
> 
> I wasn't sure whether to
> 1) define new 'enum print_arg_type' for our function and do exactly what
>    other __print* did
> 2) extend existing PRINT_FUNC with variable arguments and register it as
>    a "global" event handler
> 
> as (2) makes more sense to me, but we already had it when some __print*
> was implemented ... (and I didn't want to dig too deep into the project)

Add a new hardcoded instance. The PRINT_FUNC is for plugins that have a
unique function for the events they handle. Notice that event-parse
does not define any func handlers. If this is to be generic, then lets
make it specified as a new enum.

Thanks,

-- Steve

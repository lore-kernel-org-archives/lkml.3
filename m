Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbaKZOty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:49:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbaKZOtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:49:53 -0500
Date: Wed, 26 Nov 2014 15:49:34 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, Paolo Bonzini <pbonzini@redhat.com>,
        nick <xerofoify@gmail.com>, gleb@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Another Obsolete Fix me in trace.h?
Message-ID: <20141126144933.GA5630@potion.brq.redhat.com>
References: <5472B5B5.5090201@gmail.com>
 <54730475.9040000@redhat.com>
 <54730B33.1080101@siemens.com>
 <20141124210000.GB6795@potion.brq.redhat.com>
 <20141124161901.6266925c@gandalf.local.home>
 <20141124214939.GA6671@potion.brq.redhat.com>
 <20141126124022.GC6795@potion.brq.redhat.com>
 <20141126091543.52dc5bfe@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141126091543.52dc5bfe@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-26 09:15-0500, Steven Rostedt:
> On Wed, 26 Nov 2014 13:40:26 +0100
> Radim Krčmář <rkrcmar@redhat.com> wrote:
> > The kernel part is trivial.
> > Most of the code is going to be in tools/lib/traceevent/event-parse.c.
> > 
> > I wasn't sure whether to
> > 1) define new 'enum print_arg_type' for our function and do exactly what
> >    other __print* did
> > 2) extend existing PRINT_FUNC with variable arguments and register it as
> >    a "global" event handler
> > 
> > as (2) makes more sense to me, but we already had it when some __print*
> > was implemented ... (and I didn't want to dig too deep into the project)
> 
> Add a new hardcoded instance. The PRINT_FUNC is for plugins that have a
> unique function for the events they handle. Notice that event-parse
> does not define any func handlers. If this is to be generic, then lets
> make it specified as a new enum.

Ok, thanks.

(It just seemed weird that we have an infrastructure that could allow a
 "generic plugin" to cover this functionality.)

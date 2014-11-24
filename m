Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbaKXUFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:05:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658AbaKXUFR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:05:17 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <547381D7.2070404@de.ibm.com>
References: <547381D7.2070404@de.ibm.com> <1416834210-61738-1-git-send-email-borntraeger@de.ibm.com> <1416834210-61738-8-git-send-email-borntraeger@de.ibm.com> <15567.1416835858@warthog.procyon.org.uk> <CAADnVQJQydX9OU_rem+BObR0eWc-jrrwirUYVKH9rnN=Z8LG6A@mail.gmail.com> <CA+55aFxc72VsGTw4yFdeC1Sq65RUjYLKPD1ORnXB2d18WBMzvg@mail.gmail.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        linux-mips <linux-mips@linux-mips.org>, linux-x86_64@vger.kernel.org,
        linux-s390 <linux-s390@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH/RFC 7/7] kernel: Force ACCESS_ONCE to work only on scalar types
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <12208.1416859494.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Mon, 24 Nov 2014 20:04:54 +0000
Message-ID: <12209.1416859494@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Looks really nice, but does not work with ACCESS_ONCE is on the left-hand side:
> 
> 
> include/linux/rculist.h: In function 'hlist_add_before_rcu':
> ./arch/x86/include/asm/barrier.h:127:18: error: lvalue required as left operand of assignment
>   ACCESS_ONCE(*p) = (v);      \
> 
> Alexei's variant is also broken:
> 
> include/linux/cgroup.h: In function 'task_css':
> include/linux/compiler.h:381:40: error: invalid operands to binary + (have 'struct css_set *' and 'struct css_set * volatile')
>  #define ACCESS_ONCE(x) (((typeof(x))0) + *(volatile typeof(x) *)&(x))
> 
> Anyone with a new propopal? ;-)                                        ^

Reserve ACCESS_ONCE() for reading and add an ASSIGN_ONCE() or something like
that for writing?

David

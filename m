Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbaDKOvM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 10:51:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211AbaDKOvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 10:51:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20140410142918.GU11096@twins.programming.kicks-ass.net>
References: <20140410142918.GU11096@twins.programming.kicks-ass.net> <alpine.LNX.2.11.1404060059020.8208@bpserver.ds> <20140409121940.GA12890@node.dhcp.inet.fi>
To: Peter Zijlstra <peterz@infradead.org>
Cc: dhowells@redhat.com, "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Michael L. Semon" <mlsemon35@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, jason.low2@hp.com,
        linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
Subject: Re: cred_guard_mutex vs seq_file::lock [was: Re: 3.14.0+/x86: lockdep and mutexes not getting along]
Date: Fri, 11 Apr 2014 15:50:27 +0100
Message-ID: <26259.1397227827@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> wrote:

> Al, David, any bright ideas on how to best fix this?

Have the seq_xxx() code throw an error if current->in_execve is true.  I can't
think of any circumstance where execve() should be reading anything that uses
seq_xxx().

David

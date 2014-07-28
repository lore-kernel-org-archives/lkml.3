Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbaG1Lc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 07:32:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbaG1LcX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 07:32:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <53D31D16.1030806@oracle.com>
References: <53D31D16.1030806@oracle.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: dhowells@redhat.com, James Morris <james.l.morris@oracle.com>,
        serge@hallyn.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: security: oops on boot in __key_link_begin
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <26465.1406547132.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Mon, 28 Jul 2014 12:32:12 +0100
Message-ID: <26466.1406547132@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <sasha.levin@oracle.com> wrote:

>   23:	49 89 9f f0 00 00 00 	mov    %rbx,0xf0(%r15)
>   2a:	55                   	push   %rbp
>   2b:*	c1 b8 42 ff 49 8b 5f 	sarl   $0x5f,-0x74b600be(%rax)		<-- trapping instruction
>   32:	10 49 8d             	adc    %cl,-0x73(%rcx)

I can't make any sense of this.  It doesn't look anything like what I
get when I disassemble assoc_array_insert().  There are no SARL or ADC
instructions.

Can you load your vmlinux into gdb and disassemble the function that holds the
faulting instruction:

	gdb vmlinux
	(gdb) disassemble <RIP-value>

Unfortunately, I'm not sure what the RIP value actually is because it's been
replaced in the dump by source file + line number.  It's not this:

	[   31.330473] CR2: ffffffff8b49ff42

though.  That's RAX (ie. 0) plus the offset in the following instruction:

	sarl   $0x5f,-0x74b600be(%rax)		<-- trapping instruction

David

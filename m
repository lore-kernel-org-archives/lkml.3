Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab3EWDo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 23:44:28 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:33331 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760Ab3EWDo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 23:44:26 -0400
Date: Wed, 22 May 2013 23:48:51 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org
Subject: Re: OOPS in perf_mmap_close()
In-Reply-To: <alpine.DEB.2.10.1305221953370.11450@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.10.1305222344060.12929@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1305221523420.9944@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1305221953370.11450@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In case anyone cares, the Oops is happening here:

    1a56:       48 c1 e8 0c             shr    $0xc,%rax
    1a5a:       48 ff c0                inc    %rax
>   1a5d:       f0 48 29 45 60          lock sub %rax,0x60(%rbp)
    1a62:       49 8b 46 40             mov    0x40(%r14),%rax

Which maps to this in perf_mmap_close() in kernel/events/core.c:

                atomic_long_sub((size >> PAGE_SHIFT) + 1, &user->locked_vm);

And "user" (%rbp) is RBP: 0000000000000000, hence the problem.

I'm having trouble tracking the problem back any further as the code is a 
bit covoluted and is not commented at all.

Vince

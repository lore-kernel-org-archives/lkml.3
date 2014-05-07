Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964802AbaEGQA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:00:28 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:58548 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933033AbaEGQAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:00:24 -0400
Date: Wed, 7 May 2014 12:00:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Oleg Nesterov <oleg@redhat.com>, roland@redhat.com,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: ptrace: gpf in syscall_trace_enter
Message-ID: <20140507120022.5704e5d6@gandalf.local.home>
In-Reply-To: <536A56C3.2070505@oracle.com>
References: <53698021.5020108@oracle.com>
	<53699F7C.1040308@oracle.com>
	<20140507140422.GB17419@redhat.com>
	<20140507114938.28e300c6@gandalf.local.home>
	<536A56C3.2070505@oracle.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 May 2014 11:52:35 -0400
Sasha Levin <sasha.levin@oracle.com> wrote:


> > As the objdump is just of the object files and not the vmlinux, I would
> > need the offset from syscall_trace_leave of the RIP.
> 
>     2803:	41 ff 14 24          	callq  *(%r12)  <=== Here
>     2807:	49 83 c4 10          	add    $0x10,%r12
>     280b:	49 83 3c 24 00       	cmpq   $0x0,(%r12)

Yeah, after I sent the email, I figured it out from the 

  24 08 4c 89 ea 48 89 de <41> ff 14 24 49 83 c4 10 49

Thanks,

-- Steve

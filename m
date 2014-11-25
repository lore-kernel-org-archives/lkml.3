Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433AbaKYThp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 14:37:45 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:42607 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750784AbaKYTho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 14:37:44 -0500
Date: Tue, 25 Nov 2014 14:37:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: jkosina@suse.cz, paulmck@linux.vnet.ibm.com, pmladek@suse.cz,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/nmi: fix use of unallocated cpumask_var_t
Message-ID: <20141125143732.15d47029@gandalf.local.home>
In-Reply-To: <1416931560-10603-1-git-send-email-sasha.levin@oracle.com>
References: <1416931560-10603-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014 11:06:00 -0500
Sasha Levin <sasha.levin@oracle.com> wrote:

> Commit "x86/nmi: Perform a safe NMI stack trace on all CPUs" has introduced
> a cpumask_var_t variable:
> 
> 	+static cpumask_var_t printtrace_mask;
> 
> But never allocated it before using it, which caused a NULL ptr deref when
> trying to print the stack trace:

Thanks, I pulled this in and I'm running it under my test suite now.

-- Steve

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774AbaHAJrD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 05:47:03 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:35222 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaHAJrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 05:47:01 -0400
Date: Fri, 1 Aug 2014 15:18:44 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip ] [BUGFIX] kprobes: Skip kretprobe hit in NMI
 context to avoid deadlock
Message-ID: <20140801094844.GA4329@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20140801084254.12330.64728.stgit@kbuild-fedora.novalocal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140801084254.12330.64728.stgit@kbuild-fedora.novalocal>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080109-6688-0000-0000-000003B2AC1D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 08:42:54AM +0000, Masami Hiramatsu wrote:
> Skip kretprobe hit in NMI context, because if an NMI happens
> inside the critical section protected by kretprobe_table.lock
> and another(or same) kretprobe hit, pre_kretprobe_handler
> tries to lock kretprobe_table.lock again.
> Normal interrupts have no problem because they are disabled
> with the lock.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>


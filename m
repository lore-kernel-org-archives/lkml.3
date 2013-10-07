Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab3JGSKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 14:10:23 -0400
Received: from one.firstfloor.org ([193.170.194.197]:36113 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab3JGSKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 14:10:21 -0400
Date: Mon, 7 Oct 2013 20:10:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Janani Venkataraman <jananive@in.ibm.com>,
        linux-kernel@vger.kernel.org, amwang@redhat.com, rdunlap@xenotime.net,
        aravinda@linux.vnet.ibm.com, hch@lst.de, mhiramat@redhat.com,
        jeremy.fitzhardinge@citrix.com, xemul@parallels.com,
        suzuki@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com,
        adobriyan@gmail.com, tarundsk@linux.vnet.ibm.com, vapier@gentoo.org,
        roland@hack.frob.com, tj@kernel.org, ananth@linux.vnet.ibm.com,
        gorcunov@openvz.org, avagin@openvz.org, oleg@redhat.com,
        eparis@redhat.com, d.hatayama@jp.fujitsu.com, james.hogan@imgtec.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [RFC] [PATCH 00/19] Non disruptive application core dump
 infrastructure using task_work_add()
Message-ID: <20131007181018.GL6882@two.firstfloor.org>
References: <20131004102532.1612.24185.stgit@f19-x64>
 <20131004134421.GG6882@two.firstfloor.org>
 <52524FAA.1030901@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52524FAA.1030901@in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Couldn't they just use the new process_vm_readv() syscalls instead?
> > AFAIK those do not require ptrace.
> > 
> We need the register set and hence would need a ptrace.

But the kernel needs to stop to to read the registers.

Do you have data how much the latency difference is between
an optimized ptrace reader (using PTRACE_GETREGSET) vs the kernel ?

-Andi

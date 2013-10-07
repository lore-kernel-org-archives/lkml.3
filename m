Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab3JGOGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 10:06:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754962Ab3JGOGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 10:06:05 -0400
Date: Mon, 7 Oct 2013 15:58:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Janani Venkataraman <jananive@in.ibm.com>,
        linux-kernel@vger.kernel.org, amwang@redhat.com, rdunlap@xenotime.net,
        aravinda@linux.vnet.ibm.com, hch@lst.de, mhiramat@redhat.com,
        jeremy.fitzhardinge@citrix.com, xemul@parallels.com,
        suzuki@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com,
        adobriyan@gmail.com, tarundsk@linux.vnet.ibm.com, vapier@gentoo.org,
        roland@hack.frob.com, tj@kernel.org, ananth@linux.vnet.ibm.com,
        gorcunov@openvz.org, avagin@openvz.org, eparis@redhat.com,
        d.hatayama@jp.fujitsu.com, james.hogan@imgtec.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [RFC] [PATCH 00/19] Non disruptive application core dump
	infrastructure using task_work_add()
Message-ID: <20131007135805.GA26801@redhat.com>
References: <20131004102532.1612.24185.stgit@f19-x64> <20131004134421.GG6882@two.firstfloor.org> <52524FAA.1030901@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52524FAA.1030901@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07, Suzuki K. Poulose wrote:
>
> On 10/04/2013 07:14 PM, Andi Kleen wrote:
>
> > Couldn't they just use the new process_vm_readv() syscalls instead?
> > AFAIK those do not require ptrace.
> >
> We need the register set and hence would need a ptrace.

Or the task itself can dump its memory/registers/whatever in responce
to the request from dumper.

gencore_work() is only used to freeze the process, but it can do more?

Oleg.


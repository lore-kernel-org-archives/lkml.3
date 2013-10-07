Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab3JGTDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 15:03:34 -0400
Received: from mail-ye0-f173.google.com ([209.85.213.173]:40502 "EHLO
	mail-ye0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756609Ab3JGTD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 15:03:27 -0400
Date: Mon, 7 Oct 2013 14:57:48 -0400
From: Tejun Heo <tj@kernel.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Janani Venkataraman <jananive@in.ibm.com>, linux-kernel@vger.kernel.org,
        amwang@redhat.com, rdunlap@xenotime.net, andi@firstfloor.org,
        aravinda@linux.vnet.ibm.com, hch@lst.de, mhiramat@redhat.com,
        jeremy.fitzhardinge@citrix.com, suzuki@linux.vnet.ibm.com,
        kosaki.motohiro@jp.fujitsu.com, adobriyan@gmail.com,
        tarundsk@linux.vnet.ibm.com, vapier@gentoo.org, roland@hack.frob.com,
        ananth@linux.vnet.ibm.com, gorcunov@openvz.org, avagin@openvz.org,
        oleg@redhat.com, eparis@redhat.com, d.hatayama@jp.fujitsu.com,
        james.hogan@imgtec.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org
Subject: Re: [RFC] [PATCH 00/19] Non disruptive application core dump
 infrastructure using task_work_add()
Message-ID: <20131007185748.GE27396@htj.dyndns.org>
References: <20131004102532.1612.24185.stgit@f19-x64>
 <524E9AB3.2080307@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524E9AB3.2080307@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Oct 04, 2013 at 02:38:43PM +0400, Pavel Emelyanov wrote:
> > * It is not upstream yet.
> 
> It is, starting from criu-v0.7 + linux-3.11
> 
> > * There are concerns about the security of the dump.
> 
> Can you elaborate on this? Is it fixable in CRIU at all?
> 
> > * It involves a lot of changes and this approach provides a UNIX style 
> >   interface.
> 
> Can you also shed more light on this -- what changes do you mean?

Yeah, I'd like to hear more too.  It doesn't make much sense to me to
add something completely new if it can be served mostly by the
existing infrastructure.  Also, what do you mean by "disruption"?  You
mentioned signal but PTRACE_SEIZE is completely transparent
w.r.t. signals.  If you mean without stopping the target process's
execution, what are you trying to use the dumping for and how much
gain are we talking about?  Also, isn't it kinda mandatory to stop the
process to get a consistent dump?  What am I missing here?

Thanks.

-- 
tejun

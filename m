Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab3JHKQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:16:45 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:38283 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756402Ab3JHKQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:16:20 -0400
In-Reply-To: <20131007185748.GE27396@htj.dyndns.org>
References: <20131004102532.1612.24185.stgit@f19-x64> <524E9AB3.2080307@parallels.com> <20131007185748.GE27396@htj.dyndns.org>
Subject: Re: [RFC] [PATCH 00/19] Non disruptive application core dump infrastructure
 using task_work_add()
X-KeepSent: FC1629CE:3E505A92-65257BFE:00381269;
 type=4; name=$KeepSent
To: Tejun Heo <tj@kernel.org>
Cc: adobriyan@gmail.com, akpm@linux-foundation.org, amwang@redhat.com,
        ananth@linux.vnet.ibm.com, andi@firstfloor.org,
        aravinda@linux.vnet.ibm.com, avagin@openvz.org,
        d.hatayama@jp.fujitsu.com, eparis@redhat.com, gorcunov@openvz.org,
        hch@lst.de, Tejun Heo <htejun@gmail.com>, james.hogan@imgtec.com,
        jeremy.fitzhardinge@citrix.com, kosaki.motohiro@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, mhiramat@redhat.com, oleg@redhat.com,
        rdunlap@xenotime.net, roland@hack.frob.com, suzuki@linux.vnet.ibm.com,
        tarundsk@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        vapier@gentoo.org, Pavel Emelyanov <xemul@parallels.com>
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
Message-ID: <OFFC1629CE.3E505A92-ON65257BFE.00381269-65257BFE.003837B3@in.ibm.com>
From: Janani Venkataraman1 <jananive@in.ibm.com>
Date: Tue, 8 Oct 2013 15:44:34 +0530
X-MIMETrack: Serialize by Router on d23ml068/23/M/IBM(Release 8.5.3FP2HF29 | July 24, 2012) at
 08/10/2013 15:44:49
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100810-8256-0000-0000-0000098DB40C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





From:	Tejun Heo <tj@kernel.org>
To:	Pavel Emelyanov <xemul@parallels.com>,
Cc:	Janani Venkataraman1/India/IBM@IBMIN,
            linux-kernel@vger.kernel.org, amwang@redhat.com,
            rdunlap@xenotime.net, andi@firstfloor.org,
            aravinda@linux.vnet.ibm.com, hch@lst.de, mhiramat@redhat.com,
            jeremy.fitzhardinge@citrix.com, suzuki@linux.vnet.ibm.com,
            kosaki.motohiro@jp.fujitsu.com, adobriyan@gmail.com,
            tarundsk@linux.vnet.ibm.com, vapier@gentoo.org,
            roland@hack.frob.com, ananth@linux.vnet.ibm.com,
            gorcunov@openvz.org, avagin@openvz.org, oleg@redhat.com,
            eparis@redhat.com, d.hatayama@jp.fujitsu.com,
            james.hogan@imgtec.com, akpm@linux-foundation.org,
            torvalds@linux-foundation.org
Date:	10/08/2013 12:26 AM
Subject:	Re: [RFC] [PATCH 00/19] Non disruptive application core dump
            infrastructure using task_work_add()
Sent by:	Tejun Heo <htejun@gmail.com>



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
w.r.t. signals. If you mean without stopping the target process's
execution, what are you trying to use the dumping for and how much
gain are we talking about?  Also, isn't it kinda mandatory to stop the
process to get a consistent dump?  What am I missing here?

By disruption we do mean not using signals. PTRACE_SEIZE doesn't use
signals,
but the concern is, a seize can't be done on oneself and we are looking at
also
a self dump.

Thanks.
Janani

Thanks.

--
tejun




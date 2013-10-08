Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313Ab3JHKOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:14:04 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:55024 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab3JHKNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:13:48 -0400
In-Reply-To: <524E9AB3.2080307@parallels.com>
References: <20131004102532.1612.24185.stgit@f19-x64> <524E9AB3.2080307@parallels.com>
Subject: Re: [RFC] [PATCH 00/19] Non disruptive application core dump infrastructure
 using task_work_add()
X-KeepSent: E96703A1:612D0E95-65257BFE:00379B31;
 type=4; name=$KeepSent
To: Pavel Emelyanov <xemul@parallels.com>
Cc: adobriyan@gmail.com, akpm@linux-foundation.org, amwang@redhat.com,
        ananth@linux.vnet.ibm.com, andi@firstfloor.org,
        aravinda@linux.vnet.ibm.com, avagin@openvz.org,
        d.hatayama@jp.fujitsu.com, eparis@redhat.com, gorcunov@openvz.org,
        hch@lst.de, james.hogan@imgtec.com, jeremy.fitzhardinge@citrix.com,
        kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        mhiramat@redhat.com, oleg@redhat.com, rdunlap@xenotime.net,
        roland@hack.frob.com, suzuki@linux.vnet.ibm.com,
        tarundsk@linux.vnet.ibm.com, tj@kernel.org,
        torvalds@linux-foundation.org, vapier@gentoo.org
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
Message-ID: <OFE96703A1.612D0E95-ON65257BFE.00379B31-65257BFE.0037FF3B@in.ibm.com>
From: Janani Venkataraman1 <jananive@in.ibm.com>
Date: Tue, 8 Oct 2013 15:42:10 +0530
X-MIMETrack: Serialize by Router on d23ml068/23/M/IBM(Release 8.5.3FP2HF29 | July 24, 2012) at
 08/10/2013 15:42:11
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100810-2674-0000-0000-00000AF47D57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





From:	Pavel Emelyanov <xemul@parallels.com>
To:	Janani Venkataraman1/India/IBM@IBMIN,
Cc:	<linux-kernel@vger.kernel.org>, <amwang@redhat.com>,
            <rdunlap@xenotime.net>, <andi@firstfloor.org>,
            <aravinda@linux.vnet.ibm.com>, <hch@lst.de>,
            <mhiramat@redhat.com>, <jeremy.fitzhardinge@citrix.com>,
            <suzuki@linux.vnet.ibm.com>, <kosaki.motohiro@jp.fujitsu.com>,
            <adobriyan@gmail.com>, <tarundsk@linux.vnet.ibm.com>,
            <vapier@gentoo.org>, <roland@hack.frob.com>, <tj@kernel.org>,
            <ananth@linux.vnet.ibm.com>, <gorcunov@openvz.org>,
            <avagin@openvz.org>, <oleg@redhat.com>, <eparis@redhat.com>,
            <d.hatayama@jp.fujitsu.com>, <james.hogan@imgtec.com>,
            <akpm@linux-foundation.org>, <torvalds@linux-foundation.org>
Date:	10/04/2013 04:08 PM
Subject:	Re: [RFC] [PATCH 00/19] Non disruptive application core dump
            infrastructure using task_work_add()



On 10/04/2013 02:30 PM, Janani Venkataraman wrote:
> Hi all,
>

> This series is based on the Task work add approach. We didn't adopt the
CRIU
> approch because of the following reasons:
>
> * It is not upstream yet.

It is, starting from criu-v0.7 + linux-3.11

> * There are concerns about the security of the dump.

Can you elaborate on this? Is it fixable in CRIU at all?

> * It involves a lot of changes and this approach provides a UNIX style
>   interface.

Can you also shed more light on this -- what changes do you mean?

We had a prototype ready earlier using the freezer approach.
http://lwn.net/Articles/419756/

We made a couple of minor changes to it and implemented using task work
add.
We  wanted to know what the community felt about this approach.

Also in the previous RFD, Andi Kleen had mentioned a concern on the
security with
respect to the daemon approach for a self dump in CRIU.

Thanks.
Janani


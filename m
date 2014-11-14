Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964982AbaKNBjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:39:45 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60229 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934544AbaKNBjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:39:43 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.2.3
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20140219-2
Date: Fri, 14 Nov 2014 10:42:35 +0900 (JST)
Message-Id: <20141114.104235.926535445994740268.d.hatayama@jp.fujitsu.com>
To: ptesarik@suse.cz
Cc: vgoyal@redhat.com, kumagai-atsushi@mxc.nes.nec.co.jp, anderson@redhat.com,
        kexec@lists.infradead.org, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kdump, x86: report actual value of phys_base in
 VMCOREINFO
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <20141113154810.2ee36e72@hananiah.suse.cz>
References: <54646C1D.1050102@jp.fujitsu.com>
	<20141113142548.GA1978@redhat.com>
	<20141113154810.2ee36e72@hananiah.suse.cz>
X-Mailer: Mew version 6.6 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Petr Tesarik <ptesarik@suse.cz>
Subject: Re: [PATCH] kdump, x86: report actual value of phys_base in VMCOREINFO
Date: Thu, 13 Nov 2014 15:48:10 +0100

> On Thu, 13 Nov 2014 09:25:48 -0500
> Vivek Goyal <vgoyal@redhat.com> wrote:
> 
>> On Thu, Nov 13, 2014 at 05:30:21PM +0900, HATAYAMA, Daisuke wrote:
>> > 
>> > (2014/11/13 17:06), Petr Tesarik wrote:
>> > >On Thu, 13 Nov 2014 09:17:09 +0900 (JST)
>> > >HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> wrote:
>> > >
>> > >>From: Vivek Goyal <vgoyal@redhat.com>
>> > >>Subject: Re: [PATCH] kdump, x86: report actual value of phys_base in VMCOREINFO
>> > >>Date: Wed, 12 Nov 2014 17:12:05 -0500
>> > >>
>> > >>>On Wed, Nov 12, 2014 at 03:40:42PM +0900, HATAYAMA Daisuke wrote:
>> > >>>>Currently, VMCOREINFO note information reports the virtual address of
>> > >>>>phys_base that is assigned to symbol phys_base. But this doesn't make
>> > >>>>sense because to refer to value of the phys_base, it's necessary to
>> > >>>>get the value of phys_base itself we are now about to refer to.
>> > >>>>
>> > >>>
>> > >>>Hi Hatayama,
>> > >>>
>> > >>>/proc/vmcore ELF headers have virtual address information and using
>> > >>>that you should be able to read actual value of phys_base. gdb deals
>> > >>>with virtual addresses all the time and can read value of any symbol
>> > >>>using those headers.
>> > >>>
>> > >>>So I am not sure what's the need for exporting actual value of
>> > >>>phys_base.
>> > >>>
>> > >>
>> > >>Sorry, my logic in the patch description was wrong. For /proc/vmcore,
>> > >>there's enough information for makedumpdile to get phys_base. It's
>> > >>correct. The problem here is that other crash dump mechanisms that run
>> > >>outside Linux kernel independently don't have information to get
>> > >>phys_base.
>> > >
>> > >Yes, but these mechanisms won't be able to read VMCOREINFO either, will
>> > >they?
>> > >
>> > 
>> > I don't intend such sophisticated function only by VMCOREINFO.
>> > Search vmcore for VMCOREINFO using strings + grep before opening it by crash.
>> > I intend that only here.
>> 
>> I think this is very crude and not proper way to get to vmcoreinfo.
> 
> Same here. If VMCOREINFO must be locatable without communicating any
> information to the hypervisor, then I would rather go for something
> similar to what s390(x) folks do - a well-known location in physical
> memory that contains a pointer to a checksummed OS info structure,
> which in turn contains the VMCOREINFO pointers.
> 
> I'm a bit surprised such mechanism is not needed by Fujitsu SADUMP.
> Or is that part of the current plan, Daisuke?
> 

It's useful if there is. I don't plan now. For now, the idea of this
patch is enough for me.

BTW, for the above idea, I suspect that if the location in the
physical memory is unique, it cannot deal with the kdump 2nd kernel
case. I think it better for the idea to be able to represent multiple
kernel information.

--
Thanks.
HATAYAMA, Daisuke


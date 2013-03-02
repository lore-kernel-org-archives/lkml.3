Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544Ab3CBFqE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 00:46:04 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:62437 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3CBFqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 00:46:01 -0500
MIME-Version: 1.0
In-Reply-To: <CAD11hGx5N9Eqy5bX-SEv9c7oR6Ehz2pUJwdrK0Q=L4S44RC5gg@mail.gmail.com>
References: <512B7D10.4060304@tpi.com>
	<512B8407.2090807@canonical.com>
	<512BD753.4080001@hp.com>
	<CAE9FiQVY4io_mO3PhTtE6FbGUgo1uZKKXO=pjx_FoZ1JuZmsAw@mail.gmail.com>
	<CAE9FiQXRZ2VjfG4L2d2zDQ3Sud=JqjS=M9=XW=ORS58_y7i4_g@mail.gmail.com>
	<CAE9FiQU-CV4mF8x=Bi_4pmpmeZW-tSoes_f-jOt7yYrbrppo+A@mail.gmail.com>
	<512D58C2.1090403@jp.fujitsu.com>
	<CAE9FiQV5APHSGXuz3NrsApC+V7rsDQMDXMNwZszZuUqQVaZSew@mail.gmail.com>
	<512D7FAD.1040003@jp.fujitsu.com>
	<CAE9FiQWxq-HPKK+XNRLggZSM4NcdfaeGDWCgd3HegEhaDSSTtA@mail.gmail.com>
	<512D8EDA.3010602@jp.fujitsu.com>
	<CAE9FiQWAxL6F70fF0dQcBZKTReJOiC+Ez0xcqcosgAdSagS-bA@mail.gmail.com>
	<512DBD24.7090302@cn.fujitsu.com>
	<20130227132612.14664a3a.akpm@linux-foundation.org>
	<CA+55aFz8Yx4=d=Lrmir0Vy0jhUBJMgfrJegDWsDByf28c0MuRQ@mail.gmail.com>
	<51302481.9070005@cn.fujitsu.com>
	<CA+55aFw_1wDHmu+wsfV5e0miHC20Guy=u_toG_VSnsqneryAHQ@mail.gmail.com>
	<513030AF.70208@zytor.com>
	<CAE9FiQXb7K=QTR4PgMdNSoPm2LgYkxAuXUUZ0BXtgicQOGOaUA@mail.gmail.com>
	<CAE9FiQXFVnO43TUFOt_zSL=QGDFmERQLfku3WJHgOPGTxf+XUA@mail.gmail.com>
	<CAE9FiQVhdb-tKQ3-vcqLz8VNxc1NSekU_tPBNUng1JHQWci_ag@mail.gmail.com>
	<CAD11hGx5N9Eqy5bX-SEv9c7oR6Ehz2pUJwdrK0Q=L4S44RC5gg@mail.gmail.com>
Date: Fri, 1 Mar 2013 21:46:00 -0800
X-Google-Sender-Auth: oNdEPEVQlSk06R6Hp0IqiFf8hME
Message-ID: <CAE9FiQXP7NxJZW-4w-PdGpd3TstT3eoboJ8b8txgrxAuJMDzhg@mail.gmail.com>
Subject: Re: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
From: Yinghai Lu <yinghai@kernel.org>
To: chen tang <imtangchen@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Don Morris <don.morris@hp.com>,
        Tim Gardner <tim.gardner@canonical.com>, Tejun Heo <tj@kernel.org>,
        Tony Luck <tony.luck@intel.com>, Thomas Renninger <trenn@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 1, 2013 at 7:03 PM, chen tang <imtangchen@gmail.com> wrote:
>
> Thank you for your suggestion and fix work. :)
> I would prefer your Plan b. But one last thing I want to confirm:
>
> Will "allocating pgdat and zone on local node" prevent node hot-removing ?
> Or is it safe to free all node data when removing a node ?
> AFAIK, no way to ensure node data is not on thread stack.

Not sure. I need to go over the code.
That is slub's limitation.

If it is not, it should be fixed.

>
> If it is OK, I think Plan B is OK, and we can improve movablemem_map more in
> the future.
>
> BTW, I didn't mean to deny your idea and work. NUMA performance is always
> understand our  consideration.
> It's just we plan it as a long way development in the future.
> movablemem_map is very important to us. And we do hope to keep it in kernel
> now, and improve it later.

That does not look like right way to do development with mainline tree
to add new
features.

You don't need to put development/testing support patches in the mainline.
Just put those support patches in your local tree.

Everyone have bunch of development/debug/teststub patches in their own
hardisk for their working area, but don't need put them into mainline tree.

Good practice should be:
Have the feature completely done in your local tree and etc.
then send out several patchset. and get reviewed and get merged
one by one.

Sometime would turn out that your whole patchset has problem that
can not be fixed during review, and should be redesign again.

Mainline tree is NOT testbed.

For pci-root-bus hotplug, I already had code done completely.
Then send out patchset one by one to get completely review.
One patchset about acpi-scan is totally rewritten by Rafael after he understood
our needs with better and clean design.
Now still have ioapic and iommu left, and those patchset have been in
my local tree more than 6 months and I keep optimizing them.

BTW, Please do not top-post later.

Thanks

Yinghai

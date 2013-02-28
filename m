Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab3B1QHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 11:07:08 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:35928 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab3B1QHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 11:07:03 -0500
MIME-Version: 1.0
In-Reply-To: <512DB96E.5030408@cn.fujitsu.com>
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
	<512D9E69.6010102@jp.fujitsu.com>
	<CAE9FiQV9JRk1SYLkBXsQmrSEDHrYZDpBV6UZb+U5rB7=4gFhVA@mail.gmail.com>
	<512DB199.5050203@cn.fujitsu.com>
	<CAE9FiQXvdXoW8xFO2Q_dJo4jRkse5Lg9TmLHuFhqZ9H92ipsuw@mail.gmail.com>
	<512DB96E.5030408@cn.fujitsu.com>
Date: Thu, 28 Feb 2013 08:07:02 -0800
X-Google-Sender-Auth: 1G15YHAjpw4Yp7u2NOAlZAstMjI
Message-ID: <CAE9FiQWx9TUwF6mXyhKDX=OZNsubvDebViyyTrA9EQpBZ6FsKw@mail.gmail.com>
Subject: Re: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
From: Yinghai Lu <yinghai@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Don Morris <don.morris@hp.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Thomas Renninger <trenn@suse.de>,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        a.p.zijlstra@chello.nl, jarkko.sakkinen@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 11:44 PM, Tang Chen <tangchen@cn.fujitsu.com> wrote:
>
> Sorry, if you want to revert, you just need to revert:
>
>  commit e8d1955258091e4c92d5a975ebd7fd8a98f5d30f
>       acpi, memory-hotplug: parse SRAT before memblock is ready
>  commit 01a178a94e8eaec351b29ee49fbb3d1c124cb7fb
>       acpi, memory-hotplug: support getting hotplug info from SRAT
>
> The other two have nothing to do with SRAT. And they are necessary.
>
> Seeing from the code, I think it is clean. But we'd better test it.

We should revert them all.

as

commit fb06bc8e5f42f38c011de0e59481f464a82380f6
Author: Tang Chen <tangchen@cn.fujitsu.com>
Date:   Fri Feb 22 16:33:42 2013 -0800

    page_alloc: bootmem limit with movablecore_map

It is totally misleading in the TITLE. Come on, what is movablecore_map?

It actually use movablemem_map to exclude some range during
memblock_find_in_range.

That make memblock less generic.

That patch is the base of the whole patchset.

Also you and Yasuaki keep saying: movablemem_map=srat.
But where is doc and code for it?
Looks like there is only movablemem_map=acpi.

I'm upset by this patchset.

Next time, please get Ack from TJ or Ben when you touch memblock code.
And at least make the TITLE is right.

Thanks

Yinghai

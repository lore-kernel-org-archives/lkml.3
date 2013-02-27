Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760380Ab3B0Ra7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 12:30:59 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:50370 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab3B0Ra6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 12:30:58 -0500
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F1E06EB22@ORSMSX108.amr.corp.intel.com>
References: <512B7D10.4060304@tpi.com>
	<512B8407.2090807@canonical.com>
	<512BD753.4080001@hp.com>
	<CAE9FiQVY4io_mO3PhTtE6FbGUgo1uZKKXO=pjx_FoZ1JuZmsAw@mail.gmail.com>
	<CAE9FiQXRZ2VjfG4L2d2zDQ3Sud=JqjS=M9=XW=ORS58_y7i4_g@mail.gmail.com>
	<CAE9FiQU-CV4mF8x=Bi_4pmpmeZW-tSoes_f-jOt7yYrbrppo+A@mail.gmail.com>
	<512D58C2.1090403@jp.fujitsu.com>
	<3908561D78D1C84285E8C5FCA982C28F1E06EB22@ORSMSX108.amr.corp.intel.com>
Date: Wed, 27 Feb 2013 09:30:57 -0800
X-Google-Sender-Auth: F_q52lYegWAz9vZpf4Ilqjg8dAE
Message-ID: <CAE9FiQV+FGmUwOgMJkcUkxdGgO_xgUEVQJ5eiLJPkjXa8XGRig@mail.gmail.com>
Subject: Re: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
From: Yinghai Lu <yinghai@kernel.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Don Morris <don.morris@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Gardner <tim.gardner@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>,
        "tangchen@cn.fujitsu.com" <tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 8:28 AM, Luck, Tony <tony.luck@intel.com> wrote:
>> assume first cpu only have 1G ram, and other 31 socket will have bunch of ram
>
> That doesn't seem to be a very realistic assumption. Can you even still buy 1G
> DIMMs for servers?   I'd think that a minimum would be to have each of four
> channels populated with a 4G DIMM - so 16GB on first cpu. But even that feels
> rather low.

We could use memmap= to exclude mem, right?

>
> I think that making sure that the system can boot is good (and maybe it should
> ignore/override[*] parameters that would prevent booting). But let's be realistic
> about the cases we actually have to deal with (before somebody comes and talks
> about systems with just 16MB).

About make memory hotplug working:
1. find out ram that is used by kernel in early time.
2. check if
   a. it is with kernel code that will not be moved.
       like real_mode.
   b. it will be freed to slub before run time.
       like init code and initrd disk.
   c. if it is on local node ram that will not prevent mem hot-remove
       like page table and vmemmap.
       current we already have vmemmap and node_data on local node.
       May need to put page table on local node too. or just put page
       table with local node that kernel is on.
   d. something could be anywhere, and could be moved down after
       slub is ready.

movablemem_map patchset prevents kernel using kernel from local node.



In that case, so they should just boot system with numa=off.

Thanks

Yinghai

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab3CAHzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 02:55:32 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:42407 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab3CAHza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 02:55:30 -0500
MIME-Version: 1.0
In-Reply-To: <5130447F.4070706@jp.fujitsu.com>
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
	<5130447F.4070706@jp.fujitsu.com>
Date: Thu, 28 Feb 2013 23:55:29 -0800
X-Google-Sender-Auth: ugSYWXxFTJYPf5qqBGrBb7UrabU
Message-ID: <CAE9FiQWLys4BopOzSfVK8Smt6xzN+Q=xNk801nS6ac2qZEgo3w@mail.gmail.com>
Subject: Re: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
From: Yinghai Lu <yinghai@kernel.org>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Don Morris <don.morris@hp.com>,
        Tim Gardner <tim.gardner@canonical.com>, Tejun Heo <tj@kernel.org>,
        Tony Luck <tony.luck@intel.com>, Thomas Renninger <trenn@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Wen Congyang <wency@cn.fujitsu.com>, Lin Feng <linfeng@cn.fujitsu.com>,
        "guz.fnst@cn.fujitsu.com" <guz.fnst@cn.fujitsu.com>,
        Gui jianfeng <guijianfeng@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 10:02 PM, Yasuaki Ishimatsu
<isimatu.yasuaki@jp.fujitsu.com> wrote:
> 2013/03/01 14:00, Yinghai Lu wrote:
>
> Original issue occurs by two patches. And it is fixed by Tang's reverting
> patch. So other patches are obviously unrelated to original problem. Thus
> there is no reason to revert all patches related with movablemem_map.
>
> If there is a reason, movablemem_map patches prevent only your work.
>
> If you keep on developing your work, you should develop it in consideration
> of those patches.

Let me try again:

movablemem_map is broken idea or poor design.

It just push down kernel memory from local node to some place.

It is ridiculous to let use specify mem range in command line to make
memory hotplug working.
Think about different memory layout conf, that will drive customer crazy.
Also not mention there is performance regarding put numa data low.

Right way or good pratice is:
Find out those kernel memory that can not be moved, either put them low
or make it to local node ram.

Thanks

Yinghai

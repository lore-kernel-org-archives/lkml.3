Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab3CUVGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:06:36 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:37615 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab3CUVGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:06:35 -0400
MIME-Version: 1.0
In-Reply-To: <0000013d8ec2b268-851c8d6d-c4d1-42fb-b0e1-e1b90de7d911-000000@email.amazonses.com>
References: <CAFTL4hybMf+9GjjyKRSEEp0x+wT7OwpKShE5sR_JqW24DGfKOw@mail.gmail.com>
	<1363636794.15703.32@driftwood>
	<CAFTL4hz=VKCchgvKcSHbctZcRyjCSmCbLu6OhLz0zEcYA20zOQ@mail.gmail.com>
	<20130318222548.GG3656@linux.vnet.ibm.com>
	<1363822338.6345.33.camel@gandalf.local.home>
	<20130320235545.GL3637@linux.vnet.ibm.com>
	<0000013d8db514e4-bf492080-82c9-412a-90b8-54ddc1463e4b-000000@email.amazonses.com>
	<20130321171518.GW3637@linux.vnet.ibm.com>
	<0000013d8e3f58ce-0f6ea95f-780a-49c1-a633-5aa0cf3e5040-000000@email.amazonses.com>
	<20130321185821.GF3637@linux.vnet.ibm.com>
	<0000013d8e8d24fd-d2931c45-2722-46d1-8b47-2ef11e21096d-000000@email.amazonses.com>
	<CAFTL4hywucK7_d2V-wYkhagu0+izYz_MTFNJEHEsaTvoZBXwMg@mail.gmail.com>
	<0000013d8ec2b268-851c8d6d-c4d1-42fb-b0e1-e1b90de7d911-000000@email.amazonses.com>
Date: Thu, 21 Mar 2013 22:06:33 +0100
Message-ID: <CAFTL4hxJ1GoE6fTXH_CZpSUHmxVC=SmNkdSSB-k0rOz_+4Zcqw@mail.gmail.com>
Subject: Re: [PATCH] nohz1: Documentation
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org, josh@joshtriplett.org,
        zhong@linux.vnet.ibm.com, khilman@linaro.org, geoff@infradead.org,
        tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/21 Christoph Lameter <cl@linux.com>:
> On Thu, 21 Mar 2013, Frederic Weisbecker wrote:
>
>> Sure, for now just don't use SCHED_FIFO and you will have a much more
>> extended dynticks coverage.
>
> Ah. Ok. Important information. That would mean no tick for the 2 second
> intervals between the vm stats etc. Much much better than now where we
> have a tick 1000 times per second.

I can't guarantee no tick, there can be many reasons for the tick to
happen. But if you don't run SCHED_FIFO, the pending kernel thread can
execute quickly and give back the CPU for your task alone, then the
tick can shut down again.

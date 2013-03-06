Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab3CFNe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 08:34:57 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:56735 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782Ab3CFNex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 08:34:53 -0500
MIME-Version: 1.0
In-Reply-To: <1362514928.6267.16.camel@lambeau>
References: <20130205214818.4615.12937.stgit@lambeau>
	<CAFTL4hyYO7s2u-dRLExA1=TxD00O1XyPe9qFwnODrWi_p92Jqg@mail.gmail.com>
	<20130219011104.GA5785@amt.cnet>
	<1362514928.6267.16.camel@lambeau>
Date: Wed, 6 Mar 2013 14:34:51 +0100
Message-ID: <CAFTL4hzaVXZDLfR6YRRrPXRJ9_Xijg4g2ZMcNar5132XUP6EQw@mail.gmail.com>
Subject: Re: [PATCH 0/4] Alter steal-time reporting in the guest
From: Frederic Weisbecker <fweisbec@gmail.com>
To: mjw@linux.vnet.ibm.com
Cc: Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
        riel@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        peterz@infradead.org, glommer@parallels.com, mingo@redhat.com,
        anthony@codemonkey.ws
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/5 Michael Wolf <mjw@linux.vnet.ibm.com>:
> Sorry for the delay in the response.  I did not see the email
> right away.
>
> On Mon, 2013-02-18 at 22:11 -0300, Marcelo Tosatti wrote:
>> On Mon, Feb 18, 2013 at 05:43:47PM +0100, Frederic Weisbecker wrote:
>> > 2013/2/5 Michael Wolf <mjw@linux.vnet.ibm.com>:
>> > > In the case of where you have a system that is running in a
>> > > capped or overcommitted environment the user may see steal time
>> > > being reported in accounting tools such as top or vmstat.  This can
>> > > cause confusion for the end user.
>> >
>> > Sorry, I'm no expert in this area. But I don't really understand what
>> > is confusing for the end user here.
>>
>> I suppose that what is wanted is to subtract stolen time due to 'known
>> reasons' from steal time reporting. 'Known reasons' being, for example,
>> hard caps. So a vcpu executing instructions with no halt, but limited to
>> 80% of available bandwidth, would not have 20% of stolen time reported.
>
> Yes exactly and the end user many times did not set up the guest and is
> not aware of the capping.  The end user is only aware of the performance
> level that they were told they would get with the guest.
>
>>
>> But yes, a description of the scenario that is being dealt with, with
>> details, is important.
>
> I will add more detail to the description next time I submit the
> patches.  How about something like,"In a cloud environment the user of a
> kvm guest is not aware of the underlying hardware or how many other
> guests are running on it.  The end user is only aware of a level of
> performance that they should see."   or does that just muddy the picture
> more??

That alone is probably not enough. But yeah, make sure you clearly
state the difference between expected (caps, sched bandwidth...) and
unexpected (overcommitting, competing load...) stolen time. Then add a
practical example as you made above that explains why it matters to
make that distinction and why you want to report it.

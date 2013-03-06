Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab3CFNUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 08:20:39 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:37999 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab3CFNUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 08:20:38 -0500
MIME-Version: 1.0
In-Reply-To: <20130219011104.GA5785@amt.cnet>
References: <20130205214818.4615.12937.stgit@lambeau>
	<CAFTL4hyYO7s2u-dRLExA1=TxD00O1XyPe9qFwnODrWi_p92Jqg@mail.gmail.com>
	<20130219011104.GA5785@amt.cnet>
Date: Wed, 6 Mar 2013 14:20:36 +0100
Message-ID: <CAFTL4hx8ibTVQpObiEpribKZNhYSpwm05dOf9-CGX7YiVdC2qg@mail.gmail.com>
Subject: Re: [PATCH 0/4] Alter steal-time reporting in the guest
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Michael Wolf <mjw@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        riel@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        peterz@infradead.org, glommer@parallels.com, mingo@redhat.com,
        anthony@codemonkey.ws
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/19 Marcelo Tosatti <mtosatti@redhat.com>:
> On Mon, Feb 18, 2013 at 05:43:47PM +0100, Frederic Weisbecker wrote:
>> 2013/2/5 Michael Wolf <mjw@linux.vnet.ibm.com>:
>> > In the case of where you have a system that is running in a
>> > capped or overcommitted environment the user may see steal time
>> > being reported in accounting tools such as top or vmstat.  This can
>> > cause confusion for the end user.
>>
>> Sorry, I'm no expert in this area. But I don't really understand what
>> is confusing for the end user here.
>
> I suppose that what is wanted is to subtract stolen time due to 'known
> reasons' from steal time reporting. 'Known reasons' being, for example,
> hard caps. So a vcpu executing instructions with no halt, but limited to
> 80% of available bandwidth, would not have 20% of stolen time reported.

Ok, that's a good explanation to add to make that subtle steal time
issue clearer.

>
> But yes, a description of the scenario that is being dealt with, with
> details, is important.

Yeah especially for such a significant user ABI change.

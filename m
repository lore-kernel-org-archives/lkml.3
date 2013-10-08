Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab3JHJdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 05:33:40 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:41907 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab3JHJdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 05:33:39 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-82-5253d17209f3
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/legacy_serial: fix incorrect placement of
 __initdata tag
Date: Tue, 08 Oct 2013 11:33:29 +0200
Message-id: <2241214.NPvmYhqHCQ@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <20131008035623.GA31666@concordia>
References: <35419229.o6Cv8JYbpg@amdc1032> <1600459.LJx7sBeEJs@amdc1032>
 <20131008035623.GA31666@concordia>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t9jQd2ii8FBBr/2s1t8aGpltjjb9Ibd
	4vKuOWwWv7//Y7W4PGklk8WaI4vZHdg8Fr1sYPHoedPC6nF+xkJGj7m7+hg9+rasYvT4vEku
	gC2KyyYlNSezLLVI3y6BK2PT1ZVMBTO5K/r6j7A0MH7n6GLk5JAQMJF4seoeG4QtJnHh3nog
	m4tDSGA6o8STE2eYIJwWJomGpm52kCo2ASuJie2rGEFsEQFdiXeXroJ1MAscYZS4++oo2Chh
	gXCJV69esIDYLAKqEte3HgZr5hXQlOj/Nx3MFhXwlPg0aSkziM0poC/xd9pTsHohgVyJc38O
	M0HUC0r8mHwPLM4sIC+xb/9UVghbS2L9zuNMExgFZiEpm4WkbBaSsgWMzKsYRVMLkguKk9Jz
	jfSKE3OLS/PS9ZLzczcxggP9mfQOxlUNFocYBTgYlXh4BQ4HBQmxJpYVV+YeYpTgYFYS4RUw
	Cg4S4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuw1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwLjA/6Zp
	+OvGiXNLr0qfMAzIevTiY73Lr8Y/fiqPlqz6fUdg00aeLoZph17WzZ1wM2FfeuvWlt//wy7I
	54SnXRPJLGC2tubY03Hic0fQk0zN17dOVX4J+RdgKbVC7edvBf+nkxavaY65aDT3eJnaUanS
	E813eYTC1/wUvLxa+L/O3w4XHU7NxZOVWIozEg21mIuKEwECUY1YcAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 08, 2013 02:56:23 PM Michael Ellerman wrote:
> On Thu, Oct 03, 2013 at 01:51:27PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Tuesday, October 01, 2013 04:13:25 PM Michael Ellerman wrote:
> > > On Mon, Sep 30, 2013 at 03:11:42PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > > > __initdata tag should be placed between the variable name and equal
> > > > sign for the variable to be placed in the intended .init.data section.
> > > 
> > > I see lots of other occurences of that in arch/powerpc. Why not send a
> > > single patch to update them all?
> > 
> > The other occurences while not following the preferred kernel coding style
> > are (probably) working OK with gcc. This particular occurence just doesn't
> > work as it should.
> 
> Why would the other occurrences work but not this one?

Because gcc seems to generate the correct code for things like i.e. this one:

struct of_device_id __initdata legacy_serial_parents[]

but not for ones like this:

struct __initdata of_device_id legacy_serial_parents[]

> Regardless, why don't we just do a single patch to clean them all up to
> match coding style and (probably) do what they're intended.

Because:

- fixing this occurence changes runtime, fixing others won't

- there were no such request from powerpc Maintainers

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics


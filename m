Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbaCGJxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 04:53:48 -0500
Received: from top.free-electrons.com ([176.31.233.9]:37458 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751648AbaCGJxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 04:53:44 -0500
Message-ID: <53199726.4080300@free-electrons.com>
Date: Fri, 07 Mar 2014 10:53:42 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Tawfik Bayouk <tawfik@marvell.com>, linux-kernel@vger.kernel.org,
        Nadav Haklai <nadavh@marvell.com>, Lior Amsalem <alior@marvell.com>,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH] ARM: mvebu: add Device Tree for the Armada 385 RD board
References: <1394107868-26094-1-git-send-email-gregory.clement@free-electrons.com> <20140306131429.GJ4780@lunn.ch> <5318779C.8030901@free-electrons.com> <20140306142117.GL4780@lunn.ch> <531886B4.2070002@free-electrons.com> <20140306144600.GM4780@lunn.ch> <53188B73.4000109@free-electrons.com> <53189892.5090502@free-electrons.com> <20140306160213.GA4327@arch.cereza> <20140306172339.GP4780@lunn.ch> <20140306191747.GA32655@arch.cereza>
In-Reply-To: <20140306191747.GA32655@arch.cereza>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2014 20:17, Ezequiel Garcia wrote:
> On Mar 06, Andrew Lunn wrote:
>>> Can't we fix this so the probe order doesn't affect the name?
>>>
>>> Is that sane?
>>
>> You are not supposed to trust the device name, since probing can
>> happen in parallel, on different buses. udev should have rules to name
>> the interfaces based on the MAC address. On my Debian system i have:
>>
>> /etc/udev/rules.d/70-persistent-net.rules
>>
>> So what is important is that the MAC addresses are assigned correctly
>> to the device. And DT does that based on MMIO address, so should be
>> reliable, independent of probe order.
>>

I was aware of this solution, and indeed for the end user it is the thing
to do.

However my concern was more about the people testing the kernel early or for
people bringing up a new board. I fear that we will have many false bug report
about it.

For the second category, I think we should at least point this in the dtsi.


Thanks,

Gregory


> 
> Right, makes perfect sense!
> 
> So we can just keep the nodes address-ordered, without caring about the name?
> 




-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com

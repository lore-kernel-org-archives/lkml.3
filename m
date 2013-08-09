Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967906Ab3HIPcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 11:32:50 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:51762 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964963Ab3HIPct convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 11:32:49 -0400
Subject: Re: [PATCH 3/5] omap: Properly handle resources for omap_devices
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <87mwoqao95.fsf@kernel.org>
Date: Fri, 9 Aug 2013 18:32:30 +0300
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        =?iso-8859-1?Q?Beno=EEt_Cousson?= <benoit.cousson@gmail.com>,
        Paul Walmsley <paul@pwsan.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sourav Poddar <sourav.poddar@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        Felipe Balbi <balbi@ti.com>, Koen Kooi <koen@circuitco.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <B929744A-C23A-41F6-A9AC-C18571A1F39B@antoniou-consulting.com>
References: <1375775624-12250-1-git-send-email-panto@antoniou-consulting.com> <1375775624-12250-4-git-send-email-panto@antoniou-consulting.com> <87a9kt2vd8.fsf@linaro.org> <A4346403-362E-4E74-9C5E-07509CBC0BF4@antoniou-consulting.com> <87mwoqao95.fsf@kernel.org>
To: Kevin Hilman <khilman@linaro.org>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
On Aug 9, 2013, at 6:16 PM, Kevin Hilman wrote:

> Pantelis Antoniou <panto@antoniou-consulting.com> writes:
> 
>> Hi Kevin,
>> 
>> On Aug 7, 2013, at 9:45 PM, Kevin Hilman wrote:
>> 
>>> [fixing address for Benoit]
>>> 
>>> Pantelis Antoniou <panto@antoniou-consulting.com> writes:
>>> 
>>>> omap_device relies on the platform notifier callbacks managing resources
>>>> behind the scenes. The resources were not properly linked causing crashes
>>>> when removing the device.
>>>> 
>>>> Rework the resource modification code so that linking is performed properly,
>>>> and make sure that no resources that have no parent (which can happen for DMA
>>>> & IRQ resources) are ever left for cleanup by the core resource layer.
>>>> 
>>>> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
>>> 
>>> This one failed my "took more than 15 minutes to understand" test.  The
>>> changelog is rather vague (especially about what "properly" means), and
>>> the combination of moving code and changing it makes the patch rather
>>> clunky to read, so I remain a bit confused about what the actual problem
>>> is.  Please elaborate.
>>> 
>>> Also, could you share a crash dump as well as details about how to
>>> reproduce this problem?
>>> 
>>> Thanks,
>>> 
>>> Kevin
>> 
>> It's the full patchset that fixes the problem:
>> 
>> Let me illustrate:
>> 
>> The kernel I use is located at:
>> 
>> git@github.com:pantoniou/linux-beagle-track-mainline.git
>> branch: merge-20130806 (there are topic branches for other stuff too)
> 
> Sorry, I don't have the time to go through a bunch of out of tree
> branches to figure this out.  Can you create a simpler test case to
> reproduce this?  e.g. Does this happen when building the serial driver
> as a module and then removing it?  If not, why not?

What 'bunch of out of tree branches'? There is a single merge branch against
current mainline. And no you don't trigger this by removing a module.

platform_driver_unregister() != platform_device_register().

I'll try to figure out something simpler, but it's pretty damn obvious that
something is not right there. Do you think fixing problems in that part
of platform device removal was something I did because I didn't have other
things to do?

It is broken and I'm trying to get it fixed. Are you?

> 
> Kevin

-- Pantelis


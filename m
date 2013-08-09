Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934378Ab3HIPQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 11:16:11 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:36670 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933972Ab3HIPQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 11:16:09 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <benoit.cousson@gmail.com>,
        Paul Walmsley <paul@pwsan.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sourav Poddar <sourav.poddar@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        Felipe Balbi <balbi@ti.com>, Koen Kooi <koen@circuitco.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] omap: Properly handle resources for omap_devices
References: <1375775624-12250-1-git-send-email-panto@antoniou-consulting.com>
	<1375775624-12250-4-git-send-email-panto@antoniou-consulting.com>
	<87a9kt2vd8.fsf@linaro.org>
	<A4346403-362E-4E74-9C5E-07509CBC0BF4@antoniou-consulting.com>
Date: Fri, 09 Aug 2013 08:16:06 -0700
In-Reply-To: <A4346403-362E-4E74-9C5E-07509CBC0BF4@antoniou-consulting.com>
	(Pantelis Antoniou's message of "Thu, 8 Aug 2013 12:23:42 +0300")
Message-ID: <87mwoqao95.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pantelis Antoniou <panto@antoniou-consulting.com> writes:

> Hi Kevin,
>
> On Aug 7, 2013, at 9:45 PM, Kevin Hilman wrote:
>
>> [fixing address for Benoit]
>> 
>> Pantelis Antoniou <panto@antoniou-consulting.com> writes:
>> 
>>> omap_device relies on the platform notifier callbacks managing resources
>>> behind the scenes. The resources were not properly linked causing crashes
>>> when removing the device.
>>> 
>>> Rework the resource modification code so that linking is performed properly,
>>> and make sure that no resources that have no parent (which can happen for DMA
>>> & IRQ resources) are ever left for cleanup by the core resource layer.
>>> 
>>> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
>> 
>> This one failed my "took more than 15 minutes to understand" test.  The
>> changelog is rather vague (especially about what "properly" means), and
>> the combination of moving code and changing it makes the patch rather
>> clunky to read, so I remain a bit confused about what the actual problem
>> is.  Please elaborate.
>> 
>> Also, could you share a crash dump as well as details about how to
>> reproduce this problem?
>> 
>> Thanks,
>> 
>> Kevin
>
> It's the full patchset that fixes the problem:
>
> Let me illustrate:
>
> The kernel I use is located at:
>
> git@github.com:pantoniou/linux-beagle-track-mainline.git
> branch: merge-20130806 (there are topic branches for other stuff too)

Sorry, I don't have the time to go through a bunch of out of tree
branches to figure this out.  Can you create a simpler test case to
reproduce this?  e.g. Does this happen when building the serial driver
as a module and then removing it?  If not, why not?

Kevin

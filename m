Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab3C2LVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 07:21:11 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47107 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754142Ab3C2LVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 07:21:09 -0400
X-Sasl-enc: zU9hVIq4O0jwwk9cM/jQUsr/nniPSkCzHK1hxbcFkg4f 1364556067
Message-ID: <515578D0.9090701@ladisch.de>
Date: Fri, 29 Mar 2013 12:19:44 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: Enable physical DMA above 4GB
References: <1364307734-27709-1-git-send-email-peter@hurleysoftware.com>	 <20130326195653.470b09d6@stein> <1364324929.3866.13.camel@thor.lan>	 <20130326213532.38a7bd4c@stein> <20130329114409.3634676e@stein> <1364554250.3559.61.camel@thor.lan>
In-Reply-To: <1364554250.3559.61.camel@thor.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Hurley wrote:
> On Fri, 2013-03-29 at 11:44 +0100, Stefan Richter wrote:
>>> On Mar 26 Peter Hurley wrote:
>>>> The FW643e-2 is natively PCIe (not behind a bridge) and supports phys
>>>> DMA past 4GB (the datasheet says all 48 bits but I can only test it out
>>>> to 10GB).
>>>>
>>>> I thought the FW643e was as well? You'll have to test that out :)
>>
>> Does lspci or something similar show which PCI devices are capable of 64 bit
>> wide addressing?
>
> Not definitively.
>
> Usually (but not always), if the host registers are 64-bit addressable,
> then the device supports DAC.

DACs are a feature of conventional PCI.

All PCI Express devices are 64-bit addressable.  In the lspci output, PCIe
devices have the "Express" capability.

However, whether a device can *generate* 64-bit DMA requests is completely
device-specific.


Regards,
Clemens

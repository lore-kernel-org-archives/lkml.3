Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab3KGHYD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 02:24:03 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:47638 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751929Ab3KGHXy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 02:23:54 -0500
Subject: Re: [PATCH 0/3 - V2] Introducing Device Tree Overlays
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20131106203102.GB8662@breakpoint.cc>
Date: Thu, 7 Nov 2013 09:23:45 +0200
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <94B1247B-32C1-49E7-AE33-67481007A7C0@antoniou-consulting.com>
References: <1383676898-29819-1-git-send-email-panto@antoniou-consulting.com> <20131106190152.GA8662@breakpoint.cc> <C10E33D7-53F6-4A50-9B84-1149DDBDC46F@antoniou-consulting.com> <20131106203102.GB8662@breakpoint.cc>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebestian,

On Nov 6, 2013, at 10:31 PM, Sebastian Andrzej Siewior wrote:

> On 06.11.13, Pantelis Antoniou wrote:
>> Hi Sebastian,
> Hi Pantelis,
> 
>> It has been discussed.
>> 
>> We are doing it because
>> 
>> a) We tried to do it in u-boot and it has been a complete disaster.
>> Regular users just can't handle bootloader updates.
> 
> How so? The "additional" dtb piece was deleted by accident as part of
> the u-boot upgrade? Do you maybe a link which describes the disaster?
> 

You're assuming that bootloaders are anything like u-boot or barebox.
In the field, especially on consumer products, bootloaders are custom one-off
jobs that don't do much besides handing control to the kernel as soon as possible.

Even when using u-boot, end users botch updates related to bootloader in
such a way that systems end up RMAed.

Ask Koen Kooi in the CClist about the messy details.

>> b) It is similar to that. It was originally created for the beaglebone,
>> which has a concept of capes (similar to Arduino shields).
>> http://circuitco.com/support/index.php?title=BeagleBone_Capes
>> Turns out it's really useful to anyone doing reconfigurable hardware too,
>> so that's why FPGA people are thinking of using it.
> 
> I am aware of this. My understanding is that those capes have hardware
> information encoded in an eeprom behind i2c _and_ you can't or should
> not replace capes at runtime.
> Naive as I am I *assume* it should be easy to read this eeprom in u-boot
> as part of the boot setup and extend the dtb before passing it to the
> kernel. In case this works well, the problem here is a) ?
> 

It is just better system design to have it all done in the kernel.
Other people in the list can chime in, but it's hard to get a feel of the
problem if you haven't dealt with it before.

>> c) There are people that want to tinker with Linux based hardware boards
>> but are not kernel developers. This gives them a way to do so without
>> having to recompile the kernel and/or reboot while tinkering.
> 
> I understand that they want to avoid reboot. But they still need to
> recompile the device tree, don't they? Or does this allow to change the
> HW description without knowing the syntax of .dts?
> 

They understand the syntax of the DTS (barely).
They can't hack compiling the kernel and updating it, not by a long shot.
Not everyone is a kernel hacker (neither it needs be).

Imagine people coming over from Arduino trying to hack a 4K board file to
add support for the thing they're working on.

>> Regards
>> 
>> -- Pantelis
> 
> Sebastian

Regards

-- Pantelis


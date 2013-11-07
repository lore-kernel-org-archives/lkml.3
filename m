Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab3KGJrI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 04:47:08 -0500
Received: from demumfd002.nsn-inter.net ([93.183.12.31]:11592 "EHLO
	demumfd002.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab3KGJrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 04:47:01 -0500
Message-ID: <527B6156.1080000@nsn.com>
Date: Thu, 07 Nov 2013 10:45:58 +0100
From: Alexander Sverdlin <alexander.sverdlin@nsn.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: ext Pantelis Antoniou <panto@antoniou-consulting.com>,
        Sebastian Andrzej Siewior <bigeasy@breakpoint.cc>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3 - V2] Introducing Device Tree Overlays
References: <1383676898-29819-1-git-send-email-panto@antoniou-consulting.com> <20131106190152.GA8662@breakpoint.cc> <C10E33D7-53F6-4A50-9B84-1149DDBDC46F@antoniou-consulting.com>
In-Reply-To: <C10E33D7-53F6-4A50-9B84-1149DDBDC46F@antoniou-consulting.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 1637
X-purgate-ID: 151667::1383817568-00005753-70980A87/0-0/0-0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On 06/11/13 20:08, ext Pantelis Antoniou wrote:
>>> The following patchset introduces Device Tree overlays, a method
>>> of dynamically altering the kernel's live Device Tree, along with
>>> a generic interface to use it in a board agnostic manner.
>>
>> In case this has been discussed and I missed it: Why are we doing this?
>> Isn't it possible to d o the overlay thingy in u-boot and pass a
>> complete device tree to the kernel?
>> Are you trying to do something like hotplug-PCI where the PCI card can
>> be replaced at runtime?
>>
> 
> It has been discussed.
> 
> We are doing it because
> 
> a) We tried to do it in u-boot and it has been a complete disaster.
> Regular users just can't handle bootloader updates.

There are buses we simply do not want to deal with in uboot, like SRIO, PCIe, everything-over-ethernet.
All of them are hot-pluggable. And yeah, device-tree processing in uboot is possible, but in Linux
it's way easier...
 
> b) It is similar to that. It was originally created for the beaglebone,
> which has a concept of capes (similar to Arduino shields).
> http://circuitco.com/support/index.php?title=BeagleBone_Capes
> Turns out it's really useful to anyone doing reconfigurable hardware too,
> so that's why FPGA people are thinking of using it.
> 
> c) There are people that want to tinker with Linux based hardware boards
> but are not kernel developers. This gives them a way to do so without
> having to recompile the kernel and/or reboot while tinkering.
>  
>> Sebastian
> 
> Regards
> 
> -- Pantelis
> 
> 
> 

-- 
Best regards,
Alexander Sverdlin.

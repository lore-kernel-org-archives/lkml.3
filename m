Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422631Ab3DEVAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 17:00:19 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:41013 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162169Ab3DEVAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 17:00:17 -0400
Message-ID: <515F3B4F.3070505@free-electrons.com>
Date: Fri, 05 Apr 2013 22:59:59 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Nicolas Pitre <nico@fluxnic.net>,
        Lior Amsalem <alior@marvell.com>, Maen Suleiman <maen@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v2 1/9] arm: mvebu: Limit the DMA zone when LPAE is selected
References: <1365193444-13441-1-git-send-email-gregory.clement@free-electrons.com> <1365193444-13441-2-git-send-email-gregory.clement@free-electrons.com> <201304052241.14865.arnd@arndb.de>
In-Reply-To: <201304052241.14865.arnd@arndb.de>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2013 10:41 PM, Arnd Bergmann wrote:
> On Friday 05 April 2013, Gregory CLEMENT wrote:
>> When LPAE is activated on Armada XP, all registers and IOs are still
>> 32bit, the 40bit extension is on the CPU to DRAM path (windows) only.
>> That means that all the DMA transfer are restricted to the low 32 bits
>> address space. This is limitation is achieved by selecting ZONE_DMA.
>>
>> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> 
> 
> Shouldn't that be ZONE_DMA32?
> 

Well common code for ARM don't manage the ZONE_DMA32. Whereas with
ZONE_DMA, setup_dma_zone() in arch/arm/mm/init.c does exactly what
I want: setting arm_dma_limit to 0xffffffff.

ZONE_DMA32 is used on arm64 however.

> 	Arnd
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com

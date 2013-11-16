Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab3KPIXl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 03:23:41 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:50634 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab3KPIXd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 03:23:33 -0500
X-RZG-AUTH: :JGIXVUS7cutRB/49FwqZ7WcKdUCnXG6JabOfSXKWrat5hNPvzeGM
X-RZG-CLASS-ID: mo00
Subject: Re: [PATCH 3/3] misc: bmp085: Add missing platform data.
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <201311151459.00293.arnd@arndb.de>
Date: Sat, 16 Nov 2013 09:23:28 +0100
Cc: Marek Belisko <marek@goldelico.com>, gregkh@linuxfoundation.org,
        neilb@suse.de, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, rob@landley.net,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <CDF07AB2-12B3-4EE4-B1EB-B4F27901B7E0@goldelico.com>
References: <1384465609-26485-1-git-send-email-marek@goldelico.com> <1384465609-26485-4-git-send-email-marek@goldelico.com> <201311151459.00293.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am 15.11.2013 um 14:58 schrieb Arnd Bergmann:

> On Thursday 14 November 2013, Marek Belisko wrote:
>> DT bindings contains more parameters to set so add them to platform data also
>> to have possibility to use on arch where DT isn't available yet.
>> 
>> Signed-off-by: Marek Belisko <marek@goldelico.com>
> 
> Can you give an example of a platform that uses this chip and cannot
> yet use DT in the mainline kernel? 

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/arch/arm/boot/dts/omap3-gta04.dts

exists but is far from being complete, because the transition to DT is really complex.

We still need some (private) board file for 3.13 and hope to have everything ready
for 3.14. But that depends on speed of acceptance of other drivers because
all DT things are still constantly moving.

So we will have to mix DT+board file for a while.

> If it's only for out-of-tree platforms, I'd prefer to leave this
> patch out of tree as well and put the burden on whoever maintains
> a non-DT platform in a private kernel.
> 
> 
>> diff --git a/include/linux/i2c/bmp085.h b/include/linux/i2c/bmp085.h
>> index b66cb98..addb972 100644
>> --- a/include/linux/i2c/bmp085.h
>> +++ b/include/linux/i2c/bmp085.h
> 
> Shouldn't this be in include/linux/platform_data? 
> 
> 	Arnd

-- hns
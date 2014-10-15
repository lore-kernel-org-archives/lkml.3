Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbaJOCbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 22:31:13 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:43876 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951AbaJOCbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 22:31:11 -0400
X-IronPort-AV: E=Sophos;i="5.04,720,1406617200"; 
   d="scan'208";a="48460682"
Message-ID: <543DDC6D.8030701@broadcom.com>
Date: Tue, 14 Oct 2014 19:31:09 -0700
From: Scott Branden <sbranden@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Mauro Carvalho Chehab" <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, Jingoo Han <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>
Subject: Re: get_maintainers.pl doesn't actually get the real MAINTAINERS?
References: <543DD959.2060801@broadcom.com> <1413339973.7475.1.camel@perches.com>
In-Reply-To: <1413339973.7475.1.camel@perches.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-10-14 07:26 PM, Joe Perches wrote:
> On Tue, 2014-10-14 at 19:18 -0700, Scott Branden wrote:
>> Hello,
>>
>> I try running scripts/get_maintainers.pl but it doesn't seem to get the
>> real maintainers properly.  Please note this is run against the current
>> MAINTAINERS file.
>>
>> One Example:  I would expect drivers/mmc/host/sdhci-bcm2835.c to be
>> maintained by Stephen Warren based on drivers/*/*bcm2835* below.
>
> get_maintainers doesn't use * as a depth wildcard
>
> */ matches a single top level directory level
> */*/ matches one level below the top directory level.
>
>>    But
>> the get_maintainers.pl script does not seem to process the information
>> in such a way.  So what needs to be corrected - the script or the syntax
>> used in the MAINTAINERS file?
>>
>> BROADCOM BCM2835 ARM ARCHICTURE
>> M:	Stephen Warren <swarren@wwwdotorg.org>
>> L:	linux-rpi-kernel@lists.infradead.org (moderated for non-subscribers)
>> T:	git git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-rpi.git
>> S:	Maintained
>> F:	arch/arm/mach-bcm/board_bcm2835.c
>> F:	arch/arm/boot/dts/bcm2835*
>> F:	arch/arm/configs/bcm2835_defconfig
>> F:	drivers/*/*bcm2835*
>
> F:	drivers/*/*/*bmc2835*
Thanks for the explanation.  So somebody should really do the following 
to maintain any files no matter where they are located?
F:	*/*bcm2835*
F:	*/*/*bcm2835*
F:	*/*/*/*bcm2835*
F:	*/*/*/*/*bcm2835*
F:	*/*/*/*/*/*bcm2835*
F:	*/*/*/*/*/*/*bcm2835*
F:	*/*/*/*/*/*/*/*bcm2835*

Or, can a recursive option be added in the script?
>
>


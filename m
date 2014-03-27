Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbaC0Mqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 08:46:30 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:57479 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbaC0MqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 08:46:22 -0400
Message-ID: <53341D99.6070703@gmail.com>
Date: Thu, 27 Mar 2014 13:46:17 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
To: Andrew Lunn <andrew@lunn.ch>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: Tejun Heo <tj@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-ide@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ata: fix Marvell SATA driver dependencies
References: <1668037.2oe7J2B7N4@amdc1032> <20140327123823.GM25349@lunn.ch>
In-Reply-To: <20140327123823.GM25349@lunn.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2014 01:38 PM, Andrew Lunn wrote:
> On Thu, Mar 27, 2014 at 01:23:39PM +0100, Bartlomiej Zolnierkiewicz wrote:
>> Make sata_mv host driver depend on PCI || ARCH_DOVE || ARCH_KIRKWOOD ||
>> ARCH_MV78XX0 || ARCH_MVEBU || ARCH_ORION5X config options as Marvell
>> SATA support covers both Marvell PCI devices and Marvell Dove, Kirkwood,
>> MV78xx0, Armada 370/XP and Orion5x SoCs (for non-PCI devices the driver
>> to work requires suitable device tree node to be defined).
>
> Good old fashioned platform driver will also work. In fact, 95% of Orion5x
> and mv78xx0 devices don't have DT yet.
>
> You might also be able to simplify it to
>
> PCI || PLAT_ORION || COMPILE_TEST
>
> But i suggest you build test to make sure.

Please, don't do it. We are in the progress of getting rid of
PLAT_ORION. v3 is just fine, or keep at least ARCH_MVEBU:

PCI || PLAT_ORION || ARCH_MVEBU || COMPILE_TEST

Sebastian

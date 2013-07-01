Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab3GAJkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 05:40:14 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40301 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752776Ab3GAJkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 05:40:12 -0400
X-Sasl-enc: hGvUGA5bEfQBUlVWFGvYYx/IcMPdkj0nekhpAEtoTr1I 1372671611
Message-ID: <51D14E78.7040309@ladisch.de>
Date: Mon, 01 Jul 2013 11:40:08 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Bjarni Ingi Gislason <bjarniig@rhi.hi.is>
CC: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: 3.10.0-rc7: rtc_cmos.o: No linking because of missing CONFIG_HPET
References: <20130629204217.GA2589@rhi.hi.is> <51D14128.3040608@suse.cz>
In-Reply-To: <51D14128.3040608@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 29.6.2013 22:42, Bjarni Ingi Gislason wrote:
>>   The file "drivers/rtc/rtc_cmos.c" needs CONFIG_HPET to get linked.
>>
>> rtc-cmos.c:(.text+0x16f214): undefined reference to `hpet_rtc_interrupt'

CONFIG_HPET enables drivers/char/hpet.c and nothing else; it does not
affect the HPET RTC emulation.

You are probably searching for CONFIG_HPET_EMULATE_RTC.


Regards,
Clemens

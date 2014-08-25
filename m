Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbaHYE0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 00:26:19 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53633 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbaHYE0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 00:26:18 -0400
Date: Sun, 24 Aug 2014 21:26:14 -0700 (PDT)
Message-Id: <20140824.212614.2300459100680592586.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] r8152: firmware support
From: David Miller <davem@davemloft.net>
In-Reply-To: <0835B3720019904CB8F7AA43166CEEB2516177@RTITMBSV03.realtek.com.tw>
References: <1394712342-15778-16-Taiwan-albertk@realtek.com>
	<20140822.194111.760144805197214266.davem@davemloft.net>
	<0835B3720019904CB8F7AA43166CEEB2516177@RTITMBSV03.realtek.com.tw>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 24 Aug 2014 21:26:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Mon, 25 Aug 2014 03:43:04 +0000

>  From: David Miller [mailto:davem@davemloft.net] 
> [...]
>> You haven't told us why you need to do this.
>> 
>> These are just programming registers in the chip, and I see no reason
>> to not keep these in the driver with real code.
>> 
>> I'm not applying this series, you haven't explained what is happening
>> here and the reason for doing so.  Ironically, that's exactly what you
>> are supposed to provide in this 0/4 header email.
> 
> The nic has the MCU inside which is used to fix the PHY,
> MAC, and some behavior of the USB device. Each parts have
> different methods of updating the firmware by accessing the
> registers. The firmware files are used to deal with the
> processes, so I need some functions to parse the firmware
> files to update the fimrware code.

That still doesn't convince me.

The functions I see you removing are just programming a set of
registers in some way.

And the firmware that is replacing those functions is just going to be
causing the same register writes, just even more obfuscated than it is
now.

You should keep the C functions which document and show clearly what
is being programmed in each chip.

Don't hide register programming behind firmware files, please.

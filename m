Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345Ab3BGUFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 15:05:39 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53578 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758711Ab3BGUFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 15:05:37 -0500
Date: Thu, 07 Feb 2013 15:05:35 -0500 (EST)
Message-Id: <20130207.150535.343442812598571927.davem@davemloft.net>
To: bhutchings@solarflare.com
Cc: freddy@asix.com.tw, netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH, resubmit] ax88179_178a: ASIX AX88179_178A USB 3.0/2.0
 to gigabit ethernet adapter driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1360267375.3605.32.camel@bwh-desktop.uk.solarflarecom.com>
References: <1360244360-2700-1-git-send-email-freddy@asix.com.tw>
	<1360267375.3605.32.camel@bwh-desktop.uk.solarflarecom.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>
Date: Thu, 7 Feb 2013 20:02:55 +0000

> On Thu, 2013-02-07 at 21:39 +0800, Freddy Xin wrote:
>> From: Freddy Xin <freddy@asix.com.tw>
>> 
>> This is a resubmission.
>> Added "const" to ethtool_ops structure and fixed the coding style of AX88179_BULKIN_SIZE array.
>> Fixed the issue that the default MTU is not 1500.
>> Added ax88179_change_mtu function and enabled the hardware jumbo frame function to support an
>> MTU higher than 1500.
>> Fixed indentation and empty line coding style errors.
>> The _nopm version usb functions were added to access register in suspend and resume functions.
>> Serveral variables allocted dynamically were removed and replaced by stack variables.
>> ax88179_get_eeprom were modified from asix_get_eeprom in asix_common.
>> 
>> This patch adds a driver for ASIX's AX88179 family of USB 3.0/2.0
>> to gigabit ethernet adapters. It's based on the AX88xxx driver but
>> the usb commands used to access registers for AX88179 are completely different.
>> This driver had been verified on x86 system with AX88179/AX88178A and
>> Sitcomm LN-032 USB dongles.
>> 
>> Signed-off-by: Freddy Xin <freddy@asix.com.tw>
> [...]
>> --- /dev/null
>> +++ b/drivers/net/usb/ax88179_178a.c
> [...]
>> +struct ax88179_data {
>> +       u16 rxctl;
>> +};
> 
> Should also be declared __packed, as on some architectures it may be
> padded to 4 bytes.

Packed is evil and should be avoid everywhere that it is possible to
do so.  It's going to use byte loads on this u16 on RISC cpus simply
because __packed makes it so that the compiler cannot assume data
alignment any longer.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973Ab3LITWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 14:22:53 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:51370 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632Ab3LITWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 14:22:47 -0500
MIME-Version: 1.0
In-Reply-To: <1386615608.1752.4.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
References: <1386614601-9453-1-git-send-email-natg@google.com>
	<1386615608.1752.4.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
Date: Mon, 9 Dec 2013 11:22:47 -0800
Message-ID: <CAGmqidkxoi9EEe0uC18QQUXwjFP1e_1MXL7VPk+NtU-Ta6FGUg@mail.gmail.com>
Subject: Re: [PATCH] net-tg3: Initialize REG_BASE_ADDR at PCI config offset
 120 to 0
From: Natarajan Gurumoorthy <natg@google.com>
To: Michael Chan <mchan@broadcom.com>
Cc: nsujir@broadcom.com, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael,
      We had crashes when the PCI config space got scanned via
/sys/devices/pcixxxx/....../config.

I agree that this fix will not help if the scan happens before the tg3
driver gets loaded.

Regards
Nat

On Mon, Dec 9, 2013 at 11:00 AM, Michael Chan <mchan@broadcom.com> wrote:
> On Mon, 2013-12-09 at 10:43 -0800, Nat Gurumoorthy wrote:
>> The new tg3 driver leaves REG_BASE_ADDR (PCI config offset 120)
>> uninitialized. From power on reset this register may have garbage in it. The
>> Register Base Address register defines the device local address of a
>> register. The data pointed to by this location is read or written using
>> the Register Data register (PCI config offset 128). When REG_BASE_ADDR has
>> garbage any read or write of Register Data Register (PCI 128) will cause the
>> PCI bus to lock up. The TCO watchdog will fire and bring down the system.
>>
>>
> Is this to prevent problem from other software that may be scanning the
> PCI config space?  It won't help if this happens before the tg3 driver
> is loaded, right?
>
> Thanks.
>



-- 
Regards
Nat Gurumoorthy AB6SJ

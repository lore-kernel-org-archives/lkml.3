Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab3LJSnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 13:43:50 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:51096 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab3LJSnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 13:43:45 -0500
Date: Tue, 10 Dec 2013 13:43:40 -0500 (EST)
Message-Id: <20131210.134340.114603867817512238.davem@davemloft.net>
To: mchan@broadcom.com
Cc: sergei.shtylyov@cogentembedded.com, natg@google.com, nsujir@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net-tg3: Initialize REG_BASE_ADDR at PCI config offset
 120 to 0
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386658724.1752.19.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
References: <52A633B4.9000307@cogentembedded.com>
	<1386623253.1752.6.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
	<1386658724.1752.19.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 10 Dec 2013 10:43:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Chan <mchan@broadcom.com>
Date: Mon, 9 Dec 2013 22:58:44 -0800

> On Mon, 2013-12-09 at 13:07 -0800, Michael Chan wrote: 
>> On Tue, 2013-12-10 at 00:18 +0300, Sergei Shtylyov wrote: 
>> > >        We had crashes when the PCI config space got scanned via
>> > > /sys/devices/pcixxxx/....../config.
>> > 
>> > > I agree that this fix will not help if the scan happens before the tg3
>> > > driver gets loaded.
>> > 
>> >     Then perhaps a better place for such fixup would be a PCI quirk?
>> > 
>> Yes, I agree.  Thanks.
>> 
> 
> On second thought, I think your original patch should be sufficient and
> we don't need to add the PCI quirk to cover so many devices.  The reason
> is that indirect access needs to be explicitly enabled in the
> MISC_HOST_CTRL (0x68) register.  The default value for register 0x68
> should have indirect access disabled.
> 
> Nat, does this match what you're seeing?  Did you ever see any system
> crash before tg3 loads?

What if the kernel is booted via kexec, and the driver in the kernel
we are kexec'ing from left indirect access enabled in MISC_HOST_CTRL?

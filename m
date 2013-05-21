Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733Ab3EUHNU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 03:13:20 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44638 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab3EUHNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 03:13:19 -0400
Date: Tue, 21 May 2013 00:13:15 -0700 (PDT)
Message-Id: <20130521.001315.148105250495357251.davem@davemloft.net>
To: thomas.petazzoni@free-electrons.com
Cc: libo.chen@huawei.com, gregkh@linuxfoundation.org, samuel@sortiz.org,
        stern@rowland.harvard.edu, khc@pm.waw.pl, akpm@linux-foundation.org,
        balbi@ti.com, sarah.a.sharp@linux.intel.com,
        alexander.shishkin@linux.intel.com, brudley@broadcom.com,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com
Subject: Re: [PATCH 00/19] driver:usb&net: add missing platform_driver owner
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130521084108.1a585f32@skate>
References: <1369104120-35552-1-git-send-email-libo.chen@huawei.com>
	<20130520.232619.964940909999914694.davem@davemloft.net>
	<20130521084108.1a585f32@skate>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 21 May 2013 00:13:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Date: Tue, 21 May 2013 08:41:08 +0200

> Dear David Miller,
> 
> On Mon, 20 May 2013 23:26:19 -0700 (PDT), David Miller wrote:
>> From: Libo Chen <libo.chen@huawei.com>
>> Date: Tue, 21 May 2013 10:42:00 +0800
>> 
>> > I find a lot of mistakes using struct platform_driver without owner.
>> > So I pick up some of them including usb and net modules
>> 
>> Instead of doing it this way, which is obviously error prone and
>> easy to forget, make platform_driver_register() be a macro which
>> sets the module owner field then calls the real
>> __platform_driver_register().
> 
> Or, maybe make the existing module_platform_driver() macro do this?

Even better.

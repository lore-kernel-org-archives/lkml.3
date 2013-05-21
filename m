Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab3EUG0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 02:26:23 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44221 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab3EUG0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 02:26:22 -0400
Date: Mon, 20 May 2013 23:26:19 -0700 (PDT)
Message-Id: <20130520.232619.964940909999914694.davem@davemloft.net>
To: libo.chen@huawei.com
Cc: gregkh@linuxfoundation.org, samuel@sortiz.org, stern@rowland.harvard.edu,
        khc@pm.waw.pl, akpm@linux-foundation.org, balbi@ti.com,
        sarah.a.sharp@linux.intel.com, alexander.shishkin@linux.intel.com,
        brudley@broadcom.com, thomas.petazzoni@free-electrons.com,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com
Subject: Re: [PATCH 00/19] driver:usb&net: add missing platform_driver owner
From: David Miller <davem@davemloft.net>
In-Reply-To: <1369104120-35552-1-git-send-email-libo.chen@huawei.com>
References: <1369104120-35552-1-git-send-email-libo.chen@huawei.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 20 May 2013 23:26:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Libo Chen <libo.chen@huawei.com>
Date: Tue, 21 May 2013 10:42:00 +0800

> I find a lot of mistakes using struct platform_driver without owner.
> So I pick up some of them including usb and net modules

Instead of doing it this way, which is obviously error prone and
easy to forget, make platform_driver_register() be a macro which
sets the module owner field then calls the real __platform_driver_register().

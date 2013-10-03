Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab3JCT3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 15:29:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38176 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988Ab3JCT3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 15:29:09 -0400
Date: Thu, 03 Oct 2013 15:29:07 -0400 (EDT)
Message-Id: <20131003.152907.2144013596237714581.davem@davemloft.net>
To: hns@goldelico.com
Cc: j.dumon@option.com, marek.belisko@gmail.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] hso: fix problem with wrong status code sent by
 OPTION GTM601 during RING indication
From: David Miller <davem@davemloft.net>
In-Reply-To: <B1808224-5850-41E3-9A8F-0F350F84FF89@goldelico.com>
References: <B1808224-5850-41E3-9A8F-0F350F84FF89@goldelico.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 03 Oct 2013 12:29:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Date: Wed, 2 Oct 2013 09:00:18 +0200

> From f5c7e15b61f2ce4fe3105ff914f6bfaf5d74af0d Mon Sep 17 00:00:00 2001
> From: "H. Nikolaus Schaller" <hns@goldelico.com>
> Date: Thu, 15 Nov 2012 14:40:57 +0100
> Subject: [PATCH 1/1] hso: fix problem with wrong status code sent by OPTION
>  GTM601 during RING indication
> 
>  It has been observed that the GTM601 with 1.7 firmware sometimes sends a value
>  wIndex that has bit 0x04 set instead of being reset as the code expects. So we
>  mask it for the error check.
>  
>  See http://lists.goldelico.com/pipermail/gta04-owner/2012-February/001643.html
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.de>

I think we should look more deeply into what this bit might mean
and why the firmware might be setting it before we even consider
applying a patch like this one.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab3JCUAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 16:00:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38683 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab3JCUAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 16:00:51 -0400
Date: Thu, 03 Oct 2013 16:00:49 -0400 (EDT)
Message-Id: <20131003.160049.199880461500344692.davem@davemloft.net>
To: hns@goldelico.com
Cc: j.dumon@option.com, marek.belisko@gmail.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] hso: fix problem with wrong status code sent by
 OPTION GTM601 during RING indication
From: David Miller <davem@davemloft.net>
In-Reply-To: <C7520082-95CC-4D4F-BCE4-96A7D6346DB3@goldelico.com>
References: <B1808224-5850-41E3-9A8F-0F350F84FF89@goldelico.com>
	<20131003.152907.2144013596237714581.davem@davemloft.net>
	<C7520082-95CC-4D4F-BCE4-96A7D6346DB3@goldelico.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 03 Oct 2013 13:00:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Date: Thu, 3 Oct 2013 21:40:34 +0200

> I have made the bug observation from debug log that this bit is set in a response
> each time the modem has a RING message. It might be specific to this modem
> and firmware version, i.e. a firmware bug. But we have no means to verify or even
> change it in the firmware.
> 
> I.e. the driver must handle it in a better way.
> 
> Because the notification is rejected by the driver, the driver will hang up and the
> whole modem connection breaks down.
> 
> With this patch, the problem was never observed again in ~2 years.
> 
> I'd hope the maintainer of this driver can shed some light on it.

I think if you suspect the bit is set in response to RING messages
then you should define a macro so that the number is not just magic,
and put a descriptrive comment above the macro definition for that
bit.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbaHGFgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 01:36:19 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46982 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757241AbaHGFgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 01:36:15 -0400
Date: Wed, 06 Aug 2014 22:36:11 -0700 (PDT)
Message-Id: <20140806.223611.1134627526934618200.davem@davemloft.net>
To: xerofoiify@gmail.com
Cc: petkan@nucleusys.com, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtl8150: Check if RSR is already defined
From: David Miller <davem@davemloft.net>
In-Reply-To: <1407389095-31426-1-git-send-email-xerofoiify@gmail.com>
References: <1407389095-31426-1-git-send-email-xerofoiify@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Aug 2014 22:36:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Krause <xerofoiify@gmail.com>
Date: Thu,  7 Aug 2014 07:24:54 +0200

> I am getting the following warn
> 
> drivers/net/usb/rtl8150.c:30:0: warning: "RSR" redefined
> arch/xtensa/include/asm/processor.h:189:0: note: this is the location of the previous definition
> 
> I wanted to remove RSR as it is not being used but it is not clear if being used
> for documenting purpose. undefining should be enough.
> 
> Signed-off-by: Nick Krause <xerofoify@gmail.com>

This isn't the right way to fix this.

Rather, the thing to do is to give the macros in this driver an
appropriate prefix such as "RTL8150_" so that they don't collide
with things in the global namespace.

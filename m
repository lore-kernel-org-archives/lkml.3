Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358AbaJIOrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 10:47:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33765 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757287AbaJIOrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 10:47:08 -0400
Date: Thu, 9 Oct 2014 16:47:04 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: devicetree@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>, netdev@vger.kernel.org,
        Antoine =?UTF-8?B?VMOpbmFydA==?= 
	<antoine.tenart@free-electrons.com>,
        linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFT 0/8] Marvell PXA168 libphy handling and Berlin
 Ethernet
Message-ID: <20141009164704.7286fc3f@free-electrons.com>
In-Reply-To: <54369EAC.5040301@gmail.com>
References: <1412858346-11334-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<20141009163315.2a9e1806@free-electrons.com>
	<54369EAC.5040301@gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sebastian Hesselbarth,

On Thu, 09 Oct 2014 16:41:48 +0200, Sebastian Hesselbarth wrote:

> > Hum, in mvneta, we already disabled the automatic negotiation and use
> > libphy. What makes you think the current mvneta driver is wrong in this
> > respect?
> 
> I didn't check mvneta, but remember Ezequiel didn't clear all AN bits
> in the barebox driver (which is based on Linux mvneta). Just mentioned
> that I'll have a closer look at it.

Ah, ok.

> But I agree, regarding libphy support mvneta is probably the best
> already.

Well, I initially remember that the original driver coming from Marvell
was using the HW PHY stuff, and that I changed that because it would
not integrate well with the kernel libphy.

A drawback of this is that because the hardware has built-in PHY
polling which triggers a MAC interrupt when the PHY status changes, they
typically don't wire up the PHY interrupt. Therefore, since we're not
able to use the MAC interrupt for PHY event notifications, we rely on
software PHY polling, which means that link up / link down events take
a few seconds to be noticed by the kernel. Unfortunately, I don't think
the hardware allows to use the hardware PHY polling to get link changes
interrupt, but not let the hardware configure the PHY itself.

Best regards,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379Ab3JDGWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 02:22:42 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:48388 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab3JDGWk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 02:22:40 -0400
X-RZG-AUTH: :JGIXVUS7cutRB/49FwqZ7WcKdUCnXG6JabOfSXKWrat4gtPvyOmM
X-RZG-CLASS-ID: mo00
Subject: Re: [PATCH 1/1] hso: fix problem with wrong status code sent by OPTION GTM601 during RING indication
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20131003.160049.199880461500344692.davem@davemloft.net>
Date: Fri, 4 Oct 2013 08:22:37 +0200
Cc: j.dumon@option.com, marek.belisko@gmail.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <4893FFB3-2A82-4AD4-A6B6-20270798051F@goldelico.com>
References: <B1808224-5850-41E3-9A8F-0F350F84FF89@goldelico.com> <20131003.152907.2144013596237714581.davem@davemloft.net> <C7520082-95CC-4D4F-BCE4-96A7D6346DB3@goldelico.com> <20131003.160049.199880461500344692.davem@davemloft.net>
To: David Miller <davem@davemloft.net>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am 03.10.2013 um 22:00 schrieb David Miller:

> From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
> Date: Thu, 3 Oct 2013 21:40:34 +0200
> 
>> I have made the bug observation from debug log that this bit is set in a response
>> each time the modem has a RING message. It might be specific to this modem
>> and firmware version, i.e. a firmware bug. But we have no means to verify or even
>> change it in the firmware.
>> 
>> I.e. the driver must handle it in a better way.
>> 
>> Because the notification is rejected by the driver, the driver will hang up and the
>> whole modem connection breaks down.
>> 
>> With this patch, the problem was never observed again in ~2 years.
>> 
>> I'd hope the maintainer of this driver can shed some light on it.
> 
> I think if you suspect the bit is set in response to RING messages
> then you should define a macro so that the number is not just magic,
> and put a descriptrive comment above the macro definition for that
> bit.

Good idea! I will resend the patch.

--- hns
Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab3JCTkj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 15:40:39 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:33112 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab3JCTki convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 15:40:38 -0400
X-RZG-AUTH: :JGIXVUS7cutRB/49FwqZ7WcKdUCnXG6JabOfSXKWrat4gtPrpw==
X-RZG-CLASS-ID: mo00
Subject: Re: [PATCH 1/1] hso: fix problem with wrong status code sent by OPTION GTM601 during RING indication
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20131003.152907.2144013596237714581.davem@davemloft.net>
Date: Thu, 3 Oct 2013 21:40:34 +0200
Cc: Jan Dumon <j.dumon@option.com>, Belisko Marek <marek.belisko@gmail.com>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <C7520082-95CC-4D4F-BCE4-96A7D6346DB3@goldelico.com>
References: <B1808224-5850-41E3-9A8F-0F350F84FF89@goldelico.com> <20131003.152907.2144013596237714581.davem@davemloft.net>
To: David Miller <davem@davemloft.net>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 03.10.2013 um 21:29 schrieb David Miller:

> From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
> Date: Wed, 2 Oct 2013 09:00:18 +0200
> 
>> From f5c7e15b61f2ce4fe3105ff914f6bfaf5d74af0d Mon Sep 17 00:00:00 2001
>> From: "H. Nikolaus Schaller" <hns@goldelico.com>
>> Date: Thu, 15 Nov 2012 14:40:57 +0100
>> Subject: [PATCH 1/1] hso: fix problem with wrong status code sent by OPTION
>> GTM601 during RING indication
>> 
>> It has been observed that the GTM601 with 1.7 firmware sometimes sends a value
>> wIndex that has bit 0x04 set instead of being reset as the code expects. So we
>> mask it for the error check.
>> 
>> See http://lists.goldelico.com/pipermail/gta04-owner/2012-February/001643.html
>> 
>> Signed-off-by: NeilBrown <neilb@suse.de>
>> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.de>
> 
> I think we should look more deeply into what this bit might mean
> and why the firmware might be setting it before we even consider
> applying a patch like this one.

Yes, that would be the right way.

The problem is that the firmware is a black box and the packet format has no
(public) documentation (unless someone inside OPTION has access to it).

I have made the bug observation from debug log that this bit is set in a response
each time the modem has a RING message. It might be specific to this modem
and firmware version, i.e. a firmware bug. But we have no means to verify or even
change it in the firmware.

I.e. the driver must handle it in a better way.

Because the notification is rejected by the driver, the driver will hang up and the
whole modem connection breaks down.

With this patch, the problem was never observed again in ~2 years.

I'd hope the maintainer of this driver can shed some light on it.

BR,
Nikolaus Schaller


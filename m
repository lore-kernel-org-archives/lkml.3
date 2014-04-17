Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161551AbaDQAEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 20:04:41 -0400
Received: from p3plex2out04.prod.phx3.secureserver.net ([184.168.131.18]:37515
	"EHLO p3plex2out04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757110AbaDQAEh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 20:04:37 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Chase Southwood <chase.southwood@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2 v3] staging: comedi: addi_apci_1564: fixup and
 absorb apci1564_reset()
Thread-Topic: [PATCH 2/2 v3] staging: comedi: addi_apci_1564: fixup and
 absorb apci1564_reset()
Thread-Index: AQHPWcx5E3JVTEoAsUqndpNUltkYo5sU5PwwgAB6xAD//4tccA==
Date: Thu, 17 Apr 2014 00:04:36 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825E051E5@P3PWEX4MB008.ex4.secureserver.net>
References: <1397691269-24940-1-git-send-email-chase.southwood@yahoo.com>
 <DC148C5AA1CEBA4E87973D432B1C2D8825E05116@P3PWEX4MB008.ex4.secureserver.net>
 <1397692382.80906.YahooMailNeo@web164005.mail.gq1.yahoo.com>
In-Reply-To: <1397692382.80906.YahooMailNeo@web164005.mail.gq1.yahoo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 16, 2014 4:53 PM, Chase Southwood wrote:
>>On Wednesday, April 16, 2014 6:36 PM, Hartley Sweeten <HartleyS@visionengravers.com> wrote:
>>>On Wednesday, April 16, 2014 4:34 PM, Chase Southwood wrote:
>>>Move apci1564_reset() from hwdrv_apci1564.c to addi_apci_1564.c.  The
>>>function was very messy and failed to reset a couple registers, these
>>>issues were fixed on the move.>
>>
>>The commit message needs updated. You are no longer moving the function.
>>
>
> Erm...in the PATCH v3 I just sent, it has been moved as described here, so at least for
> what is happening now, this changelog is accurate.  Would you like me to no longer move
> the function for the time being?

Ah, missed that you moved it before the struct addi_board definition.

Hmmm... I think it would be cleaner if you moved the function after separating
this driver from the addi_common.c file. Then the moved functions can be put
into the driver in "cleaner" locations and avoid any forward declaration junk.

The brute force way to do this is just copy the contents of addi_common.c to
the driver and remove the #include. Then you can move the functions from
the hwrdv_apci1564.c file to the driver, and remove them from the boardinfo,
as needed.

Once you get the addi_common.c stuff localized you should fine that much
of it is just NOP code for this driver. Those pieces then just need to be ripped
out.

Have fun...

Hartley


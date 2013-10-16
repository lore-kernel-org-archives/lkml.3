Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760525Ab3JPI6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 04:58:53 -0400
Received: from mx0.aculab.com ([213.249.233.131]:49613 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760370Ab3JPI6u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 04:58:50 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] X.25: Fix address field length calculation
Date: Wed, 16 Oct 2013 09:56:18 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B738F@saturn3.aculab.com>
In-Reply-To: <1381858190.22110.25.camel@joe-AO722>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] X.25: Fix address field length calculation
Thread-Index: Ac7Jy+/LVDapEAtzRVauANwyk+hG/gAgMioQ
References: <525D5131.9070007@datus.com> <1381858190.22110.25.camel@joe-AO722>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Joe Perches" <joe@perches.com>,
        =?Windows-1252?Q?Kelleter=2C=22_G=FCnther?= <GKelleter@datus.com>
Cc: <andrew.hendry@gmail.com>, <davem@davemloft.net>,
        <linux-x25@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2013-10-15 at 14:29 +0000, Kelleter, Günther wrote:
> > Addresses are BCD encoded, not ASCII. x25_addr_ntoa got it right.
> []
> > Wrong length calculation leads to rejection of CALL ACCEPT packets.
> []
> > diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
> []
> > @@ -98,7 +98,7 @@ int x25_parse_address_block(struct sk_buff *skb,
> >  	}
> >   	len = *skb->data;
> > -	needed = 1 + (len >> 4) + (len & 0x0f);
> > +	needed = 1 + ((len >> 4) + (len & 0x0f) + 1) / 2;
> 
> This calculation looks odd.

Looks correct to me...
In X.25 the lengths (in digits) of the called and calling addresses
are encoded in the high and low nibbles of one byte and then
followed by both addresses with a digit in each nibble.
If the length of the first address is odd, the second one
isn't byte aligned.

	David




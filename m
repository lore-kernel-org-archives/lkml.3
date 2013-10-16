Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760104Ab3JPG7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 02:59:00 -0400
Received: from mailrelay-out1.netcologne.de ([81.173.193.131]:3187 "EHLO
	mailrelay-out1.netcologne.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754149Ab3JPG65 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 02:58:57 -0400
From: =?iso-8859-1?Q?Kelleter=2C_G=FCnther?= <GKelleter@datus.com>
To: Joe Perches <joe@perches.com>
CC: "andrew.hendry@gmail.com" <andrew.hendry@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-x25@vger.kernel.org" <linux-x25@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] X.25: Fix address field length calculation
Thread-Topic: [PATCH] X.25: Fix address field length calculation
Thread-Index: AQHOybLnty+s/FnB5kKUVGTJOhUv65n142AAgADiAoA=
Date: Wed, 16 Oct 2013 06:58:46 +0000
Message-ID: <525E3925.7070105@datus.com>
References: <525D5131.9070007@datus.com>
 <1381858190.22110.25.camel@joe-AO722>
In-Reply-To: <1381858190.22110.25.camel@joe-AO722>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.52.21.9]
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <65BC7EDC9053D742822A7DCB7E3BEB4F@datus.local>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-purgate-ID: 153929::1381906734-000005E4-3B01FEDE/0-0/0-0
X-purgate: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 15.10.2013 19:29, schrieb Joe Perches:
> On Tue, 2013-10-15 at 14:29 +0000, Kelleter, Günther wrote:
>> Addresses are BCD encoded, not ASCII. x25_addr_ntoa got it right.
> []
>> Wrong length calculation leads to rejection of CALL ACCEPT packets.
> []
>> diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
> []
>> @@ -98,7 +98,7 @@ int x25_parse_address_block(struct sk_buff *skb,
>>  	}
>>   	len = *skb->data;
>> -	needed = 1 + (len >> 4) + (len & 0x0f);
>> +	needed = 1 + ((len >> 4) + (len & 0x0f) + 1) / 2;
> This calculation looks odd.
> Perhaps use bcd.h instead?
>

It's just the same calculation as in x25_add_ntoa (last line) and it's
used this way by x.25.
Two digits are encoded to one byte and the last byte is padded with 0 if
the total number of digits is odd.
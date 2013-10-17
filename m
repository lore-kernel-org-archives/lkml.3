Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab3JQLCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 07:02:17 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:56626 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab3JQLCP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 07:02:15 -0400
MIME-Version: 1.0
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B738F@saturn3.aculab.com>
References: <525D5131.9070007@datus.com>
	<1381858190.22110.25.camel@joe-AO722>
	<AE90C24D6B3A694183C094C60CF0A2F6026B738F@saturn3.aculab.com>
Date: Thu, 17 Oct 2013 22:02:13 +1100
Message-ID: <CADo0ohh7jZhc_WJFkrYYxoYza8ZeSEadzwgwabJWwQ1TucdCcg@mail.gmail.com>
Subject: Re: [PATCH] X.25: Fix address field length calculation
From: Andrew Hendry <andrew.hendry@gmail.com>
To: David Laight <David.Laight@aculab.com>
Cc: Joe Perches <joe@perches.com>,
        =?ISO-8859-1?Q?Kelleter=2C_G=FCnther?= <GKelleter@datus.com>,
        David Miller <davem@davemloft.net>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the previous html mail.
This appears to be correct, what length addresses are you getting back
in the call accept when this happens?

On Wed, Oct 16, 2013 at 7:56 PM, David Laight <David.Laight@aculab.com> wrote:
>> On Tue, 2013-10-15 at 14:29 +0000, Kelleter, Günther wrote:
>> > Addresses are BCD encoded, not ASCII. x25_addr_ntoa got it right.
>> []
>> > Wrong length calculation leads to rejection of CALL ACCEPT packets.
>> []
>> > diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
>> []
>> > @@ -98,7 +98,7 @@ int x25_parse_address_block(struct sk_buff *skb,
>> >     }
>> >     len = *skb->data;
>> > -   needed = 1 + (len >> 4) + (len & 0x0f);
>> > +   needed = 1 + ((len >> 4) + (len & 0x0f) + 1) / 2;
>>
>> This calculation looks odd.
>
> Looks correct to me...
> In X.25 the lengths (in digits) of the called and calling addresses
> are encoded in the high and low nibbles of one byte and then
> followed by both addresses with a digit in each nibble.
> If the length of the first address is odd, the second one
> isn't byte aligned.
>
>         David
>
>
>

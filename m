Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096Ab3HNQUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:20:53 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60775 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760023Ab3HNQUw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:20:52 -0400
Message-ID: <520BAE58.3060600@arm.com>
Date: Wed, 14 Aug 2013 17:20:40 +0100
From: Jonathan Austin <jonathan.austin@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcsOpIEhlbnRzY2hlbA==?= <nerv@dawncrow.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: arm: Only load TLS values when needed
References: <51E42E11.1010903@dawncrow.de> <51E5836B.1010904@arm.com> <51E59E8F.1060501@dawncrow.de> <51E67B98.9040101@arm.com> <51E6F532.1030004@dawncrow.de> <520B8F37.4040609@dawncrow.de>
In-Reply-To: <520B8F37.4040609@dawncrow.de>
X-OriginalArrivalTime: 14 Aug 2013 16:20:49.0266 (UTC) FILETIME=[3D031D20:01CE990A]
X-MC-Unique: 113081417205010201
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi André,

On 14/08/13 15:07, André Hentschel wrote:
> Hi Jonathan,
> Any updates on this?
>

I was holding out to see the version with ldrd at the top, as discussed 
below - I never saw a version with that change? I'd meant to ping you to 
see if that was coming, sorry.


[...]
>>> [...]
>>>>> Now we've only got one instruction between the store and the load
>>>>> and risk stalling the pipeline...
>>>>>
>>>>> Dave M cautiously says "The ancient advice was that one instruction
>>>>> was enough" but this is very core dependent... I wonder if anyone
>>>>> has a good idea about whether this is an issue here...?
>>>>
>>>> We could use a ldrd at the top, that'd be nearly what we have right
>>>> now, don't we?
>>>
>>> Yea, that'd be good - as far as I can see from an 1136 TRM, the ldrd *may* be two cycles (depending on alignment of the words) but the ldr and ldrne will always be two cycles. Ahhh, the joys of modifying the fast path ;)

Was expecting to see something that reflected this discussion,

Jonny


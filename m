Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967950Ab3E3IgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 04:36:18 -0400
Received: from intranet.asianux.com ([58.214.24.6]:20617 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967913Ab3E3IgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 04:36:10 -0400
X-Spam-Score: -100.8
Message-ID: <51A70916.40101@asianux.com>
Date: Thu, 30 May 2013 16:08:54 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andreas Schwab <schwab@linux-m68k.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] arch: m68k: math-emu: unsigned issue, 'unsigned long'
 will never be less than zero.
References: <51A6F0C6.9050806@asianux.com> <m2a9ndndu5.fsf@linux-m68k.org>
In-Reply-To: <m2a9ndndu5.fsf@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2013 03:09 PM, Andreas Schwab wrote:
> Chen Gang <gang.chen@asianux.com> writes:
> 
>> > 'oldmant.m32[1]' is 'unsigned long' which never '< 0', and the original
>> > author wanted to check the highest bit whether set.
>> >
>> > So need type cast form 'unsigned long' to 'long'.
> Better to make the bit test explicit, since it is not a sign bit.
> 

That sounds good.


>> > diff --git a/arch/m68k/math-emu/fp_arith.c b/arch/m68k/math-emu/fp_arith.c
>> > index 08f286d..ef013c5 100644
>> > --- a/arch/m68k/math-emu/fp_arith.c
>> > +++ b/arch/m68k/math-emu/fp_arith.c
>> > @@ -519,7 +519,7 @@ static void fp_roundint(struct fp_ext *dest, int mode)
>> >  				return;
>> >  			break;
>> >  		case 0x401e:
>> > -			if (!(oldmant.m32[1] >= 0))
>> > +			if (!((long)oldmant.m32[1] >= 0))
> 			if (oldmant.m32[1] & 0x80000000)

OK, I will send patch v2.


Thanks.
-- 
Chen Gang

Asianux Corporation

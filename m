Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaBCKZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 05:25:42 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:35629 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaBCKZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 05:25:41 -0500
Message-ID: <52EF6EA5.1050701@gmail.com>
Date: Mon, 03 Feb 2014 18:25:41 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>
CC: "'Dan Carpenter'" <dan.carpenter@oracle.com>,
        James Hogan <james.hogan@imgtec.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "andreas.dilger@intel.com" <andreas.dilger@intel.com>,
        Antonio Quartulli <antonio@meshcoding.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "bergwolf@gmail.com" <bergwolf@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "oleg.drokin@intel.com" <oleg.drokin@intel.com>,
        "jacques-charles.lafoucriere@cea.fr" 
	<jacques-charles.lafoucriere@cea.fr>,
        "jinshan.xiong@intel.com" <jinshan.xiong@intel.com>,
        netdev <netdev@vger.kernel.org>,
        "linux-metag@vger.kernel.org" <linux-metag@vger.kernel.org>
Subject: Re: [PATCH] drivers: staging: lustre: lustre: include: add "__attribute__((packed))"
 for the related union
References: <20140118142404.GT7444@mwanda> <52DBA3D4.3090308@gmail.com> <52DD0EFF.2010305@imgtec.com> <20140120123045.GV7444@mwanda> <52DD18A5.1090308@imgtec.com> <20140120125603.GD4815@mwanda> <20140120211356.GG4815@mwanda> <52DE4DA3.7090301@imgtec.com> <52E3A642.7010307@gmail.com> <52ECFD53.7010401@gmail.com> <20140203085855.GA26722@mwanda> <063D6719AE5E284EB5DD2968C1650D6D0F6B772B@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D0F6B772B@AcuExch.aculab.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2014 06:05 PM, David Laight wrote:
> From: Dan Carpenter
>> On Sat, Feb 01, 2014 at 09:57:39PM +0800, Chen Gang wrote:
>>> It seems, our kernel still stick to treate 'pack' region have effect
>>> with both 'align' and 'sizeof'.
>>
>> It's not about packed regions.  It's about unions.  It's saying the
>> sizeof() a union is a multiple of 4 unless it's packed.
>>
>> union foo {
>> 	short x;
>> 	short y;
>> };
>>
>> The author intended the sizeof(union foo) to be 2 but on metag arch then
>> it is 4.
> 
> The same is probably be true of: struct foo { _u16 bar; };
> 

I guess so.


> Architectures that define such alignment rules are a right PITA.

Sorry, I do not know about PITA (after google or wiki, I can not get
more related information).

Could you provide more information about PITA, thanks?


> You either need to get the size to 2 without using 'packed', or
> just not define such structures.

Excuse me, I don't quite understand your meaning. I guess your meaning
is:

  "normally, we should not use a struct/union like that, no matter what it is (2 or 4)".

Is it correct.


> It is worth seeing if adding aligned(2) will change the size - I'm
> not sure.
> 

Yes, it will/should make sure that it must be 2.


Thanks.
-- 
Chen Gang

Open, share and attitude like air, water and life which God blessed

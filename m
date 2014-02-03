Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaBCKWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 05:22:18 -0500
Received: from multi.imgtec.com ([194.200.65.239]:11215 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbaBCKWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 05:22:16 -0500
Message-ID: <52EF6DCC.6040807@imgtec.com>
Date: Mon, 3 Feb 2014 10:22:04 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>
CC: "'Dan Carpenter'" <dan.carpenter@oracle.com>,
        Chen Gang <gang.chen.5i5j@gmail.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "andreas.dilger@intel.com" <andreas.dilger@intel.com>,
        Antonio Quartulli <antonio@meshcoding.com>,
        "Greg KH" <gregkh@linuxfoundation.org>,
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
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2014_02_03_10_22_05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/14 10:05, David Laight wrote:
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

Yes indeed.

> Architectures that define such alignment rules are a right PITA.
> You either need to get the size to 2 without using 'packed', or
> just not define such structures.
> It is worth seeing if adding aligned(2) will change the size - I'm
> not sure.

__aligned(2) alone doesn't seem to have any effect on sizeof() or
__alignof__() unless it is accompanied by __packed. x86_64 is similar in
that respect (it just packs sanely in the first place).

Combining __packed with __aligned(2) does the trick though (__packed
alone sets __aligned(1) which is obviously going to be suboptimal).

Cheers
James


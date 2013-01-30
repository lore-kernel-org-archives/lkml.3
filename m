Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab3A3Nz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 08:55:26 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:50137 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753598Ab3A3NzX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 08:55:23 -0500
Subject: Re: [PATCH] cpsw: Fix interrupt storm among other things
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <510925C5.2080601@ti.com>
Date: Wed, 30 Jan 2013 15:55:18 +0200
Cc: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "Porter, Matt" <mporter@ti.com>, "Maupin, Chase" <chase.maupin@ti.com>,
        "Kridner, Jason" <jdk@ti.com>, Tony Lindgren <tony@atomide.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <C6DFFB7E-2A5A-4A4A-ABAB-BF0C2739C44A@antoniou-consulting.com>
References: <1359378668-26536-1-git-send-email-panto@antoniou-consulting.com> <5107B650.5090901@ti.com> <3DE2C638-6AE8-4BC9-AD68-3AAA40CD6233@antoniou-consulting.com> <5108E1C6.9020201@ti.com> <0FB10FF4-6639-472E-943C-61CEDB0336E0@antoniou-consulting.com> <5108FC31.3000507@ti.com> <27A3106E-3FDB-43DB-AAC9-DC2DA768AF9E@antoniou-consulting.com> <B5906170F1614E41A8A28DE3B8D121433ED03FE1@DBDE01.ent.ti.com> <0422CC2C-3D0D-4BB5-A90D-D3D337E44DD0@antoniou-consulting.com> <B5906170F1614E41A8A28DE3B8D121433ED04134@DBDE01.ent.ti.com> <F3F6248B-4DF4-418E-AD1F-F41E14CC85B2@antoniou-consulting.com> <B5906170F1614E41A8A28DE3B8D121433ED041A8@DBDE01.ent.ti.com> <60C298DC-2DE8-4A44-B00C-E3B09ABE701E@antoniou-consulting.com> <510925C5.2080601@ti.com>
To: Mugunthan V N <mugunthanvnm@ti.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mugunthan,

On Jan 30, 2013, at 3:53 PM, Mugunthan V N wrote:

> On 1/30/2013 7:21 PM, Pantelis Antoniou wrote:
>> Hi Vaibhav,
>> 
>> On Jan 30, 2013, at 3:47 PM, Bedia, Vaibhav wrote:
>> 
>>> Hi Antoniou,
>>> 
>>> On Wed, Jan 30, 2013 at 19:07:19, Pantelis Antoniou wrote:
>>>> Hi Vaibhav,
>>>> 
>>>> On Jan 30, 2013, at 3:29 PM, Bedia, Vaibhav wrote:
>>>> 
>>>>> On Wed, Jan 30, 2013 at 18:14:30, Pantelis Antoniou wrote:
>>>>>> Hi Vaibhav,
>>>>>> 
>>>>>> On Jan 30, 2013, at 2:38 PM, Bedia, Vaibhav wrote:
>>>>>> 
>>>>>>> On Wed, Jan 30, 2013 at 16:38:50, Pantelis Antoniou wrote:
>>>>>>> [...]
>>>>>>>> TBH I haven't found a simple way to print out the silicon revision number.
>>>>>>>> Anyone on the list know a quick and dirty method?
>>>>>>>> 
>>>>>>> You can dump the DEVICE_ID register @ 0x44e10600.
>>>>>>> Bits 31:28 should be 0 for PG1.0 and 1 for PG2.0.
>>>>>>> 
>>>>>> Thanks this works perfectly:
>>>>>> 
>>>>>> original-bone:
>>>>>> root@beaglebone:~# devmem2 0x44e10600 w
>>>>>> Read at address  0x44E10600 (0xb6ff4600): 0x0B94402E
>>>>>> 
>>>>>> bone-black:
>>>>>> root@beaglebone:~# devmem2 0x44e10600 w
>>>>>> Read at address  0x44E10600 (0xb6fcc600): 0x1B94402E
>>>>>> 
>>>>> I just re-read the mail-chain and I am confused here.
>>>>> So the patch in question is meant for Bone-A4 which has
>>>>> PG1.0?
>>>>> 
>>>> It is a general bug fix. The problem was discovered only on
>>>> the bone black which has PG2.0 silicon. The driver has been
>>>> tested and it works on the original bone with PG1.0 as well.
>>>> 
>>> But Mugunthan mentioned that he doesn't see this on an EVM
>>> with PG2.0 silicon... is there any board dependency here?
>>> 
>> I don't know, but I doubt it. How about we wait for Mugunthan to
>> send us what are the DEVICE_ID contents for his board.
>> 
>>> Regards,
>>> Vaibhav
>> Regards
>> 
>> -- Pantelis
>> 
> This is the device ID which i have
> 
> [root@arago /]# devmem 0x44e10600
> 0x1B94402E
> 

No clue what's the difference of the black with the EVM, and why this happens.
The fix is valid anyway.

> Regards
> Mugunthan V N

Regards

-- Pantelis


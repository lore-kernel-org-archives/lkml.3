Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275AbaEVD3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 23:29:53 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55206 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaEVD3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 23:29:52 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <537D6F23.3010704@roeck-us.net>
Date: Wed, 21 May 2014 20:29:39 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kurt Garloff <garloff@suse.de>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] drivers/scsi/tmscsim.c: replace shift loop by ilog2
References: <20140520184809.56d3707440f64e2d9656e3c7@skynet.be>	 <1400605602.26709.11.camel@joe-AO725> <20140522002822.GA6446@roeck-us.net> <1400720632.11896.7.camel@joe-AO725>
In-Reply-To: <1400720632.11896.7.camel@joe-AO725>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2014 06:03 PM, Joe Perches wrote:
> On Wed, 2014-05-21 at 17:28 -0700, Guenter Roeck wrote:
>> On Tue, May 20, 2014 at 10:06:42AM -0700, Joe Perches wrote:
>>> On Tue, 2014-05-20 at 18:48 +0200, Fabian Frederick wrote:
>>>> Cc: Kurt Garloff <garloff@suse.de>
>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>> Signed-off-by: Fabian Frederick <fabf@skynet.be>
>>>> ---
>>>>   drivers/scsi/tmscsim.c | 2 +-
>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
>>> []
>>>> @@ -1611,7 +1611,7 @@ dc390_Reselect( struct dc390_acb* pACB )
>>>>         printk (KERN_ERR "DC390: Reselection must select host adapter: %02x!\n", lun);
>>>>       else
>>>>         lun ^= 1 << pACB->pScsiHost->this_id; /* Mask AdapterID */
>>>> -    id = 0; while (lun >>= 1) id++;
>>>> +    id = ilog2(lun);
>>>>       /* Get LUN */
>>>>       lun = DC390_read8 (ScsiFifo);
>>>>       if (!(lun & IDENTIFY_BASE)) printk (KERN_ERR "DC390: Resel: Expect identify message!\n");
>>>
>>> Hey Fabian.
>>>
>>> You've submitted several of these now.
>>>
>>> Have you gone through all of these to make sure
>>> that the ilog2(<foo>) uses are always using a
>>> non-zero <foo>?
>>>
>> Maybe I am missing something. Why not just use fls() ?
>
> fls strains Andrew Morton's brain.
>
> https://lkml.org/lkml/2014/5/19/771
>

:-).

On the other side fls(1) == 1 while ilog2(1) == 0. So some test is necessary anyway.

Guenter


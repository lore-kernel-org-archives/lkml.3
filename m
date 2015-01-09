Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282AbbAIVlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 16:41:17 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:54751 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbbAIVlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 16:41:13 -0500
Message-ID: <54B04A7C.4000301@vanguardiasur.com.ar>
Date: Fri, 09 Jan 2015 18:39:08 -0300
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Organization: VanguardiaSur
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] UBI: Fastmap: Ensure that all fastmap work is done
 upon WL shutdown
References: <1416835236-25185-1-git-send-email-richard@nod.at> <1416835236-25185-4-git-send-email-richard@nod.at> <54B048E4.3080102@vanguardiasur.com.ar> <54B04A34.7030008@nod.at>
In-Reply-To: <54B04A34.7030008@nod.at>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/09/2015 06:37 PM, Richard Weinberger wrote:
> Am 09.01.2015 um 22:32 schrieb Ezequiel Garcia:
>> On 11/24/2014 10:20 AM, Richard Weinberger wrote:
>>> ...otherwise the deferred work might run after datastructures
>>> got freed and corrupt memory.
>>>
>>> Signed-off-by: Richard Weinberger <richard@nod.at>
>>> ---
>>>  drivers/mtd/ubi/wl.c | 3 +++
>>>  1 file changed, 3 insertions(+)
>>>
>>> diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
>>> index 7f135df..cb2e571 100644
>>> --- a/drivers/mtd/ubi/wl.c
>>> +++ b/drivers/mtd/ubi/wl.c
>>> @@ -2041,6 +2041,9 @@ static void protection_queue_destroy(struct ubi_device *ubi)
>>>  void ubi_wl_close(struct ubi_device *ubi)
>>>  {
>>>  	dbg_wl("close the WL sub-system");
>>> +#ifdef CONFIG_MTD_UBI_FASTMAP
>>> +	flush_work(&ubi->fm_work);
>>> +#endif
>>>  	shutdown_work(ubi);
>>>  	protection_queue_destroy(ubi);
>>>  	tree_destroy(&ubi->used);
>>>
>>
>> IMHO, it's best to avoid nasty ifdefs like this (there are lots of ways
>> of getting it cleaner). But I guess it's not a big deal.
> 
> I agree that's why I've cleaned up the vast majority of all ifdefs in a later cleanup
> commit. My original plan was to have first pure bug fixes and then cleanups to make
> backporting of my patches easy.
> 

Ah, yes, backporting is a good point.
-- 
Ezequiel Garcia, VanguardiaSur
www.vanguardiasur.com.ar

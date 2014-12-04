Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422AbaLDRV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 12:21:58 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932182AbaLDRV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 12:21:57 -0500
Message-ID: <54809831.1060503@nod.at>
Date: Thu, 04 Dec 2014 18:21:53 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Tanya Brokhman <tlinder@codeaurora.org>, dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] UBI: Fastmap: Ensure that all fastmap work is done
 upon WL shutdown
References: <1416835236-25185-1-git-send-email-richard@nod.at> <1416835236-25185-4-git-send-email-richard@nod.at> <1417102739.5858.112.camel@sauron.fi.intel.com> <54808F8B.6030807@codeaurora.org>
In-Reply-To: <54808F8B.6030807@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 04.12.2014 um 17:44 schrieb Tanya Brokhman:
> On 11/27/2014 5:38 PM, Artem Bityutskiy wrote:
>> On Mon, 2014-11-24 at 14:20 +0100, Richard Weinberger wrote:
>>> ...otherwise the deferred work might run after datastructures
>>> got freed and corrupt memory.
>>>
>>> Signed-off-by: Richard Weinberger <richard@nod.at>
>>> ---
>>>   drivers/mtd/ubi/wl.c | 3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
>>> index 7f135df..cb2e571 100644
>>> --- a/drivers/mtd/ubi/wl.c
>>> +++ b/drivers/mtd/ubi/wl.c
>>> @@ -2041,6 +2041,9 @@ static void protection_queue_destroy(struct ubi_device *ubi)
>>>   void ubi_wl_close(struct ubi_device *ubi)
>>>   {
>>>       dbg_wl("close the WL sub-system");
>>> +#ifdef CONFIG_MTD_UBI_FASTMAP
>>> +    flush_work(&ubi->fm_work);
>>> +#endif
>>
>> If you are using the work infrastructure implemented in wl.c, then
>> fastmap work should be no different to any other work. And we do flush
>> all works in 'shutdown_work()'. The fastmap work should be flushed there
>> too.
> 
> I tend to agree with Artem. Could you please move it to shutdown_work()? I'm asking because I do want to pick up all the bug fixes patches, but not going to pick up the "cleaning
> up" patches at this point.

Okay. You have overruled me. :-)

Thanks,
//richard


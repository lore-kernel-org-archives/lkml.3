Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbaKEPtI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:49:08 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755183AbaKEPtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:49:06 -0500
Message-ID: <545A46F0.7030805@nod.at>
Date: Wed, 05 Nov 2014 16:49:04 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tlinder@codeaurora.org
Subject: Re: [PATCH 06/35] UBI: Fastmap: Ensure that all fastmap work is done
 upon WL shutdown
References: <1414586758-9972-1-git-send-email-richard@nod.at>	 <1414586758-9972-7-git-send-email-richard@nod.at> <1415202307.958.125.camel@sauron.fi.intel.com>
In-Reply-To: <1415202307.958.125.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 05.11.2014 um 16:45 schrieb Artem Bityutskiy:
> On Wed, 2014-10-29 at 13:45 +0100, Richard Weinberger wrote:
>> ...otherwise the deferred work might run after datastructures
>> got freed and corrupt memory.
>>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
>> ---
>>  drivers/mtd/ubi/wl.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
>> index bd2e8d5..a06e31e 100644
>> --- a/drivers/mtd/ubi/wl.c
>> +++ b/drivers/mtd/ubi/wl.c
>> @@ -2047,6 +2047,9 @@ static void protection_queue_destroy(struct ubi_device *ubi)
>>  void ubi_wl_close(struct ubi_device *ubi)
>>  {
>>  	dbg_wl("close the WL sub-system");
>> +#ifdef CONFIG_MTD_UBI_FASTMAP
>> +	flush_work(&ubi->fm_work);
>> +#endif
> 
> I see in patch 35 you introduced the init function. Could you please
> introduce fastmap init/close functions earlier, and add this line to the
> fastmap close function instead of adding yet another ifdef to wl.c.

If you want I can rebase.
I did all fixes first and then the cleanups.

Thanks,
//richard

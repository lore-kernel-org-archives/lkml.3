Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab3IZHYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:24:36 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752894Ab3IZHYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:24:35 -0400
Message-ID: <5243E130.3040200@nod.at>
Date: Thu, 26 Sep 2013 09:24:32 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: dedekind1@gmail.com, dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] UBI: Fix error path in scan_pool()
References: <1380141125-11063-1-git-send-email-richard@nod.at> <5243E033.7010403@gmail.com>
In-Reply-To: <5243E033.7010403@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.09.2013 09:20, schrieb Richard Genoud:
> On 25/09/2013 22:32, Richard Weinberger wrote:
>> We have to set "ret", not "err" in case of an error.
>>
>> Reported-by: Richard Genoud <richard.genoud@gmail.com>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
>> ---
>>  drivers/mtd/ubi/fastmap.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
>> index f5aa4b0..9b42add 100644
>> --- a/drivers/mtd/ubi/fastmap.c
>> +++ b/drivers/mtd/ubi/fastmap.c
>> @@ -428,7 +428,7 @@ static int scan_pool(struct ubi_device *ubi, struct ubi_attach_info *ai,
>>  		if (be32_to_cpu(ech->image_seq) != ubi->image_seq) {
>>  			ubi_err("bad image seq: 0x%x, expected: 0x%x",
>>  				be32_to_cpu(ech->image_seq), ubi->image_seq);
>> -			err = UBI_BAD_FASTMAP;
>> +			ret = UBI_BAD_FASTMAP;
>>  			goto out;
>>  		}
>>  
>>
> 
> Tested-by: Richard Genoud <richard.genoud@gmail.com>
> 
> It reveals another bug though.
> 
> [    0.812500] UBI: default fastmap pool size: 95
> [    0.820312] UBI: default fastmap WL pool size: 25
> [    0.820312] UBI: attaching mtd2 to ubi0
> [    0.914062] UBI error: scan_pool: bad image seq: 0x0, expected: 0x352a9728

This worries me more...
The fastmap is corrupted, now we have to find out why.
Broken driver? Powercut? IO errors?

> [    0.921875] UBI error: ubi_scan_fastmap: Attach by fastmap failed, doing a full scan!
> [    0.929687] kmem_cache_destroy ubi_ainf_peb_slab: Slab cache still has objects

I see.

Thanks,
//richard

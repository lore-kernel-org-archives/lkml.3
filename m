Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbbASOxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 09:53:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56702 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbbASOxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 09:53:14 -0500
Message-ID: <54BD1A58.3000708@suse.de>
Date: Mon, 19 Jan 2015 15:53:12 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: fixup oops in ata_eh_link_report()
References: <1421668859-4593-1-git-send-email-hare@suse.de> <20150119143738.GA979@swordfish>
In-Reply-To: <20150119143738.GA979@swordfish>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2015 03:37 PM, Sergey Senozhatsky wrote:
> On (01/19/15 13:00), Hannes Reinecke wrote:
>> Date: Mon, 19 Jan 2015 13:00:59 +0100
>> From: Hannes Reinecke <hare@suse.de>
>> To: Tejun Heo <tj@kernel.org>
>> Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, Sergey
>>  Senozhatsky <sergey.senozhatsky@gmail.com>, Hannes Reinecke <hare@suse.de>
>> Subject: [PATCH] libata: fixup oops in ata_eh_link_report()
>> X-Mailer: git-send-email 1.8.5.2
>>
>> We should only try to evaluate the cdb if this is an ATAPI
>> device, for any other device the 'cdb' field and the cdb_len
>> has no meaning.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/ata/libata-eh.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
>> index 9179f11..584c6ae 100644
>> --- a/drivers/ata/libata-eh.c
>> +++ b/drivers/ata/libata-eh.c
>> @@ -2481,8 +2481,6 @@ static void ata_eh_link_report(struct ata_link *link)
>>  	for (tag = 0; tag < ATA_MAX_QUEUE; tag++) {
>>  		struct ata_queued_cmd *qc = __ata_qc_from_tag(ap, tag);
>>  		struct ata_taskfile *cmd = &qc->tf, *res = &qc->result_tf;
>> -		const u8 *cdb = qc->cdb;
>> -		size_t cdb_len = qc->dev->cdb_len;
>>  		char data_buf[20] = "";
>>  		char cdb_buf[70] = "";
>>  
>> @@ -2510,6 +2508,9 @@ static void ata_eh_link_report(struct ata_link *link)
>>  		}
>>  
>>  		if (ata_is_atapi(qc->tf.protocol)) {
>> +			const u8 *cdb = qc->cdb;
>> +			size_t cdb_len = qd->dev->cdb_len;
> 
> I think, it supposed to be qc, not qd.
> 
Bzzt.

Of course.

I'll be redoing the patch, and will be adding the original commit id
as indicated by Tejun.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396AbaHRFFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 01:05:41 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:52574 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaHRFFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 01:05:40 -0400
X-AuditID: 85900ec0-d452db9000001514-a4-53f189a1926f
Message-ID: <53F189A0.8090304@hitachi.com>
Date: Mon, 18 Aug 2014 14:05:36 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: emilne@redhat.com
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 03/10] scsi/constants: Cleanup printk message in __scsi_print_command()
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal>  <20140808115012.6768.44952.stgit@yuno-kbuild.novalocal> <1408115149.1223.145.camel@localhost.localdomain>
In-Reply-To: <1408115149.1223.145.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ewan,

Thank you for your review.

(2014/08/16 0:05), Ewan Milne wrote:
> On Fri, 2014-08-08 at 11:50 +0000, Yoshihiro YUNOMAE wrote:
>> All bytes in CDB should be output after linebuf is filled because
>> "[%s] CDB: %s\n" message is output many times in loop.
>>
>> Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
>> Cc: Hannes Reinecke <hare@suse.de>
>> Cc: Doug Gilbert <dgilbert@interlog.com>
>> Cc: Martin K. Petersen <martin.petersen@oracle.com>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
>> Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
>> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> ---
>>   drivers/scsi/constants.c |    3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
>> index 9c38b8d..5956d4d 100644
>> --- a/drivers/scsi/constants.c
>> +++ b/drivers/scsi/constants.c
>> @@ -413,9 +413,8 @@ void __scsi_print_command(struct scsi_device *sdev, const char *prefix,
>>
>>   		hex_dump_to_buffer(cdb + i, linelen, 16, 1,
>>   				   linebuf, sizeof(linebuf), false);
>> -		sdev_printk(KERN_INFO, sdev, "[%s] CDB: %s\n",
>> -			    prefix, linebuf);
>>   	}
>> +	sdev_printk(KERN_INFO, sdev, "[%s] CDB: %s\n", prefix, linebuf);
>>   }
>>   EXPORT_SYMBOL(__scsi_print_command);
>
> This doesn't look right -- In Hannes' tree what the code is doing is
> printing out a separate line for each 16 bytes of the CDB.  You change
> will cause only the last (partial?) 16 bytes to be printed.

Ah, that's true. We should not apply this patch.

Thanks,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com



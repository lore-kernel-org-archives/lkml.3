Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531AbaHMDOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 23:14:42 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:56117 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaHMDOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 23:14:40 -0400
X-AuditID: 85900ec0-d272ab9000001514-42-53ead81dbd26
Message-ID: <53EAD81D.9010609@hitachi.com>
Date: Wed, 13 Aug 2014 12:14:37 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Hannes Reinecke <hare@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 01/10] scsi/constants: Cleanup printk message in __scsi_print_sense()
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal> <20140808115006.6768.5118.stgit@yuno-kbuild.novalocal> <94D0CD8314A33A4D9D801C0FE68B402958BE5A76@G9W0745.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958BE5A76@G9W0745.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Elliot,

Thank you for your comment.

(2014/08/12 23:51), Elliott, Robert (Server Storage) wrote:
>
>
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>> owner@vger.kernel.org] On Behalf Of Yoshihiro YUNOMAE
>> Sent: Friday, 08 August, 2014 6:50 AM
> ...
>> Subject: [RFC PATCH 01/10] scsi/constants: Cleanup printk message in
>> __scsi_print_sense()
>>
>> A device name is output like "sda: Sense Key : Medium Error [current]"
>> in __scsi_print_sense(), but it should be "[sda] Sense Key : Medium Error
>> [current]" because other printk messages output a device name like "[sda]
>> foo."
>>
> ...
>> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
>> index c6a7a4a..a0e8159 100644
>> --- a/drivers/scsi/constants.c
>> +++ b/drivers/scsi/constants.c
>> @@ -1470,7 +1470,7 @@ void __scsi_print_sense(struct scsi_device *sdev,
>> const char *name,
>>   		return;
>>   	}
>>
>> -	sdev_printk(KERN_INFO, sdev, "%s: Sense Key : %s %s%s\n", name,
>> +	sdev_printk(KERN_INFO, sdev, "[%s] Sense Key : %s %s%s\n", name,
>>   	       scsi_sense_key_string(sshdr.sense_key),
>>   	       scsi_sense_type_string(&sshdr),
>>   	       scsi_sense_format_string(&sshdr));
>>
>
>
> The callers of __scsi_print_sense do not always pass in a name
> like "sda".  In fact, sd.c doesn't even call that function; its
> sd_print_sense_hdr calls sd_printk (which prints name as "[%s]")
> and scsi_show_sense_hdr.

OK, I understood.
Current Linux kernel also outputs "<name>:" in __scsi_print_sense(),
so we should not change this.

Thanks,
Yoshihiro YUNOMOAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com



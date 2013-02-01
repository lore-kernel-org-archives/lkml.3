Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab3BAJy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 04:54:57 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:33104 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756283Ab3BAJyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 04:54:54 -0500
Message-ID: <510B8F57.9070706@tao.ma>
Date: Fri, 01 Feb 2013 17:48:07 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jack Wang <jack_wang@usish.com>
CC: linux-scsi@vger.kernel.org, "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: How to online remove an error scsi disk from the system?
References: <510B5CFC.2040801@tao.ma> <008101ce0059$2a4976b0$7edc6410$@com> <510B8836.6090801@tao.ma> <008b01ce005d$ff8c8200$fea58600$@com>
In-Reply-To: <008b01ce005d$ff8c8200$fea58600$@com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 182.92.247.2 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2013 05:24 PM, Jack Wang wrote:
> 
> On 02/01/2013 04:50 PM, Jack Wang wrote:
>> Hi All,
>> 	In our product system, we have several sata disks attached to one 
>> machine. So when one of the disk fails, the jbd2(yes, we use ext4) 
>> will hang forever and we will get something in /var/log/messages like
> below.
>> It seems to me that the io sent to the scsi layer is never returned 
>> back with -EIO which is a little bit surprised for me(It should be a 
>> timeout somewhere, right?). We have tried echo "offline" > 
>> /sys/block/sdl/device/state, but it doesn't work. So is there any way 
>> for us to let the scsi device returns all the io requests back with 
>> EIO so that all the end_io can be called accordingly? Am I missing
> something here?
>>
>> Thanks,
>> Tao
>> [Jack Wang]
>> Hi Tao,
>>
>> Have you tried:
>>  echo 1 > /sys/block/sdv/device/delete
> It will do some IO first so it will hang doing IO.
>>  echo "- - -" > /sys/class/scsi_host/host
> What do you mean for this line?
> 
> [Jack Wang] Sorry I mean to let the driver rescan to get the disk back.
> The line should be :
>  echo "- - -" > /sys/class/scsi_host/hostx/scan.
> 
> Per above delete does not work , so no need to run this.
>>
>> another way is :
>> find out which phy the disk attached to and:
>> echo 1 > /sys/class/sas_phy/phy-x:x:x/link_reset
> sorry, I have done it, but there is no response.
> 
> [Jack Wang] 
> What about
> echo 1 > /sys/class/sas_phy/phy-x:x:x/hard_reset
sorry, no response either.

Thanks,
Tao
> 
> ?
> Thanks,
> Tao
>>
>> Jack
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-kernel" in the body of a message to majordomo@vger.kernel.org 
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


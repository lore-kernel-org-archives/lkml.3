Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab3IZEbu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 00:31:50 -0400
Received: from smtp.infotech.no ([82.134.31.41]:54475 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425Ab3IZEbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 00:31:49 -0400
Message-ID: <5243B89A.6060802@interlog.com>
Date: Thu, 26 Sep 2013 00:31:22 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: vaughan <vaughan.cao@oracle.com>, Vegard Nossum <vegard.nossum@oracle.com>
CC: James Bottomley <JBottomley@Parallels.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] sg: fix memory leak
References: <1380119219-13486-1-git-send-email-vegard.nossum@oracle.com> <5243967C.2010203@oracle.com>
In-Reply-To: <5243967C.2010203@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-09-25 10:05 PM, vaughan wrote:
> On 09/25/2013 10:26 PM, Vegard Nossum wrote:
>> Commit e32c9e6300e3af659cbfe45e90a1e7dcd3572ada introduced a memory
>> leak. Fix it.
>>
>> Cc: stable@vger.kernel.org
>> Cc: Vaughan Cao <vaughan.cao@oracle.com>
>> Cc: Douglas Gilbert <dgilbert@interlog.com>
>> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
>> ---
>>   drivers/scsi/sg.c |    1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
>> index 5cbc4bb..a97143f 100644
>> --- a/drivers/scsi/sg.c
>> +++ b/drivers/scsi/sg.c
>> @@ -2060,6 +2060,7 @@ sg_add_sfp(Sg_device * sdp, int dev)
>>   	spin_lock_irqsave(&sdp->sfd_lock, iflags);
>>   	if (sdp->detached) {
>>   		spin_unlock_irqrestore(&sdp->sfd_lock, iflags);
>> +		kfree(sfp);
>>   		return ERR_PTR(-ENODEV);
>>   	}
>>   	list_add_tail(&sfp->sfd_siblings, &sdp->sfds);
> You're right. It's a memory leak.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>


There also a memory leak at the second 'return NULL;'
in dev_seq_start() .


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab3FKBmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 21:42:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:7476 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754345Ab3FKBmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 21:42:35 -0400
X-IronPort-AV: E=Sophos;i="4.87,841,1363104000"; 
   d="scan'208";a="7517084"
Message-ID: <51B67FE4.4060103@cn.fujitsu.com>
Date: Tue, 11 Jun 2013 09:39:48 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Linux-Scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] scsi: Introduce a help function local_time_seconds()
 to simplify the getting time stamp operation
References: <51B53293.7090100@cn.fujitsu.com> <1370886422.1936.27.camel@dabdike>
In-Reply-To: <1370886422.1936.27.camel@dabdike>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/11 09:40:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/11 09:40:42,
	Serialize complete at 2013/06/11 09:40:42
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2013 01:47 AM, James Bottomley wrote:

> On Mon, 2013-06-10 at 09:57 +0800, Gu Zheng wrote:
>> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
>> index 66216c1..f3377ca 100644
>> --- a/include/scsi/scsi.h
>> +++ b/include/scsi/scsi.h
>> @@ -574,4 +574,13 @@ static inline __u32 scsi_to_u32(__u8 *ptr)
>>         return (ptr[0]<<24) + (ptr[1]<<16) + (ptr[2]<<8) + ptr[3];
>>  }
>>  
>> +/*
>> + * Convert system time in UTC to local time seconds.
>> + */
>> +static inline u32 local_time_seconds(void)
>> +{
>> +       struct timeval utc;
>> +       do_gettimeofday(&utc);
>> +       return (u32)(utc.tv_sec - (sys_tz.tz_minuteswest * 60));
>> +}
>>  #endif /* _SCSI_SCSI_H */
> 
> This doesn't belong in SCSI.
> 
> It's not a common pattern, so just leave it open coded in the 3ware
> drivers.  If there's a need for it to be a common pattern, John Stultz
> will add it to the timer code, but at the moment, he doesn't seem to see
> the need.

Hi James,
OK...Thanks for your reminder.
As you mentioned in an old thread, what about using "jiffies to seconds" to replace
the existed timestamps?

Best regards,
Gu



> 
> James
> 
> 
> 



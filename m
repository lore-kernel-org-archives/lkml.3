Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567AbaFYQIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 12:08:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756922AbaFYQIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 12:08:34 -0400
Message-ID: <53AAF3F0.3010700@redhat.com>
Date: Wed, 25 Jun 2014 18:08:16 +0200
From: Maurizio Lombardi <mlombard@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Purush Gupta <purush.gupta@nutanix.com>
CC: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        xjtuwjp@gmail.com, lindar_liu@usish.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org,
        Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: pm8001: pm80xx_hwi.c: Cleaning up variable is set
 more than once
References: <1403704907-25672-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <53AAEC1A.20905@redhat.com> <CAN7X1Un3-u-Q428-s1dYk5z4P-Bb=jO-N+x1T+PLhH1fDE1MRw@mail.gmail.com>
In-Reply-To: <CAN7X1Un3-u-Q428-s1dYk5z4P-Bb=jO-N+x1T+PLhH1fDE1MRw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 06/25/2014 05:41 PM, Purush Gupta wrote:
> Its possible HW may require programming those fields?

I'm looking at the code and it doesn't look so, did you see something suspicious?

> May be original
> contributor of the driver should review...No offense!

I believe it requires the maintainer ACK and it takes precedence in any case, am I wrong?

Regards,
Maurizio Lombardi

> 
> thanks,
> Purush
> 
> 
> On Wed, Jun 25, 2014 at 8:34 AM, Maurizio Lombardi <mlombard@redhat.com>
> wrote:
> 
>> This one looks good to me,
>>
>> Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>
>>
>> On 06/25/2014 04:01 PM, Rickard Strandqvist wrote:
>>> A struct member variable is set to different values without having used
>> in between.
>>>
>>> This was found using a static code analysis program called cppcheck
>>>
>>> Signed-off-by: Rickard Strandqvist <
>> rickard_strandqvist@spectrumdigital.se>
>>> ---
>>>  drivers/scsi/pm8001/pm80xx_hwi.c |    1 -
>>>  1 file changed, 1 deletion(-)
>>>
>>> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c
>> b/drivers/scsi/pm8001/pm80xx_hwi.c
>>> index d70587f..2698227 100644
>>> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
>>> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
>>> @@ -249,7 +249,6 @@ moreData:
>>>                               sprintf(pm8001_ha->
>>>                                       forensic_info.data_buf.direct_data,
>>>                                               "%08x ", 4);
>>> -                     pm8001_ha->forensic_info.data_buf.read_len =
>> 0xFFFFFFFF;
>>>                       pm8001_ha->forensic_info.data_buf.direct_len =  0;
>>>                       pm8001_ha->forensic_info.data_buf.direct_offset =
>> 0;
>>>                       pm8001_ha->forensic_info.data_buf.read_len = 0;
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 

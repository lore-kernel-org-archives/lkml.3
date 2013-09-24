Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab3IXRyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 13:54:25 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:58413 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499Ab3IXRyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 13:54:24 -0400
X-Greylist: delayed 1281 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Sep 2013 13:54:24 EDT
Message-ID: <5241C9E7.2000404@cs.wisc.edu>
Date: Tue, 24 Sep 2013 12:20:39 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.3
MIME-Version: 1.0
To: KY Srinivasan <kys@microsoft.com>
CC: Jack Wang <xjtuwjp@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: Drivers: scsi: FLUSH timeout
References: <1379705547-15028-1-git-send-email-kys@microsoft.com> <20130920203222.GA14306@kroah.com> <a97d266e2c284d688d2dd7ad43f179b8@SN2PR03MB061.namprd03.prod.outlook.com> <524180B7.7090307@gmail.com> <3413dbd7fa254fd380a84fe6d9cd87e1@SN2PR03MB061.namprd03.prod.outlook.com>
In-Reply-To: <3413dbd7fa254fd380a84fe6d9cd87e1@SN2PR03MB061.namprd03.prod.outlook.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 07:35 AM, KY Srinivasan wrote:
> 
> 
>> -----Original Message-----
>> From: Jack Wang [mailto:xjtuwjp@gmail.com]
>> Sent: Tuesday, September 24, 2013 5:08 AM
>> To: KY Srinivasan
>> Cc: Greg KH; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
>> ohering@suse.com; jbottomley@parallels.com; hch@infradead.org; linux-
>> scsi@vger.kernel.org; Mike Christie
>> Subject: Re: Drivers: scsi: FLUSH timeout
>>
>> On 09/21/2013 07:24 AM, KY Srinivasan wrote:
>>>
>>>
>>>> -----Original Message-----
>>>> From: Greg KH [mailto:gregkh@linuxfoundation.org]
>>>> Sent: Friday, September 20, 2013 1:32 PM
>>>> To: KY Srinivasan
>>>> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
>>>> ohering@suse.com; jbottomley@parallels.com; hch@infradead.org; linux-
>>>> scsi@vger.kernel.org
>>>> Subject: Re: Drivers: scsi: FLUSH timeout
>>>>
>>>> On Fri, Sep 20, 2013 at 12:32:27PM -0700, K. Y. Srinivasan wrote:
>>>>> The SD_FLUSH_TIMEOUT value is currently hardcoded.
>>>>
>>>> Hardcoded where?  Please, more context.
>>>
>>> This is defined in scsi/sd.h:
>>>
>>> #define SD_FLUSH_TIMEOUT        (60 * HZ)
>>>>
>>>>> On our cloud, we sometimes hit this timeout. I was wondering if we
>>>>> could make this a module parameter. If this is acceptable, I can send
>>>>> you a patch for this.
>>>>
>>>> A module parameter don't make sense for a per-device value, does it?
>>> Currently, the 60 second timeout is applied across devices. Ideally, I want to be
>>> able to control the FLUSH TIMEOUT as we currently do I/O timeout. If this is
>>> acceptable, I can work on a patch for that as well.
>>>
>>> Regards,
>>>
>>> K. Y
>>>>
>>>> greg k-h
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>> Hi,
>>
>> Back to 2010, Mike(cc-ed) try to add a flush time out interface, similar
>> to what you want here, no idea why it's just ignored?
>> http://www.spinics.net/lists/linux-scsi/msg45017.html
> 
> Thanks Jack. Mike, do you know what the concerns were as to why this
> patch was not accepted?
> 

I do not remember the exact concerns. We ended up just increasing the
hard coded value in:

commit e3b3e6246726cd05950677ed843010b8e8c5884c
Author: Mike Christie <mchristi@redhat.com>
Date:   Wed Aug 11 11:06:25 2010 -0500

    [SCSI] scsi/block: increase flush/sync timeout


In the git commit message there is a comment about people thinking
making it configurable for users was troublesome.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab3CFJRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 04:17:19 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:37412 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138Ab3CFJRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 04:17:13 -0500
X-IronPort-AV: E=Sophos;i="4.84,793,1355097600"; 
   d="scan'208";a="2224049"
Message-ID: <51370992.5090200@citrix.com>
Date: Wed, 6 Mar 2013 10:17:06 +0100
From: =?UTF-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130216 Thunderbird/17.0.3
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [PATCH RFC 04/12] xen-blkfront: pre-allocate pages for requests
References: <1362047335-26402-1-git-send-email-roger.pau@citrix.com> <1362047335-26402-5-git-send-email-roger.pau@citrix.com> <20130304193904.GI15386@phenom.dumpdata.com> <5135D149.1010805@citrix.com> <20130305141858.GG2589@phenom.dumpdata.com> <51361D89.2060604@citrix.com> <20130305215358.GA18408@phenom.dumpdata.com>
In-Reply-To: <20130305215358.GA18408@phenom.dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/13 22:53, Konrad Rzeszutek Wilk wrote:
>>>>>>  
>>>>>>  	/* No more gnttab callback work. */
>>>>>>  	gnttab_cancel_free_callback(&info->callback);
>>>>>> @@ -1088,6 +1120,12 @@ again:
>>>>>>  		goto destroy_blkring;
>>>>>>  	}
>>>>>>  
>>>>>> +	/* Allocate memory for grants */
>>>>>> +	err = fill_grant_buffer(info, BLK_RING_SIZE *
>>>>>> +	                              BLKIF_MAX_SEGMENTS_PER_REQUEST);
>>>>>> +	if (err)
>>>>>> +		goto out;
>>>>>
>>>>> That looks to be in the wrong function - talk_to_blkback function is
>>>>> to talk to the blkback. Not do initialization type operations.
>>>>
>>>> Yes, I know it's not the best place to place it. It's here mainly
>>>> because that's the only function that gets called by both driver
>>>> initialization and resume.
>>>>
>>>> Last patch moves this to a more sensible place.
>>>
>>> Lets make it part of this patch from the start. We still have two
>>> months of time before the next merge window opens - so we have
>>> time to make it nice and clean.
>>
>> I'm moving this to blkfront_setup_indirect in a later patch (because
>> this function doesn't yet exist at this point), but I can put it in a
>> more suitable place in this patch.
>>

I will place it in setup_blkring, which is the place where we also init
the sg array and it's called by both init and resume paths.

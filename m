Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab3ALCtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 21:49:17 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:40353 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069Ab3ALCtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 21:49:16 -0500
Message-ID: <50F0CF13.9000106@oracle.com>
Date: Sat, 12 Jan 2013 10:48:51 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Abhijit Pawar <abhi.c.pawar@gmail.com>, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH 1/1] fs/xfs remove obsolete simple_strto<foo>
References: <1357740282-2377-1-git-send-email-abhi.c.pawar@gmail.com> <50EFB2FE.2000307@oracle.com> <20130111225246.GO3120@dastard>
In-Reply-To: <20130111225246.GO3120@dastard>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2013 06:52 AM, Dave Chinner wrote:
> On Fri, Jan 11, 2013 at 02:36:46PM +0800, Jeff Liu wrote:
>> On 01/09/2013 10:04 PM, Abhijit Pawar wrote:
>>> This patch replaces usages of obsolete simple_strtoul with kstrtoint in xfs_args and suffix_strtoul.
>>>
>>> Signed-off-by: Abhijit Pawar <abhi.c.pawar@gmail.com>
>>> ---
>>> +			if (kstrtoint(value, 10, &dswidth))
>>> +				return EINVAL;
>>>  		} else if (!strcmp(this_char, MNTOPT_32BITINODE)) {
>>>  			mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
>>>  		} else if (!strcmp(this_char, MNTOPT_64BITINODE)) {
>>>
>> checkpatch.pl show warning if we return EINVAL as below:
>> WARNING: return of an errno should typically be -ve (return -EINVAL)
>>
>> Can we just ignore such code style issue?
> 
> Returning a positive error is not a code style issue. It's a
> correctness issue. the core of the XFS code returns positive error
> numbers as that's the way it was done on Irix (where the XFs code
> comes from). The rest of the Linux code tends to use negative values
> for error returns, and we've never converted the XFS code base to
> negative errors.
> 
> You should always feel free to ignore checkpatch warnings that make
> no sense. I haven't used checkpatch now for several years - I
> stopped using it when it got too noisy warning about uselesss,
> trivial things in the XFS code base....
Thanks for the clarification, that would save me time to handle
checkpatch warnings against XFS in the future. :)

Cheers,
-Jeff

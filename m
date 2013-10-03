Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab3JCO5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 10:57:15 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:39831 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511Ab3JCO5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 10:57:12 -0400
Message-ID: <524D85BA.9030603@oracle.com>
Date: Thu, 03 Oct 2013 08:56:58 -0600
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
CC: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [ 00/13] 3.0.99-stable review
References: <20131003040400.753642257@linuxfoundation.org> <524D0663.209@roeck-us.net> <1380801873@msgid.manchmal.in-ulm.de> <524D72A7.8030200@oracle.com> <1380810793@msgid.manchmal.in-ulm.de>
In-Reply-To: <1380810793@msgid.manchmal.in-ulm.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2013 08:41 AM, Christoph Biedl wrote:
> Khalid Aziz wrote...
>
>> Thanks for tracking this down. I had not tried a configuration with
>> CONFIG_HUGETLB_PAGE not set. In my config, I was getting many
>> multiple definition errors for bunch of other defines from
>> linux/hugetlb.h. I will look at my config again but chances are I
>> had something else screwed up in my build since you did not see
>> those errors. Did you compile with CONFIG_HUGETLB_PAGE set after
>> including linux/hugetlb.h? If you did, including linux/hugetlb.h
>> instead of importing just the definition of PageHuge in mm/swap.c
>> would be the right thing to do.
>
> Yes, one of my configurations has CONFIG_HUGETLB_PAGE, also
> CONFIG_NUMA=y, and the kernel built. Could not test it, though.
>
> There still might be other configuration settings that caused the
> error messages you've seen. Manually picking both PageHuge definitions
> from linux/hugetlb.h should be a safe alternative then, but that's
> ugly.
>
>      Christoph
>

Including linux/hugetlb.h is the right thing to do here. I cleaned up my 
build directories and started from scratch again. I tested with the old 
config where I had seen errors and I did not see errors again. I must 
have had something messed up in my old build directories.

Greg, please apply the patch Christoph had included in his earlier post.

Ben, this will apply to 3.2 as well.

Thanks,
Khalid

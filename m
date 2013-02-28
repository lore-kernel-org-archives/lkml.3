Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab3B1LZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 06:25:32 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:46246 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab3B1LZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 06:25:31 -0500
X-IronPort-AV: E=Sophos;i="4.84,755,1355097600"; 
   d="scan'208";a="2017938"
Message-ID: <512F3EA9.1070704@citrix.com>
Date: Thu, 28 Feb 2013 12:25:29 +0100
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130216 Thunderbird/17.0.3
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH RFC 00/12] xen-block: indirect descriptors
References: <1362047335-26402-1-git-send-email-roger.pau@citrix.com> <512F443702000078000C1DF7@nat28.tlf.novell.com>
In-Reply-To: <512F443702000078000C1DF7@nat28.tlf.novell.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/02/13 11:49, Jan Beulich wrote:
>>>> On 28.02.13 at 11:28, Roger Pau Monne <roger.pau@citrix.com> wrote:
>> This series contains the initial implementation of indirect 
>> descriptors for Linux blkback/blkfront.
>>
>> Patches 1, 2, 3, 4 and 5 are bug fixes and minor optimizations.
>>
>> Patch 6 contains a LRU implementation for blkback that will be needed 
>> when using indirect descriptors (since we are no longer able to map 
>> all possible grants blkfront might use).
> 
> Considering this, ...
> 
>> Patch 7 is an addition to the print stats function in blkback in order 
>> to print information regarding persistent grant usage.
>>
>> Patches 8, 9, 10 and 11 are preparatory work for indirect descriptors 
>> implementation, mainly make blkback use dynamic memory and remove the 
>> shared blkbk structure, so each blkback instance has it's own list of 
>> free requests, pages, handles and so on.
>>
>> Finally patch 12 contains the indirect descriptors implementation.
>>
>> I've also pushed this series to the following git repository:
>>
>> git://xenbits.xen.org/people/royger/linux.git xen-block-indirect
>>
>> Performance benefit of this series can be seen in the following graph:
>>
>> http://xenbits.xen.org/people/royger/plot_indirect.png 
> 
> ... would you happen to also have a comparison with using
> indirect descriptors but not persistent grants? IOW I'm
> wondering about the hit rate on the persistently mapped
> grants, especially when blkfront really saturates the added
> bandwidth.

This is the expanded graph that also contains indirect descriptors
without persistent grants:

http://xenbits.xen.org/people/royger/plot_indirect_nopers.png


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbaGONwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 09:52:55 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:49554 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbaGONwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 09:52:51 -0400
Message-ID: <53C53223.5040502@oracle.com>
Date: Tue, 15 Jul 2014 09:52:35 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
        David Rientjes <rientjes@google.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: fs: use after free in /proc/pid/mountinfo
References: <53B3F331.7090204@oracle.com>	<53B4CAB8.5070407@oracle.com>	<alpine.DEB.2.02.1407031434470.10658@chino.kir.corp.google.com>	<53B6C051.2060704@oracle.com>	<20140706100420.GB3589@osiris>	<20140709142406.GA27561@osiris>	<20140709133138.c523aa03883be5417a4d19a4@linux-foundation.org>	<53BDBDE7.8090600@oracle.com> <20140709155939.48b126f891132370532cb999@linux-foundation.org>
In-Reply-To: <20140709155939.48b126f891132370532cb999@linux-foundation.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2014 06:59 PM, Andrew Morton wrote:
> On Wed, 09 Jul 2014 18:10:47 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:
> 
>> On 07/09/2014 04:31 PM, Andrew Morton wrote:
>>> On Wed, 9 Jul 2014 16:24:06 +0200 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
>>>
>>>>> 058504edd026 ("fs/seq_file: fallback to vmalloc allocation") is suspected to
>>>>> cause a crash. Actually I can't reprocude the crash nor would I be able to
>>>>> tell how the commit could cause the crash.
>>>>> Anyway, I'll be offline for the next 2.5 weeks. So if Sasha could confirm
>>>>> that reverting the patch actually does fix the crash, please revert the
>>>>> commit, unless somebody else can make sense of the report of course.
>>>>>
>>>>> I'm still wondering how Sasha could reproduce the crash.
>>> This really sucks :(
>>>
>>> I suppose I'll queue up a revert of 058504edd026 as a for-3.16 bandaid.
>>>
>>> Sasha, it would be great if you could delve a bit further into this,
>>> see if we can identify a way for others to reproduce the bug.
>>>
>>> Did you test that little patchlet which Heiko sent?
>>
>> I've been trying, but as there isn't an easy way to reproduce it, breakage
>> elsewhere in -next (there is a long list) is slowing me down. I'll revert
>> back to the -next where I've initially observed this issue and will retry.
>>
> 
> Thanks.  The bug should be present in current mainline.
> 

I've been running mainline for a while, and while I can reproduce a different
bug for Hugh, I can't reproduce this one at all. Not sure how to call it now,
maybe memory corruption from somewhere else (I did find an unrelated memory
corruption couple days ago)?


Thanks,
Sasha

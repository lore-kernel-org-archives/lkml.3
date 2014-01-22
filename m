Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbaAVO67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 09:58:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755342AbaAVO65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 09:58:57 -0500
Message-ID: <52DFDCA6.1050204@redhat.com>
Date: Wed, 22 Jan 2014 09:58:46 -0500
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] really large storage sectors - going
 beyond 4096 bytes
References: <20131220093022.GV11295@suse.de> <52DF353D.6050300@redhat.com> <20140122093435.GS4963@suse.de> <52DFD168.8080001@redhat.com> <20140122143452.GW4963@suse.de>
In-Reply-To: <20140122143452.GW4963@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2014 09:34 AM, Mel Gorman wrote:
> On Wed, Jan 22, 2014 at 09:10:48AM -0500, Ric Wheeler wrote:
>> On 01/22/2014 04:34 AM, Mel Gorman wrote:
>>> On Tue, Jan 21, 2014 at 10:04:29PM -0500, Ric Wheeler wrote:
>>>> One topic that has been lurking forever at the edges is the current
>>>> 4k limitation for file system block sizes. Some devices in
>>>> production today and others coming soon have larger sectors and it
>>>> would be interesting to see if it is time to poke at this topic
>>>> again.
>>>>
>>> Large block support was proposed years ago by Christoph Lameter
>>> (http://lwn.net/Articles/232757/). I think I was just getting started
>>> in the community at the time so I do not recall any of the details. I do
>>> believe it motivated an alternative by Nick Piggin called fsblock though
>>> (http://lwn.net/Articles/321390/). At the very least it would be nice to
>>> know why neither were never merged for those of us that were not around
>>> at the time and who may not have the chance to dive through mailing list
>>> archives between now and March.
>>>
>>> FWIW, I would expect that a show-stopper for any proposal is requiring
>>> high-order allocations to succeed for the system to behave correctly.
>>>
>> I have a somewhat hazy memory of Andrew warning us that touching
>> this code takes us into dark and scary places.
>>
> That is a light summary. As Andrew tends to reject patches with poor
> documentation in case we forget the details in 6 months, I'm going to guess
> that he does not remember the details of a discussion from 7ish years ago.
> This is where Andrew swoops in with a dazzling display of his eidetic
> memory just to prove me wrong.
>
> Ric, are there any storage vendor that is pushing for this right now?
> Is someone working on this right now or planning to? If they are, have they
> looked into the history of fsblock (Nick) and large block support (Christoph)
> to see if they are candidates for forward porting or reimplementation?
> I ask because without that person there is a risk that the discussion
> will go as follows
>
> Topic leader: Does anyone have an objection to supporting larger block
> 	sizes than the page size?
> Room: Send patches and we'll talk.
>

I will have to see if I can get a storage vendor to make a public statement, but 
there are vendors hoping to see this land in Linux in the next few years. I 
assume that anyone with a shipping device will have to at least emulate the 4KB 
sector size for years to come, but that there might be a significant performance 
win for platforms that can do a larger block.

Note that windows seems to suffer from the exact same limitation, so we are not 
alone here with the vm page size/fs block size entanglement....

ric


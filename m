Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbbAHQ2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 11:28:43 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:35125 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbbAHQ2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 11:28:41 -0500
MIME-Version: 1.0
In-Reply-To: <20150106004714.6d63023c.akpm@linux-foundation.org>
References: <1414185652-28663-1-git-send-email-matthew.r.wilcox@intel.com>
	<20141210140347.GA23252@infradead.org>
	<20141210141211.GD2220@wil.cx>
	<20150105184143.GA665@infradead.org>
	<20150106004714.6d63023c.akpm@linux-foundation.org>
Date: Thu, 8 Jan 2015 11:28:40 -0500
Message-ID: <CANP1eJHOMSP8GYc_1pi8ciZZFWR0dH=N5a4HA=RYezohDmm+Rg@mail.gmail.com>
Subject: Re: [PATCH v12 00/20] DAX: Page cache bypass for filesystems on
 memory storage
From: Milosz Tanski <milosz@adfin.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 6, 2015 at 3:47 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 5 Jan 2015 10:41:43 -0800 Christoph Hellwig <hch@infradead.org> wrote:
>
>> On Wed, Dec 10, 2014 at 09:12:11AM -0500, Matthew Wilcox wrote:
>> > On Wed, Dec 10, 2014 at 06:03:47AM -0800, Christoph Hellwig wrote:
>> > > What is the status of this patch set?
>> >
>> > I have no outstanding bug reports against it.  Linus told me that he
>> > wants to see it come through Andrew's tree.  I have an email two weeks
>> > ago from Andrew saying that it's on his list.  I would love to see it
>> > merged since it's almost a year old at this point.
>>
>> And since then another month and aother merge window has passed.  Is
>> there any way to speed up merging big patch sets like this one?
>
> I took a look at dax last time and found it to be unreviewable due to
> lack of design description, objectives and code comments.  Hopefully
> that's been addressed - I should get back to it fairly soon as I chew
> through merge window and holiday backlog.
>
>> Another one is non-blocking read one that has real life use on one
>> of the biggest server side webapp frameworks but doesn't seem to make
>> progress, which is a bit frustrating.
>
> I took a look at pread2() as well and I have two main issues:
>
> - The patchset includes a pwrite2() syscall which has nothing to do
>   with nonblocking reads and which was poorly described and had little
>   justification for inclusion.
>
> - We've talked for years about implementing this via fincore+pread
>   and at least two fincore implementations are floating about.  Now
>   along comes pread2() which does it all in one hit.
>
>   Which approach is best?  I expect fincore+pread is simpler, more
>   flexible and more maintainable.  But pread2() will have lower CPU
>   consumption and lower average-case latency.
>
>   But how *much* better is pread2()?  I expect the difference will be
>   minor because these operations are associated with a great big
>   cache-stomping memcpy.  If the pread2() advantage is "insignificant
>   for real world workloads" then perhaps it isn't the best way to go.
>
>   I just don't know, and diligence requires that we answer the
>   question.  But all I've seen in response to these questions is
>   handwaving.  It would be a shame to make a mistake because nobody
>   found the time to perform the investigation.
>
> Also, integration of pread2() into xfstests is (or was) happening and
> the results of that aren't yet known.
>

Andrew I  got busier with my other job related things between the
Thanksgiving & Christmas then anticipated. However, I have updated and
taken apart the patchset into two pieces (preadv2 and pwritev2). That
should make evaluating the two separately easier. With the help of
Volker I hacked up preadv2 support into samba and I hopefully have
some numbers from it soon. Finally, I'm putting together a test case
for the typical webapp middle-tier service (epoll + threadpool for
diskio).

Haven't stopped, just progressing on that slower due to external factors.

P.S: Sorry for re-send. On the road and was using gmail to respond
with... it randomly forgets plain-text only settings.

-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com

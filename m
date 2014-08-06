Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbaHFGQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 02:16:21 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:57867 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbaHFGQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 02:16:20 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <53E1C7F5.7040901@lge.com>
Date: Wed, 06 Aug 2014 15:15:17 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>
CC: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-mm@kvack.org, Minchan Kim <minchan@kernel.org>,
        Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH 0/2] new API to allocate buffer-cache for superblock in
 non-movable area
References: <20140730101143.GB19205@quack.suse.cz> <53D985C0.3070300@lge.com> <20140731000355.GB25362@quack.suse.cz> <53D98FBB.6060700@lge.com> <20140731122114.GA5240@quack.suse.cz> <53DADA2F.1020404@lge.com> <53DAE820.7050508@lge.com> <20140801095700.GB27281@quack.suse.cz> <20140801133618.GJ19379@twins.programming.kicks-ass.net> <20140801152459.GA7525@quack.suse.cz> <20140801160415.GD9918@twins.programming.kicks-ass.net>
In-Reply-To: <20140801160415.GD9918@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



2014-08-02 오전 1:04, Peter Zijlstra 쓴 글:
> On Fri, Aug 01, 2014 at 05:24:59PM +0200, Jan Kara wrote:
>
>>    OK, makes sense. But then if there's heavy IO going on, anything that has
>> IO pending on it is pinned and IO completion can easily take something
>> close to a second or more. So meeting subsecond deadlines may be tough even
>> for ordinary data pages under heavy load, even more so for metadata where
>> there are further constraints. OTOH phones aren't usually IO bound so in
>> practice it needn't be so bad ;).
>
> Yeah, typically phones are not IO bound :-)
>
>> So if it is sub-second unless someone
>> loads the storage, then that sounds doable even for metadata. But we'll
>> need to attach ->migratepage callback to blkdev pages and at least in ext4
>> case teach it how to move pages tracked by the journal.
>
> Right, making it possible at all if of course much prefered over not
> possible, regardless of timeliness :-)
>
>>> Sadly its not only mobile devices that excel in crappy hardware, there's
>>> plenty desktop stuff that could use this too, like some of the v4l
>>> devices iirc.
>>    Yeah, but in such usecases the guarantees we can offer for completion of
>> migration are even more vague :(.
>
> Yeah, lets start by making it possible, after that we can maybe look at
> making it better, who knows.
>

Is my patch applicable? Or what do I have to do now?

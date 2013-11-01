Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab3KAVIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 17:08:00 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:34278 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab3KAVH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 17:07:59 -0400
Message-ID: <52741821.2070405@oracle.com>
Date: Fri, 01 Nov 2013 16:07:45 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>, Kent Overstreet <kmo@daterainc.com>
Subject: Re: linux-next: manual merge of the block tree with the  tree
References: <20131101142026.10390b6e3f70de348770c137@canb.auug.org.au>	<5273C473.5070803@kernel.dk> <20131102072252.88d2380fa392705b912dbfad@canb.auug.org.au> <52740EB1.2070901@kernel.dk> <527411DD.7050008@oracle.com> <527414DE.9090704@kernel.dk>
In-Reply-To: <527414DE.9090704@kernel.dk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2013 03:53 PM, Jens Axboe wrote:
> On 11/01/2013 02:41 PM, Dave Kleikamp wrote:
>> On 11/01/2013 03:27 PM, Jens Axboe wrote:
>>> On 11/01/2013 02:22 PM, Stephen Rothwell wrote:
>>>> Hi Jens,
>>>>
>>>> On Fri, 01 Nov 2013 09:10:43 -0600 Jens Axboe <axboe@kernel.dk> wrote:
>>>>>
>>>>> On 10/31/2013 09:20 PM, Stephen Rothwell wrote:
>>>>>>
>>>>>> Today's linux-next merge of the block tree got a conflict in
>>>>>> drivers/block/loop.c between commit 2486740b52fd ("loop: use aio to
>>>>>> perform io on the underlying file") from the aio-direct tree and commit
>>>>>> ed2d2f9a8265 ("block: Abstract out bvec iterator") from the block tree.
>>>>>>
>>>>>> I fixed it up (I think - see below - I have also attached the final
>>>>>> resulting file) and can carry the fix as necessary (no action is
>>>>>> required).
>>>>>>
>>>>>
>>>>> What tree is this from? It'd be a lot more convenient to fold that loop
>>>>> patch into my tree, especially since the block tree in linux-next failed
>>>>> after this merge.
>>>>
>>>> I can only agree with you.  It is from the aio-direct tree (probably
>>>> misnamed by me) (git://github.com/kleikamp/linux-shaggy.git#for-next) run
>>>> by Dave Kleikamp.
>>>
>>> Dave, input requested.
>>>
>>> In any case, I would suggest dropping the aio-direct tree instead of the
>>> entire block tree for coverage purposes, if merge or build failures
>>> happen because of it.
>>
>> I've had these patches in linux-next since August, and I'd really like
>> to push them in the 3.13 merge window.
>>
>> Are there other problems besides this merge issue? I'll take a closer
>> look at Stephen's merge patch and see if I find any other issues, but I
>> really don't want to pull these patches out of linux-next now.
> 
> I'm not saying that the patches should be dropped or not go into 3.13.
> What I'm saying is that if the choice is between having the bio and
> blk-mq stuff in linux-next or an addon to the loop driver, the decision
> should be quite clear.
> 
> So we've three immediate options:
> 
> 1) You base it on top of the block tree

I could do that.

> 2) I carry the loop updates

The patch is the 17th of the patch set and will break things without
most if not all of the preceding patches which hit a lot of fs code.

> 3) You hand Stephen a merge patch for the resulting merge of the two

I can do that too.

> It's one of the problems with too-many-tree, imho. You end up with
> dependencies that could have been solved if the work had been applied in
> the right upstream tree. Sometimes that's not even enough though, if you
> end up crossing boundaries.

This patch set does cross boundaries.

Dave

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab3H3ITt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 04:19:49 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:65525 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab3H3ITn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 04:19:43 -0400
Message-ID: <52205597.3090609@synopsys.com>
Date: Fri, 30 Aug 2013 13:49:35 +0530
From: Vineet Gupta <vineetg76@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: linus Torvalds <torvalds@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, Andi Kleen <andi@firstfloor.org>,
        Rik van Riel <riel@redhat.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Jonathan Gonzalez <jgonzalez@linets.cl>
Subject: Re: ipc-msg broken again on 3.11-rc7? (was Re: linux-next: Tree for
 Jun 21 [ BROKEN ipc/ipc-msg ])
References: <CA+icZUXuw7QBn4CPLLuiVUjHin0m6GRdbczGw=bZY+Z60sXNow@mail.gmail.com> <CA+icZUVbUD1tUa_ORtn_ZZebpp3gXXHGAcNe0NdYPXPMPoABuA@mail.gmail.com> <1372192414.1888.8.camel@buesod1.americas.hpqcorp.net> <CA+icZUXgOd=URJBH5MGAZKdvdkMpFt+5mRxtzuDzq_vFHpoc2A@mail.gmail.com> <1372202983.1888.22.camel@buesod1.americas.hpqcorp.net> <521DE5D7.4040305@synopsys.com> <CA+icZUUrZG8pYqKcHY3DcYAuuw=vbdUvs6ZXDq5meBMjj6suFg@mail.gmail.com> <C2D7FE5348E1B147BCA15975FBA23075140FA3@IN01WEMBXA.internal.synopsys.com> <CA+icZUUn-r8iq6TVMAKmgJpQm4FhOE4b4QN_Yy=1L=0Up=rkBA@mail.gmail.com>
In-Reply-To: <CA+icZUUn-r8iq6TVMAKmgJpQm4FhOE4b4QN_Yy=1L=0Up=rkBA@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping ?

It seems 3.11 is pretty close to releasing but we stil have LTP msgctl08 causing a
hang (atleast on ARC) for both linux-next 20130829 as well as Linus tree.

So far, I haven't seemed to have drawn attention of people involved.

-Vineet

On 08/29/2013 01:22 PM, Sedat Dilek wrote:
> On Thu, Aug 29, 2013 at 9:21 AM, Vineet Gupta
> <Vineet.Gupta1@synopsys.com> wrote:
>> On 08/29/2013 08:34 AM, Sedat Dilek wrote:
>>> On Wed, Aug 28, 2013 at 1:58 PM, Vineet Gupta
>>> <Vineet.Gupta1@synopsys.com> wrote:
>>>> Hi David,
>>>>

[....]

>>>> LTP msgctl08 hangs on 3.11-rc7 (ARC port) with some of my local changes. I
>>>> bisected it, sigh... didn't look at this thread earlier :-( and landed into this.
>>>>
>>>> ------------->8------------------------------------
>>>> 3dd1f784ed6603d7ab1043e51e6371235edf2313 is the first bad commit
>>>> commit 3dd1f784ed6603d7ab1043e51e6371235edf2313
>>>> Author: Davidlohr Bueso <davidlohr.bueso@hp.com>
>>>> Date:   Mon Jul 8 16:01:17 2013 -0700
>>>>
>>>>     ipc,msg: shorten critical region in msgsnd
>>>>
>>>>     do_msgsnd() is another function that does too many things with the ipc
>>>>     object lock acquired.  Take it only when needed when actually updating
>>>>     msq.
>>>> ------------->8------------------------------------
>>>>
>>>> If I revert 3dd1f784ed66 and 9ad66ae "ipc: remove unused functions" - the test
>>>> passes. I can confirm that linux-next also has the issue (didn't try the revert
>>>> there though).
>>>>
>>>> 1. arc 3.11-rc7 config attached (UP + PREEMPT)
>>>> 2. dmesg prints "msgmni has been set to 479"
>>>> 3. LTP output (this is slightly dated source, so prints might vary)
>>>>
>>>> ------------->8------------------------------------
>>>> <<<test_start>>>
>>>> tag=msgctl08 stime=1377689180
>>>> cmdline="msgctl08"
>>>> contacts=""
>>>> analysis=exit
>>>> initiation_status="ok"
>>>> <<<test_output>>>
>>>> ------------->8-------- hung here ------------------
>>>>
>>>>
>>>> Let me know if you need more data/test help.
>>>>
>>> Cannot say much to your constellation as I had the issue on x86-64 and
>>> Linux-next.
>>> But I have just seen a post-v3.11-rc7 IPC-fix in [1].
>>>
>>> I have here a v3.11-rc7 kernel with drm-intel-nightly on top... did not run LTP.
>>
>> Not sure what you mean - I'd posted that Im seeing the issue on ARC Linux (an FPGA
>> board) 3.11-rc7 as well as linux-next of yesterday.
>>
> 
> I am not saying there is no issue, but I have no possibility to test
> for ARC arch.
> 
>>> Which LTP release do you use?
>>
>> The LTP build I generally use is from a 2007 based sources (lazy me). However I
>> knew this would come up so before posting, I'd built the latest from buildroot and
>> ran the msgctl08 from there standalone and it did the same thing.
>>
> 
> Try always latest LTP-stable (03-May-2013 is what I tried). AFAICS a
> new release is planned soon.
> 
>>> Might be good to attach your kernel-config for followers?
>>
>> It was already there in my orig msg - you probably missed it.
>>
> 
> I have got that response from you only :-).
> 
>>> [1] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=368ae537e056acd3f751fa276f48423f06803922
>>
>> I tried linux-next of today, same deal - msgctl08 still hangs.
>>
> 
> That above fix [1] in Linus-tree is also in next-20130828.
> 
> Hope Davidlohr and fellows can help you.
> 
> - Sedat -
> 


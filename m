Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbaFCFbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 01:31:19 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:49167 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaFCFbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 01:31:17 -0400
Message-ID: <538D5D78.6040102@ontolinux.com>
Date: Tue, 03 Jun 2014 07:30:32 +0200
From: Christian Stroetmann <stroetmann@ontolinux.com>
User-Agent: Mozilla/5.0 (Windows NT 5.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Daniel Phillips <daniel@phunq.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [RFC][PATCH 1/2] Add a super operation for writeback
References: <538B9DEE.20800@phunq.net> <538C360F.7020901@ontolinux.com> <20140603033940.GB14410@dastard>
In-Reply-To: <20140603033940.GB14410@dastard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:v4/ejXAkkUPUWiXjgsjUIlx4EWh/AZcfxr7pj+UGiXi
 Aro90EUIU09XStTw0pBRNN0TMlswqMaSMIn84woaP5W60qYHo0
 AOWL5lo8I0BfZcD5NXhmN2ln1HUXnGHn4oVl5DCjJoZEDVoFav
 wpgneK7xnoLpU9HHkdc82yE5xXuGZlq4F0Ed7zJlFmFhpF7BQO
 I7XUdBQvmL05lwmSvVAn2XF3pfaaQvzUpmt4n2rHtntobuLRUa
 O9hP+hi1o4gkxj6Rp+kOowAnUyar8YGcqXyCxT/FQDTYInwGuR
 2EyVj2yV98uido6OrVHKEmemMbz3WAlyEQX4eDHKFDnDHvtLJJ
 xOcyHO2Ld7uZIogdVDuY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the 3rd of June 2014 05:39, Dave Chinner wrote:
> On Mon, Jun 02, 2014 at 10:30:07AM +0200, Christian Stroetmann wrote:
>> When I followed the advice of Dave Chinner:
>> "We're not going to merge that page forking stuff (like you were
>> told at LSF 2013 more than a year ago:
>> http://lwn.net/Articles/548091/) without rigorous design review and
>> a demonstration of the solutions to all the hard corner cases it
>> has"
>> given in his e-mail related with the presentation of the latest
>> version of the Tux3 file system (see [1]) and read the linked
>> article, I found in the second comments:
>> "Parts of this almost sound like it either a.) overlaps with or b.)
>> would benefit greatly from something similar to Featherstitch
>> [[2]]."
>>
>> Could it be that we have with Featherstitch a general solution
>> already that is said to be even "file system agnostic"?
>> Honestly, I thought that something like this would make its way into
>> the Linux code base.
> Here's what I said about the last proposal (a few months ago) for
> integrating featherstitch into the kernel:
>
> http://www.spinics.net/lists/linux-fsdevel/msg72799.html
>
> It's not a viable solution.
>
> Cheers,
>
> Dave.

How annoying, I did not remember your e-mail of the referenced thread 
"[Lsf-pc] [LSF/MM TOPIC] atomic block device" despite I saved it on 
local disk. Thanks a lot for the reminder.

I also directly saw the problem with the research prototype 
Featherstitch, specifically the point "All the filesystem modules it has 
are built into the featherstitch kernel module, and called through a VFS 
shim layer". But it is just a prototype and its concept of abstraction 
has not to be copied 1:1 into the Linux code base.

In general, I do not believe that the complexity problems of soft 
updates, atomic writes, and related techniques can be solved by 
hand/manually. So my suggestion is to automatically handle the 
complexity problem of e.g. dependancies in a way that is comparable to 
a(n on-the-fly) file-system compiler so to say that works on a very 
large dependancy graph (having several billions of graph vertices 
actually). And at this point an abstraction like it is given with 
Featherstitch helps to feed and control this special FS compiler.

Actually, I have to follow the discussion further on the one hand and go 
deeper into the highly complex problem space on the other hand.



With all the best
Christian

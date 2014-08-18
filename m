Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbaHRWsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 18:48:50 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:23068 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbaHRWst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 18:48:49 -0400
Message-ID: <53F282CE.5030205@hp.com>
Date: Mon, 18 Aug 2014 18:48:46 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Jason Low <jason.low2@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <davidlohr@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH 2/7] locking/rwsem: more aggressive use of optimistic
 spinning
References: <1407119782-41119-1-git-send-email-Waiman.Long@hp.com> <1407119782-41119-3-git-send-email-Waiman.Long@hp.com> <1407125450.4710.38.camel@j-VirtualBox> <53DFAA53.4010003@hp.com> <20140813055153.GD20518@dastard> <53EB9522.2070804@hp.com> <20140815033447.GJ20518@dastard> <53EE4A31.5080407@hp.com> <20140817234152.GC26465@dastard>
In-Reply-To: <20140817234152.GC26465@dastard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2014 07:41 PM, Dave Chinner wrote:
> On Fri, Aug 15, 2014 at 01:58:09PM -0400, Waiman Long wrote:
>> On 08/14/2014 11:34 PM, Dave Chinner wrote:
>>> <create sparse vm image file of 500TB on ssd with XFS on it>
>>> xfs_io -f -c "truncate 500t" -c "extsize 1m" /path/to/vm/image/file
> ....
>> Thank for the testing recipe. I am afraid that I can't find a 500TB
>> SSD for testing purpose.
> Which bit of "sparse vm image file" didn't you understand?  I'm
> using a 400GB of SSD for this testing....
>
> $ df -h /mnt/fast-ssd
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/sdf        400G  275G  125G  69% /mnt/fast-ssd
> $ ls -lh /mnt/fast-ssd/vm-500t.img
> -rw------- 1 root root 500T Aug 15 13:21 /mnt/fast-ssd/vm-500t.img
> $ du -sh /mnt/fast-ssd/vm-500t.img
> 275G    /mnt/fast-ssd/vm-500t.img
>
> That is on a Samsung 840 EVO SSD, which just about everyone should
> be able to obtain. Do you *really* think I have 500TB of SSDs lying
> around?
>
> Cheers,
>
> Dave.

I am sorry that I misunderstood your instruction. I am not a filesystem 
guy and haven't run this kind of test before.

Thank for the clarification.

-Longman

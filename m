Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab3IKBtJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 21:49:09 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:32163 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab3IKBtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 21:49:07 -0400
Message-ID: <522FCC06.3090907@hp.com>
Date: Tue, 10 Sep 2013 21:48:54 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Mace Moneta <moneta.mace@gmail.com>, Josh Boyer <jwboyer@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: kernel BUG at fs/dcache.c:648! with v3.11-7890-ge5c832d
References: <CA+5PVA4k9tTPs9vtTbMuG7pzw4kb3KFK-CLaqDDG4dm=0twyCQ@mail.gmail.com> <CA+55aFzg_r2c09TkGwmsMV3HbNAkSFJLGAFWweLNzofqs4o4Ug@mail.gmail.com> <CA+5PVA6EDV3zuDEyCvcGNvEAPtgY_Oy9xVbaM03ggRBPtq5Mmg@mail.gmail.com> <CA+55aFympAk-hnekaew8po5wLJdiY+DC_b4h=pa-y5i9=s303Q@mail.gmail.com> <CA+55aFygRtwwknO4Jb+nna046VhdNCXh2S0ybRBPf=b1GH9FPg@mail.gmail.com> <CAMfhy93EoDohCrV+ykj6b+R9QSCTdiPtvSpJpe3SH=ot_1LWMg@mail.gmail.com> <CA+55aFxvAn=jTbQXxery54uaaq=QsLzJgPdwnTd8B77abc92jQ@mail.gmail.com> <CAMfhy92u1GFvTrO+8SNp8hoEBEHcd7Z-3mw+79rv8+2yYqa+ow@mail.gmail.com> <CAMfhy90vEu2_hfoOnzB+ZOit4HNmKex2WObmztcY7R4+PBwd7w@mail.gmail.com> <CA+55aFzFWbCGqaGe1BbuBY_j+0xK-UfYEJddjSWriufs0Q5PmQ@mail.gmail.com>
In-Reply-To: <CA+55aFzFWbCGqaGe1BbuBY_j+0xK-UfYEJddjSWriufs0Q5PmQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 04:25 PM, Linus Torvalds wrote:
> On Tue, Sep 10, 2013 at 12:57 PM, Mace Moneta<moneta.mace@gmail.com>  wrote:
>> The (first) patch looks good; no recurrence. It has only taken 3-5 minutes
>> before, and I've been up for about half an hour now.
> Ok, good. It's pushed out.
>
> Al, your third pile of VFS stuff is also merged. Waiman, that means
> that your RCU path creation stuff is in. What else did you have
> pending for scalability?
>
>                  Linus

I need to clean up some comments in the code. The other thing that I 
want to do is to introduce read_seqlock/read_sequnlock() primitives that 
do the locking without incrementing the sequence number. Then all the 
name lookup and translation code can use the new primitives as they 
don't change any of the protected structures. This will prevent one 
sequence number check failure from cascading into a series of failures 
because of the sequence number change. I will have a patch ready by 
tomorrow morning.

Regards,
Longman

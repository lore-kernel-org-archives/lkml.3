Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbaA1TX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 14:23:27 -0500
Received: from aurora.thatsmathematics.com ([162.209.10.89]:42464 "EHLO
	aurora.thatsmathematics.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755438AbaA1TXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 14:23:24 -0500
Date: Tue, 28 Jan 2014 12:23:20 -0700 (MST)
From: Nate Eldredge <nate@thatsmathematics.com>
X-X-Sender: nate@minerva.lan
To: George Spelvin <linux@horizon.com>
cc: adilger@dilger.ca, arjan@linux.intel.com, jack@suse.cz,
        linux-kernel@vger.kernel.org, maarten-baert@hotmail.com, mingo@elte.hu,
        suresh.b.siddha@intel.com, tglx@linutronix.de, viro@zeniv.linux.org.uk
Subject: Re: math_state_restore and kernel_fpu_end disable interrupts?
In-Reply-To: <20140128185315.9014.qmail@science.horizon.com>
Message-ID: <alpine.DEB.2.10.1401281215060.5828@minerva.lan>
References: <20140128185315.9014.qmail@science.horizon.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jan 2014, George Spelvin wrote:

>> I'm trying it now.  But it takes a while for me to reproduce, and even
>> longer to be sure the problem has gone away.  So anything you hear from
>> me within a week will be bad news.
>
> Well, it's been a week, and: good news!
>
> I'd still wish for some review by someone who really understands this
> code; in particular it seems dangerous to just enable interrupts for
> a window without re-checking the condition afterward.

Yeah, I was thinking the same.  If interrupts were disabled on entry it 
was probably for a good reason, and it is strange for math_state_restore() 
and/or kernel_fpu_end() to unilaterally enable them.  Maybe the caller is 
supposed to know this and account for it, but I didn't see any 
documentation of the intended semantics of kernel_fpu_{begin,end}() with 
respect to interrupts.  The current behavior doesn't really make sense 
either way, but it does make me wonder if something deeper is wrong.

> [...]
>
> But this patch clearly doesn't make these issues any *worse*, so
> these concerns are no reason to block it.
>
>
> Would you like add an appropriate commit message and send in the patch?

Ok, when I have a chance I will write something up and send it in, and 
maybe having it as a formal patch submission will get more attention.

Thanks, George!

-- 
Nate Eldredge
nate@thatsmathematics.com


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab3CKVDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:03:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754539Ab3CKVDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:03:43 -0400
Date: Mon, 11 Mar 2013 17:03:34 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        WANG Chao <chaowang@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
Message-ID: <20130311210333.GF14738@redhat.com>
References: <CAE9FiQXLodhSFy4T9pKLMS+axF0jHGL9B0+TL=dYOFrLVudN9g@mail.gmail.com>
 <513E28B8.3000502@zytor.com>
 <CAE9FiQW-gpEMmc6kseb7E+TEg1F9CqEYZBRDiJ3bDY=t6zGRmg@mail.gmail.com>
 <20130311192021.GF12107@redhat.com>
 <513E36CB.5040908@zytor.com>
 <20130311201245.GC14738@redhat.com>
 <513E3C44.9030402@zytor.com>
 <87hakhk6xu.fsf@xmission.com>
 <20130311204530.GE14738@redhat.com>
 <513E438D.5010303@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513E438D.5010303@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 01:50:21PM -0700, H. Peter Anvin wrote:
> On 03/11/2013 01:45 PM, Vivek Goyal wrote:
> > 
> > - Now we use dracut generated initramfs and it has been growing in size.
> >   Now systemd has been pulled in too.
> > 
> 
> And the solution to that isn't obvious?

Sorry, I did not understand what do you mean by above.

If you are suggesting that move away from dracut, it does not work
in practice. Initially we wrote our custom code to generate custom
initramfs, and we were always lagging in terms of what dump targets
can be supported and kept on constantly fixing the issues which had
been taken care of in dracut one way or other. So it was like
maintaining a duplicate initramfs generation tool.

So we do not want to use non-standard tools just for kdump. dracut
generates the initramfs for first kernel and then it should be able
to for second kernel too.

Another problem is that other user space component developers, they don't
know that they are supposed to work with 64MB in total too. Same is true for
anybody who is writing driver code. 

And bloated memory usage is detected, after the fact. After that one
can keep on chasing people, and they say that it is their feature
requirement. And it is not possible to go and optimize every subsystem
so that together they can boot and work with 64MB.

> 
> > - makdumpfile needs more memory to dump large machines.
> > 
> > There are so many places where memory usage is going up and trying
> > to keep track of all that has been very hard.
> 
> Seriously, in particular the O(n) memory requirements you may want to
> think very very hard about.

Well we now also have a mode in makedumpfile where memory requirement is
O(1). Just that it takes more cpu and takes much longer to dump. May be it
can be improved further.

I am more worried about kernel drivers, and all the user space we need
to pull in to initramfs to meet more advanced requirements in kdump
environment.

Thanks
Vivek

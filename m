Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab3CKUpj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:45:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422Ab3CKUpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:45:38 -0400
Date: Mon, 11 Mar 2013 16:45:30 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        WANG Chao <chaowang@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
Message-ID: <20130311204530.GE14738@redhat.com>
References: <20130311182655.GB12107@redhat.com>
 <513E2695.3080707@zytor.com>
 <CAE9FiQXLodhSFy4T9pKLMS+axF0jHGL9B0+TL=dYOFrLVudN9g@mail.gmail.com>
 <513E28B8.3000502@zytor.com>
 <CAE9FiQW-gpEMmc6kseb7E+TEg1F9CqEYZBRDiJ3bDY=t6zGRmg@mail.gmail.com>
 <20130311192021.GF12107@redhat.com>
 <513E36CB.5040908@zytor.com>
 <20130311201245.GC14738@redhat.com>
 <513E3C44.9030402@zytor.com>
 <87hakhk6xu.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hakhk6xu.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 01:38:53PM -0700, Eric W. Biederman wrote:


[..]
> I would argue
> that it might be better to figure out how to use a small memory
> foot-print and try to keep that foot-print from growing.

In my experience, trying to keep foot-print small has kind of been a
losing battle.

- People want more functionality in second kernel, want to dump to more
  complicated IO stacks and that requires pulling in more drivers,
  more libraries, more daemons, more user space tools and what not.

- Now we use dracut generated initramfs and it has been growing in size.
  Now systemd has been pulled in too.

- Drivers keep on increasing their memory usage.

- makdumpfile needs more memory to dump large machines.

There are so many places where memory usage is going up and trying
to keep track of all that has been very hard.

So I would think that it is a good goal to have but continuously 
increasing memory usage is inevitable.

Thanks
Vivek

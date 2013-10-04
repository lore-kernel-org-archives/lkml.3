Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583Ab3JDGlM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 02:41:12 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:36520 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab3JDGlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 02:41:10 -0400
Date: Fri, 4 Oct 2013 08:41:06 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josh Triplett <josh@joshtriplett.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 17/17] RCU'd vfsmounts
Message-ID: <20131004064106.GG11399@gmail.com>
References: <E1VRcGm-0008Er-EO@ZenIV.linux.org.uk>
 <CA+55aFzeDP6J4ekdn4-85yoXzX3xmEp_qc3npvqepJM+MFn=6Q@mail.gmail.com>
 <20131003105130.GE13318@ZenIV.linux.org.uk>
 <CA+55aFzh+n_2fs=aWcT_5gnLC_pWSHqQPJeQ+fg=+Xw7ib9=dQ@mail.gmail.com>
 <CA+55aFybjMDwdfV2uoGL=8U4c1tytjMwk4sU187e6ha2xQ=3+Q@mail.gmail.com>
 <20131003232826.GA6604@jtriplet-mobl1>
 <CA+55aFxvZV0brpjRERYj6Bb-i2kF+nhfCVvmXV5Bdn2QhEt5sw@mail.gmail.com>
 <20131004004108.GA9914@jtriplet-mobl1>
 <CA+55aFw6DURpj+0Z9pJZdu+VX1Eas8=2AOqamQfR-5S+giyicw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw6DURpj+0Z9pJZdu+VX1Eas8=2AOqamQfR-5S+giyicw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Oct 3, 2013 at 5:41 PM, Josh Triplett <josh@joshtriplett.org> wrote:
> >
> > Read, yes, but I don't think that's enough to force your example above 
> > to work in all cases.  That requires semantics beyond what RCU's 
> > primitives guarantee, and I don't think you can draw conclusions about 
> > those semantics without talking about CPU memory barriers.
> 
> We seriosly depend on nothing leaking out. Not just reads. The "U" in 
> RCU is "update". So it's reads, and it's writes. The fact that it says 
> "read" in "rcu_read_lock()" doesn't mean that only reads would be 
> affected.
> 
> And no, this still has nothing to do with memory barriers. Every single 
> RCU user depends on the memory freeing being delayed by RCU, for 
> example. And again, that's not just reads. It's people taking spinlocks 
> on things that are RCU-protected etc.
> 
> So no, there is no question about this. The only question would be 
> whether we have some RCU mode that is _buggy_, not whether you need 
> extra memory barriers. And that is certainly possible.

Broken RCU modes are not unheard of, but Paul is extremely methodical 
about testing and reviewing all the details - including formal proof 
testing methods. There are lots of high-profile, high-frequency RCU users 
in the kernel that make use of every aspect of RCU semantics and any 
breakage would affect them as well.

There are over 2000 RCU critical sections in the kernel today, so the 
likelyhood of the VFS triggering an unknown bug, without other users 
breaking already, is fairly low. If it happens it will be fixed like other 
RCU bugs.

So I really wouldn't worry about it too much. If you don't mind the 
additional sys_umount() delay then RCU is goodness.

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab3JDApZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 20:45:25 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:41676 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab3JDApX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 20:45:23 -0400
MIME-Version: 1.0
In-Reply-To: <20131004004108.GA9914@jtriplet-mobl1>
References: <E1VRcGm-0008Er-EO@ZenIV.linux.org.uk>
	<CA+55aFzeDP6J4ekdn4-85yoXzX3xmEp_qc3npvqepJM+MFn=6Q@mail.gmail.com>
	<20131003105130.GE13318@ZenIV.linux.org.uk>
	<CA+55aFzh+n_2fs=aWcT_5gnLC_pWSHqQPJeQ+fg=+Xw7ib9=dQ@mail.gmail.com>
	<CA+55aFybjMDwdfV2uoGL=8U4c1tytjMwk4sU187e6ha2xQ=3+Q@mail.gmail.com>
	<20131003232826.GA6604@jtriplet-mobl1>
	<CA+55aFxvZV0brpjRERYj6Bb-i2kF+nhfCVvmXV5Bdn2QhEt5sw@mail.gmail.com>
	<20131004004108.GA9914@jtriplet-mobl1>
Date: Thu, 3 Oct 2013 17:45:21 -0700
X-Google-Sender-Auth: DJM52owlmfJMGpghr_Ajuc_VMXU
Message-ID: <CA+55aFw6DURpj+0Z9pJZdu+VX1Eas8=2AOqamQfR-5S+giyicw@mail.gmail.com>
Subject: Re: [PATCH 17/17] RCU'd vfsmounts
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 3, 2013 at 5:41 PM, Josh Triplett <josh@joshtriplett.org> wrote:
>
> Read, yes, but I don't think that's enough to force your example above
> to work in all cases.  That requires semantics beyond what RCU's
> primitives guarantee, and I don't think you can draw conclusions about
> those semantics without talking about CPU memory barriers.

We seriosly depend on nothing leaking out. Not just reads. The "U" in
RCU is "update". So it's reads, and it's writes. The fact that it says
"read" in "rcu_read_lock()" doesn't mean that only reads would be
affected.

And no, this still has nothing to do with memory barriers. Every
single RCU user depends on the memory freeing being delayed by RCU,
for example. And again, that's not just reads. It's people taking
spinlocks on things that are RCU-protected etc.

So no, there is no question about this. The only question would be
whether we have some RCU mode that is _buggy_, not whether you need
extra memory barriers. And that is certainly possible.

            Linus

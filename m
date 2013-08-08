Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966211Ab3HHTPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 15:15:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966174Ab3HHTP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 15:15:29 -0400
Date: Thu, 8 Aug 2013 20:15:22 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
To: Mike Rapoport <mike.rapoport@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [QUERY] lguest64
Message-ID: <20130808191522.GA1857@redhat.com>
References: <CALkWK0n7zedKD4tnxKh-qMuDnMJ5RXjnPJ9EUWT=cCgiokX11A@mail.gmail.com>
 <51E97779.3020103@zytor.com>
 <87zjte9iah.fsf@rustcorp.com.au>
 <CABpLfohrweJd0=0eFJDO7dv2HHxx_mbP0uySMDrsZZZXExdXug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABpLfohrweJd0=0eFJDO7dv2HHxx_mbP0uySMDrsZZZXExdXug@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 12:39:23PM +0300, Mike Rapoport wrote:
> On Tue, Jul 23, 2013 at 4:28 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > Yes, the subset of x86-64 machines for which there isn't hardware
> > virtualization support is pretty uninteresting.
> 
> There are plenty virtual machines in EC2, Rackspace, HP and other
> clouds that do not have hardware virtualization. I believe that
> running a hypervisor on them may be pretty interesting.

[Jumping in rather late]

The problem with basing this on lguest is that you would need to
implement a whole lot of stuff from qemu to make lguest really useful
as a modern hypervisor.  eg. qcow2 and a variety of other block
devices, kvmclock, virtio{-scsi,-net}.  Probably more, but just
implementing those will keep you going for a while.  It might also be
feasible to add lguest support to qemu.

However I think it's best to do nothing and use TCG mode in qemu.  TCG
is a bit slower than lguest or UML, but definitely not unusable.  It's
a drop-in replacement for qemu/KVM with all the same features, and it
works today.

We use and support TCG to make libguestfs work on EC2.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Fedora Windows cross-compiler. Compile Windows programs, test, and
build Windows installers. Over 100 libraries supported.
http://fedoraproject.org/wiki/MinGW

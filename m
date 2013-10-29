Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab3J2UAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 16:00:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38333 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab3J2UAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 16:00:14 -0400
Date: Tue, 29 Oct 2013 13:00:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Gardner <tim.gardner@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Gleb Natapov <gleb@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM list <kvm@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 3.12-rc7] KVM: Fix modprobe failure for kvm_intel/kvm_amd
Message-ID: <20131029200012.GA19769@kroah.com>
References: <1383059634-55512-1-git-send-email-tim.gardner@canonical.com>
 <CA+55aFwUdXp4412F5LdmCRrGZCYiFpiPk7oksGi30CzP6i5O+w@mail.gmail.com>
 <52700C24.9050001@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52700C24.9050001@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 12:57:32AM +0530, Raghavendra K T wrote:
> Adding Greg/AI too since we touch debugfs code.

You do?

> [...]
> >>
> >>sudo modprobe kvm_amd
> >>modprobe: ERROR: could not insert 'kvm_amd': Bad address
> >
> >"Bad address"? Christ people, are you guys making up error numbers
> >with some kind of dice-roll? I can just see it now, somebody sitting
> >there with a D20, playing some kind of kernel-specific D&D, and
> >rolling a ten means that you get to slay the orc, and pick an error
> >number of EFAULT for some random kernel function. Because quite
> >frankly, "random dice roll" is the _only_ thing that explains "Bad
> >address" sufficiently.
> >
> >Please, whoever wrote virt/kvm/kvm_main.c:: kvm_init_debug(), WTF?
> >EFAULT means "user passed in an invalid virtual address pointer",
> >which is why the error string is "Bad address". It makes absolutely NO
> >SENSE here. Perhaps EEXIST or EBUSY.
> >
> 
> Right. In current scenario it should have been EEXIST :(.
> 
> debugfs_create_dir() currently returns NULL dentry on both
> EEXIST, ENOMEM ... cases.
> 
> Could one solution be cascading actual error
> that is lost in fs/debugfs/inode.c:__create_file(), so that we could
> take correct action in case of failure of debugfs_create_dir()?

What would you do here?  You shouldn't really care about debugfs files,
if there's an error, keep on going, no code path should really care,
right?

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab3J3QXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 12:23:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46264 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab3J3QXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 12:23:44 -0400
Date: Wed, 30 Oct 2013 09:23:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Gardner <tim.gardner@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Gleb Natapov <gleb@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 3.12-rc7] KVM: Fix modprobe failure for kvm_intel/kvm_amd
Message-ID: <20131030162342.GA21211@kroah.com>
References: <1383059634-55512-1-git-send-email-tim.gardner@canonical.com>
 <CA+55aFwUdXp4412F5LdmCRrGZCYiFpiPk7oksGi30CzP6i5O+w@mail.gmail.com>
 <52700C24.9050001@linux.vnet.ibm.com>
 <CA+55aFzqumDX8hRyC4avbpA2g_RRb28ZPYk=_-4atGJ=67Zu1A@mail.gmail.com>
 <52711121.9030606@linux.vnet.ibm.com>
 <20131030142359.GA32196@kroah.com>
 <5271284A.6000002@linux.vnet.ibm.com>
 <527129D4.3010308@redhat.com>
 <20131030155930.GA23433@kroah.com>
 <52712EE9.9050402@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52712EE9.9050402@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 05:08:09PM +0100, Paolo Bonzini wrote:
> Il 30/10/2013 16:59, Greg KH ha scritto:
> >> > Even if it is okay to exit and not create the files (and I think it's a
> >> > bit surprising), I'd like at least a printk to signal what's happening.
> >> >  But there should be no reason for debugfs directory creation to fail in
> >> > the end, except for basic mistakes such as the one that Tim reported, so
> >> > I think it's better to report the failure.
> > Creation will "fail" if debugfs is not enabled, so spiting out printk
> > messages in that case is not a good idea.
> 
> Interestingly, if debugfs is not enabled we are already returning an
> error-valued pointer:
> 
> static inline struct dentry *debugfs_create_dir(const char *name,
>                                                 struct dentry *parent)
> {
>         return ERR_PTR(-ENODEV);
> }
> 
> which would oops a lot of the current callers.

It will oops?  Really?  Where?  That shouldn't happen at all.

> Very few places use the currently correct idiom
> 
> 	if (IS_ERR(root) || !root)
> 
> but it's very ugly...  Perhaps debugfs_create_dir *should* return an
> error-valued pointer after all.

Or just don't care about the return value, and all will work out just
fine, right?

thanks,

greg k-h

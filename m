Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab3ETCgZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 22:36:25 -0400
Received: from ozlabs.org ([203.10.76.45]:50903 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755172Ab3ETCgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 22:36:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>,
        kvm@vger.kernel.org, Stephen Hemminger <shemminger@vyatta.com>,
        Jason Wang <jasowang@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_pci: fix macro exported in uapi
In-Reply-To: <32418.1368781063@warthog.procyon.org.uk>
References: <87wqqy8o2k.fsf@rustcorp.com.au> <20130516164446.GA32007@redhat.com> <32418.1368781063@warthog.procyon.org.uk>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 20 May 2013 09:38:25 +0930
Message-ID: <87r4h2zf5y.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:
> Rusty Russell <rusty@rustcorp.com.au> wrote:
>
>> Macro still isn't usable, because userspace can't know whether it's the
>> new or old.
>> 
>> We need to either remove it from UAPI, or rename it to
>> VIRTIO_PCI_CONFIG_OFF.
>
> Surely, if userspace is using it as is, you can't remove it, rename it or
> alter it?

The point of the patch is that it's unusable:

#define VIRTIO_PCI_CONFIG(dev)		((dev)->msix_enabled ? 24 : 20)

ie. it's accessing a member of the kernel's virtio_pci_dev structure.

In theory, userspace could have a structure with the same field and be
using it now, but that's unlikely (qemu certainly doesn't).  No harm no
foul.

In theory it's actually a useful macro, so we could expose it to
userspace, but we'd need to have a new name so userspace can #ifdef for
older headers...

Hope that clarifies,
Rusty.

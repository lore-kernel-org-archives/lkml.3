Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab3EQBOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 21:14:46 -0400
Received: from ozlabs.org ([203.10.76.45]:34574 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755026Ab3EQBOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 21:14:42 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Cc: Stephen Hemminger <shemminger@vyatta.com>,
        Jason Wang <jasowang@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_pci: fix macro exported in uapi
In-Reply-To: <20130516164446.GA32007@redhat.com>
References: <20130516164446.GA32007@redhat.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 17 May 2013 09:39:07 +0930
Message-ID: <87wqqy8o2k.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> macro VIRTIO_PCI_CONFIG except in the unlikely event userspace
> actually has a structure with a field named msix_enabled.
> Get the msix_enabled by value instead, to make it useful
> for userspace.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Macro still isn't usable, because userspace can't know whether it's the
new or old.

We need to either remove it from UAPI, or rename it to
VIRTIO_PCI_CONFIG_OFF.

Cheers,
Rusty.

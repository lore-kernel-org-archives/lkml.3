Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab3ETJHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 05:07:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295Ab3ETJHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 05:07:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <87r4h2zf5y.fsf@rustcorp.com.au>
References: <87r4h2zf5y.fsf@rustcorp.com.au> <87wqqy8o2k.fsf@rustcorp.com.au> <20130516164446.GA32007@redhat.com> <32418.1368781063@warthog.procyon.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: dhowells@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>,
        kvm@vger.kernel.org, Stephen Hemminger <shemminger@vyatta.com>,
        Jason Wang <jasowang@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_pci: fix macro exported in uapi
Date: Mon, 20 May 2013 10:06:56 +0100
Message-ID: <1032.1369040816@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> wrote:

> The point of the patch is that it's unusable:
> 
> #define VIRTIO_PCI_CONFIG(dev)		((dev)->msix_enabled ? 24 : 20)
> 
> ie. it's accessing a member of the kernel's virtio_pci_dev structure.

Ah, okay.  In that case, zap it and see if anyone complains.

David

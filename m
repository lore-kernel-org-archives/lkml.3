Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab3FGDDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 23:03:10 -0400
Received: from ozlabs.org ([203.10.76.45]:45166 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828Ab3FGDDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 23:03:05 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Jason Wang <jasowang@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH RFC] virtio-pci: support config layout in BAR1
In-Reply-To: <20130605163500.GA3393@redhat.com>
References: <20130605163500.GA3393@redhat.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 07 Jun 2013 11:43:01 +0930
Message-ID: <87fvwur7ma.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> Some setups don't support enabling BAR0 (IO BAR). Reasons range from CPU
> limitations (e.g. on some powerpc setups) to architecture limmitations
> (e.g. a setup with >15 PCI bridges, with one virtio device behind each,
> on x86).
>
> PCI Express spec made IO optional, so future guests will disable IO for
> a device in more and more configurations.
>
> This patch makes it possible for host to mirror the config in BAR1, such
> that these setups can work properly.
>
> Guests with old drivers can't be fixed, they will continue to work as
> well (or as bad) as they did previously.  For this reason, changing
> revision id appears unnecessary - it would break setups that previously
> worked, partially.
>
> Future work on re-organizing layout won't conflict with this patch - it
> can use a different BAR or put config at an offset, or update revision.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Since QEMU won't support this, I think we'll have to wait for the PCI
capabilities, ie. the virtio spec 1.0.

Cheers,
Rusty.

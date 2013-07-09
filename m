Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab3GJBtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 21:49:43 -0400
Received: from ozlabs.org ([203.10.76.45]:38899 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543Ab3GJBtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 21:49:42 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>, Cong Wang <amwang@redhat.com>,
        Amos Kong <akong@redhat.com>, Dave Jones <davej@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio-net: put virtio net header inline with data
In-Reply-To: <20130709051824.GA3234@redhat.com>
References: <20130708101259.GA16074@redhat.com> <871u78eavc.fsf@rustcorp.com.au> <20130709051824.GA3234@redhat.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 09 Jul 2013 17:38:51 +0930
Message-ID: <87vc4kcfzg.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> On Tue, Jul 09, 2013 at 11:46:23AM +0930, Rusty Russell wrote:
>> "Michael S. Tsirkin" <mst@redhat.com> writes:
>> > For small packets we can simplify xmit processing
>> > by linearizing buffers with the header:
>> > most packets seem to have enough head room
>> > we can use for this purpose.
>> > Since existing hypervisors require that header
>> > is the first s/g element, we need a feature bit
>> > for this.
>> >
>> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>> > ---
>> >
>> > Note: this needs to be applied on top of patch
>> > defining VIRTIO_F_ANY_LAYOUT - bit to be
>> > selected by Rusty.
>> >
>> > The following patch should work for any definition of
>> > VIRTIO_F_ANY_LAYOUT - I used bit 31 for testing.
>> > Rusty, could you please pick a valid bit for VIRTIO_F_ANY_LAYOUT
>> > and squeeze this patch into 3.11?
>> 
>> Sorry, it's too late.
>> 
>> First, I've been a bit lax in sending patches via DaveM, and this is
>> definitely his territory (ie. more net than virtio).
>
> Let's do this: I'll send a patch series, you ack and we see
> what happens?

If you convince DaveM, I won't object :)

>> Secondly, it needs baking and testing time.
>> 
>> Cheers,
>> Rusty.
>
> I did some testing on this.  But proper testing just isn't happening out
> of tree.

But it will get into linux-next for the *next* merge window.

Cheers,
Rusty.

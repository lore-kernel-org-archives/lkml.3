Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab3CCWPX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 17:15:23 -0500
Received: from ozlabs.org ([203.10.76.45]:40359 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541Ab3CCWPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 17:15:22 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 02/16] virtio_ring: virtqueue_add_sgs, to add multiple sgs.
In-Reply-To: <512F223B.4080801@redhat.com>
References: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au> <1361260594-601-3-git-send-email-rusty@rustcorp.com.au> <20130224221255.GA5300@redhat.com> <512C5E0E.5040305@redhat.com> <87obf6dxlm.fsf@rustcorp.com.au> <20130227074920.GA11775@redhat.com> <87fw0idmu2.fsf@rustcorp.com.au> <512F223B.4080801@redhat.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 01 Mar 2013 11:31:40 +1030
Message-ID: <877glsc4qz.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> Il 27/02/2013 12:21, Rusty Russell ha scritto:
>>>> >> Baseline (before add_sgs):
>>>> >>         2.840000-3.040000(2.927292)user
>>>> >> 
>>>> >> After add_sgs:
>>>> >>         2.970000-3.150000(3.053750)user
>>>> >> 
>>>> >> After simplifying add_buf a little:
>>>> >>         2.950000-3.210000(3.081458)user
>>>> >> 
>>>> >> After inlining virtqueue_add/vring_add_indirect:
>>>> >>         2.920000-3.150000(3.026875)user
>>>> >> 
>>>> >> After passing in iteration functions (chained vs unchained):
>>>> >>         2.760000-2.970000(2.883542)user
>> Oops.  This result (and the next) is bogus.  I was playing with -O3, and
>> accidentally left that in :(
>
> Did you check what actually happened that improved speed so much?

No, it was a random aside, I didn't dig into it.  Perhaps we should
revisit using -O3 on the entire kernel, or perhaps grab gcc 3.8 and see
how that performs.

But I'm implementing specialized virtqueue_add_outbuf() and
virtqueue_add_inbuf() which seem to get more improvement anyway (except
occasionally I get hangs in my tests, which I'm debugging now...)

Cheers,
Rusty.


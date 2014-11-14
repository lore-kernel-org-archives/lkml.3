Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965421AbaKNOlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 09:41:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964832AbaKNOll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 09:41:41 -0500
Date: Fri, 14 Nov 2014 15:41:36 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Igor Mammedov <imammedo@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, yoshikawa_takuya_b1@lab.ntt.co.jp
Subject: Re: [PATCH 1/3] kvm: memslots: track id_to_index changes during the
 insertion sort
Message-ID: <20141114144135.GC27697@potion.brq.redhat.com>
References: <1415963522-5255-1-git-send-email-pbonzini@redhat.com>
 <1415963522-5255-2-git-send-email-pbonzini@redhat.com>
 <20141114133500.GA10593@potion.brq.redhat.com>
 <20141114151725.55774165@igors-macbook-pro.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141114151725.55774165@igors-macbook-pro.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-14 15:17+0100, Igor Mammedov:
> > (We'll have to change it into an interval tree, or something, if the
> >  number of slots rises anyway.)
> Only if it rises to huge amount, I've played with proposed 512 memslots
> and it takes ~10000 cycles which is 5% of current heapsort overhead.
> Taking in account that it's slow path anyway, it's unlikely that there
> would be need to speedup this case even more.

Yes, your improvement is great and would work even for higher amounts.

I meant that our lookup is currently pretty sad -- O(N) that is
presumably optimized by looking at the largest regions first.

Maybe we would benefit from O(log N) lookup even with 128 memslots.

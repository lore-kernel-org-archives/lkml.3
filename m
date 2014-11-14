Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161074AbaKNOoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 09:44:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161026AbaKNOoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 09:44:18 -0500
Message-ID: <54661530.6090301@redhat.com>
Date: Fri, 14 Nov 2014 15:44:00 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        yoshikawa_takuya_b1@lab.ntt.co.jp
Subject: Re: [PATCH 1/3] kvm: memslots: track id_to_index changes during the
 insertion sort
References: <1415963522-5255-1-git-send-email-pbonzini@redhat.com> <1415963522-5255-2-git-send-email-pbonzini@redhat.com> <20141114133500.GA10593@potion.brq.redhat.com> <20141114151725.55774165@igors-macbook-pro.local> <20141114144135.GC27697@potion.brq.redhat.com>
In-Reply-To: <20141114144135.GC27697@potion.brq.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 14/11/2014 15:41, Radim Krčmář wrote:
> Yes, your improvement is great and would work even for higher amounts.
> 
> I meant that our lookup is currently pretty sad -- O(N) that is
> presumably optimized by looking at the largest regions first.

Yes, that's the optimization.

> Maybe we would benefit from O(log N) lookup even with 128 memslots.

Maybe, but the common case so far is about 10, and all but two of them
are only used at boot time. :)

Perhaps we could add a one-item MRU cache, that could help lookups a
bit.  That's what QEMU does too, by the way.  It used to sort the list
in MRU-to-LRU order, but that wasn't too thread-friendly so it was
switched to biggest-to-smallest (with inspiration taken from KVM).

Paolo

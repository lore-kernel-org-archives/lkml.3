Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbbAMSqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 13:46:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696AbbAMSqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 13:46:47 -0500
Date: Tue, 13 Jan 2015 19:45:10 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Will Deacon <will.deacon@arm.com>
Cc: paulmck@linux.vnet.ibm.com, peterz@infradead.org,
        torvalds@linux-foundation.org, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: Behaviour of smp_mb__{before,after}_spin* and acquire/release
Message-ID: <20150113184510.GA31525@redhat.com>
References: <20150113163353.GE31784@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150113163353.GE31784@arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13, Will Deacon wrote:
>
>   1. Does smp_mb__before_spinlock actually have to order prior loads
>      against later loads and stores? Documentation/memory-barriers.txt
>      says it does, but that doesn't match the comment

The comment says that smp_mb__before_spinlock() + spin_lock() should
only serialize STOREs with LOADs. This is because it was added to ensure
that the setting of condition can't race with ->state check in ttwu().

But since we use wmb() it obviously serializes STOREs with STORES. I do
not know if this should be documented, but we already have another user
which seems to rely on this fact: set_tlb_flush_pending().

As for "prior loads", this doesn't look true...

Oleg.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab3KYKUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 05:20:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825Ab3KYKUR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 05:20:17 -0500
Date: Mon, 25 Nov 2013 12:19:43 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, avi.kivity@gmail.com,
        "pbonzini@redhat.com Bonzini" <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Eric Dumazet <dada1@cosmosbay.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 07/15] KVM: MMU: introduce nulls desc
Message-ID: <20131125101943.GS2108@redhat.com>
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1382534973-13197-8-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20131122191429.GA13308@amt.cnet>
 <65EE805B-B5DB-4BD0-A057-E5FF78D96D67@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=cp1255
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <65EE805B-B5DB-4BD0-A057-E5FF78D96D67@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 02:11:31PM +0800, Xiao Guangrong wrote:
> > 
> > For example, nothing prevents lockless walker to move into some
> > parent_ptes chain, right?
> 
> No.
> 
> The nulls can help us to detect this case, for parent_ptes, the nulls points
> to "shadow page" but for rmaps, the nulls points to slot.arch.rmap. There
> is no chance that the “rmap" is used as shadow page when slot-lock is held.
> 
But meanwhile we will write protect non-last level sptes, no? Better to
create separate slab caches for rmap and parent_ptes lists.

--
			Gleb.

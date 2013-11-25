Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab3KYSOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 13:14:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967Ab3KYSOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 13:14:18 -0500
Date: Mon, 25 Nov 2013 16:12:54 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@redhat.com>, avi.kivity@gmail.com,
        "pbonzini@redhat.com Bonzini" <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Eric Dumazet <dada1@cosmosbay.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 07/15] KVM: MMU: introduce nulls desc
Message-ID: <20131125181254.GB21858@amt.cnet>
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1382534973-13197-8-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20131122191429.GA13308@amt.cnet>
 <65EE805B-B5DB-4BD0-A057-E5FF78D96D67@linux.vnet.ibm.com>
 <5292EE2F.5090305@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5292EE2F.5090305@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 02:29:03PM +0800, Xiao Guangrong wrote:
> >> Also, there is no guarantee of termination (as long as sptes are
> >> deleted with the correct timing). BTW, can't see any guarantee of
> >> termination for rculist nulls either (a writer can race with a lockless
> >> reader indefinately, restarting the lockless walk every time).
> > 
> > Hmm, that can be avoided by checking dirty-bitmap before rewalk,
> > that means, if the dirty-bitmap has been set during lockless write-protection,
> > it�s unnecessary to write-protect its sptes. Your idea?
> This idea is based on the fact that the number of rmap is limited by
> RMAP_RECYCLE_THRESHOLD. So, in the case of adding new spte into rmap,
> we can break the rewalk at once, in the case of deleting, we can only
> rewalk RMAP_RECYCLE_THRESHOLD times.

Please explain in more detail.


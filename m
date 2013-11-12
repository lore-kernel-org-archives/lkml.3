Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab3KMBbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 20:31:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169Ab3KMBar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 20:30:47 -0500
Date: Tue, 12 Nov 2013 20:44:59 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@redhat.com, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 02/15] KVM: MMU: lazily drop large spte
Message-ID: <20131112224459.GA14651@amt.cnet>
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1382534973-13197-3-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382534973-13197-3-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 09:29:20PM +0800, Xiao Guangrong wrote:
> Currently, kvm zaps the large spte if write-protected is needed, the later
> read can fault on that spte. Actually, we can make the large spte readonly
> instead of making them un-present, the page fault caused by read access can
> be avoided
> 
> The idea is from Avi:
> | As I mentioned before, write-protecting a large spte is a good idea,
> | since it moves some work from protect-time to fault-time, so it reduces
> | jitter.  This removes the need for the return value.
> 
> This version has fixed the issue reported in 6b73a9606, the reason of that
> issue is that fast_page_fault() directly sets the readonly large spte to
> writable but only dirty the first page into the dirty-bitmap that means
> other pages are missed. Fixed it by only the normal sptes (on the
> PT_PAGE_TABLE_LEVEL level) can be fast fixed
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>


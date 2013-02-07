Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab3BGA7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 19:59:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757228Ab3BGA7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 19:59:05 -0500
Date: Wed, 6 Feb 2013 22:28:16 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi.kivity@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3] KVM: MMU: lazily drop large spte
Message-ID: <20130207002816.GA16685@amt.cnet>
References: <5110B08D.9080600@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5110B08D.9080600@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 03:11:09PM +0800, Xiao Guangrong wrote:
> Currently, kvm zaps the large spte if write-protected is needed, the later
> read can fault on that spte. Actually, we can make the large spte readonly
> instead of making them un-present, the page fault caused by read access can
> be avoid
> 
> The idea is from Avi:
> | As I mentioned before, write-protecting a large spte is a good idea,
> | since it moves some work from protect-time to fault-time, so it reduces
> | jitter.  This removes the need for the return value.
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

Applied, thanks.


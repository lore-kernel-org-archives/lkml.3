Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbaICJaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:30:22 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56821 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbaICJaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:30:21 -0400
Date: Wed, 3 Sep 2014 11:30:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Wang <jasowang@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>,
        Eliezer Tamir <eliezer.tamir@linux.intel.com>
Subject: Re: [PATCH net-next 2/2] net: exit busy loop when another process is
 runnable
Message-ID: <20140903093008.GC4783@worktop.ger.corp.intel.com>
References: <1408608310-13579-1-git-send-email-jasowang@redhat.com>
 <1408608310-13579-2-git-send-email-jasowang@redhat.com>
 <1408683665.5648.69.camel@marge.simpson.net>
 <20140901093159.GB27892@worktop.ger.corp.intel.com>
 <20140901095219.GD21269@redhat.com>
 <20140901100434.GD27892@worktop.ger.corp.intel.com>
 <20140901101939.GA31157@worktop.ger.corp.intel.com>
 <5405419E.7020103@redhat.com>
 <20140902102410.GX27892@worktop.ger.corp.intel.com>
 <5406BC19.9020009@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5406BC19.9020009@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 02:58:33PM +0800, Jason Wang wrote:
> On 09/02/2014 06:24 PM, Peter Zijlstra wrote:
> The patch only try to improve the performance of busy read (and test
> results shows impressive changes). It does not change anything for busy
> poll. Considering there maybe two processes in one cpu, one is doing
> busy read and one is doing busy polling. This patch may in fact help the
> busy polling performance in this case.
> 
> It's good to discuss the ideas of busy poll together, but it was out of
> the scope of this patch. We can try to do optimization on top.

No thta's just wrong, blocked read and blocking select should behave the
same.

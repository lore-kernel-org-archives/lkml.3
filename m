Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab3KYL36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 06:29:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38282 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab3KYL35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 06:29:57 -0500
Date: Mon, 25 Nov 2013 12:29:49 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, gleb@redhat.com,
        avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH v3 07/15] KVM: MMU: introduce nulls desc
Message-ID: <20131125112949.GJ3694@twins.programming.kicks-ass.net>
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1382534973-13197-8-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20131122191429.GA13308@amt.cnet>
 <20131125093157.GU10022@twins.programming.kicks-ass.net>
 <52932D8C.2080308@linux.vnet.ibm.com>
 <20131125110500.GV3866@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131125110500.GV3866@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 12:05:00PM +0100, Peter Zijlstra wrote:
> On Mon, Nov 25, 2013 at 06:59:24PM +0800, Xiao Guangrong wrote:
> > I guess Marcelo was talking about rculist_nulls.h
> > (Documentation/RCU/rculist_nulls.txt).
> 
> Oh, let me have a look, I don't think I've really looked at that yet.

Egads, that's far too clever ;-)

Yes, if that's what Marcello was referencing to he's right, it doesn't
have a proper termination condition in the face of unlimited
modification.

And it can indeed use SLAB_DESTROY_BY_RCU as you alluded to -- although
the documentation is a tad scarce explaining why this is so.

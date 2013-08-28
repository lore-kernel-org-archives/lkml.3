Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab3H1Kto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 06:49:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916Ab3H1Ktm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 06:49:42 -0400
Date: Wed, 28 Aug 2013 13:49:38 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 09/12] KVM: MMU: introduce pte-list lockless walker
Message-ID: <20130828104938.GT22899@redhat.com>
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1375189330-24066-10-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130828092001.GQ22899@redhat.com>
 <521DC3FD.1020507@linux.vnet.ibm.com>
 <20130828094630.GR22899@redhat.com>
 <521DCD57.7000401@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521DCD57.7000401@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 06:13:43PM +0800, Xiao Guangrong wrote:
> On 08/28/2013 05:46 PM, Gleb Natapov wrote:
> > On Wed, Aug 28, 2013 at 05:33:49PM +0800, Xiao Guangrong wrote:
> >>> Or what if desc is moved to another rmap, but then it
> >>> is moved back to initial rmap (but another place in the desc list) so
> >>> the check here will not catch that we need to restart walking?
> >>
> >> It is okay. We always add the new desc to the head, then we will walk
> >> all the entires under this case.
> >>
> > Which races another question: What if desc is added in front of the list
> > behind the point where lockless walker currently is?
> 
> That case is new spte is being added into the rmap. We need not to care the
> new sptes since it will set the dirty-bitmap then they can be write-protected
> next time.
> 
OK.

> > 
> >> Right?
> > Not sure. While lockless walker works on a desc rmap can be completely
> > destroyed and recreated again. It can be any order.
> 
> I think the thing is very similar as include/linux/rculist_nulls.h
include/linux/rculist_nulls.h is for implementing hash tables, so they
may not care about add/del/lookup race for instance, but may be we are
(you are saying above that we are not), so similarity does not prove
correctness for our case. BTW I do not see
rcu_assign_pointer()/rcu_dereference() in your patches which hints on
incorrect usage of RCU. I think any access to slab pointers will need to
use those.

--
			Gleb.

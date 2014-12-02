Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933086AbaLBH77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 02:59:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932270AbaLBH50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 02:57:26 -0500
Date: Tue, 2 Dec 2014 08:57:21 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 0/5] kvm: memslots lookup optimization
Message-ID: <20141202085721.2c328a40@nial.usersys.redhat.com>
In-Reply-To: <547CA79A.10206@redhat.com>
References: <1417454967-4465-1-git-send-email-imammedo@redhat.com>
	<547CA79A.10206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Dec 2014 18:38:34 +0100
Paolo Bonzini <pbonzini@redhat.com> wrote:

> 
> 
> On 01/12/2014 18:29, Igor Mammedov wrote:
> > Series speed-ups GFN to memslot lookup time by:
> >  * introducing LRU cache, which improves looukup time for
> >    same slot workload (typically boot time of Windows and Linux guest)
> >  * switching to binary search for GFN to memslot lookup,
> >    improving lookup time with large amount of memory slots
> > 
> > Igor Mammedov (5):
> >   kvm: update_memslots: drop not needed check for the same number of
> >     pages
> >   kvm: update_memslots: drop not needed check for the same slot
> >   kvm: search_memslots: add simple LRU memslot caching
> >   kvm: change memslot sorting rule from size to GFN
> >   kvm: optimize GFN to memslot lookup with large slots amount
> > 
> >  include/linux/kvm_host.h | 28 +++++++++++++++++++++++-----
> >  virt/kvm/kvm_main.c      | 46 ++++++++++++++++++++++++++--------------------
> >  2 files changed, 49 insertions(+), 25 deletions(-)
> > 
> 
> Applied patches 1-3 for now, I'm not in the mood for proving that the
> binary search is correct. :)
Following write up could help with improving a proving mood :)
http://community.topcoder.com/tc?module=Static&d1=tutorials&d2=binarySearch


> 
> Paolo


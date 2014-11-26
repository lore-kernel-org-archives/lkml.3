Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbaKZPh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 10:37:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbaKZPhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 10:37:53 -0500
Date: Wed, 26 Nov 2014 17:37:33 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: David Hildenbrand <dahi@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, paulus@samba.org, akpm@linux-foundation.org,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mingo@kernel.org
Subject: Re: [RFC 0/2] Reenable might_sleep() checks for might_fault() when
 atomic
Message-ID: <20141126153732.GA10568@redhat.com>
References: <1416915806-24757-1-git-send-email-dahi@linux.vnet.ibm.com>
 <20141126070258.GA25523@redhat.com>
 <20141126110504.511b733a@thinkpad-w530>
 <20141126151729.GB9612@redhat.com>
 <5475F218.4050207@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5475F218.4050207@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 04:30:32PM +0100, Christian Borntraeger wrote:
> Am 26.11.2014 um 16:17 schrieb Michael S. Tsirkin:
> > On Wed, Nov 26, 2014 at 11:05:04AM +0100, David Hildenbrand wrote:
> >>> What's the path you are trying to debug?
> >>
> >> Well, we had a problem where we held a spin_lock and called
> >> copy_(from|to)_user(). We experienced very random deadlocks that took some guy
> >> almost a week to debug. The simple might_sleep() check would have showed this
> >> error immediately.
> > 
> 
> > This must have been a very old kernel.
> > A modern kernel will return an error from copy_to_user.
> 
> I disagree. copy_to_user will not return while holding a spinlock, because it does not know! How should it?
> See: spin_lock will call preempt_disable, but thats a no-op for a non-preempt kernel. So the mere fact that we hold a spin_lock is not known by any user access function. (or others). No?
> 
> Christian
> 
> 

Well might_sleep() merely checks preempt count and irqs_disabled too.
If you want debugging things to trigger, you need to enable
a bunch of config options.  That's not new.


-- 
MST

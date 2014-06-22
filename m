Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbaFVTC3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 15:02:29 -0400
Received: from one.firstfloor.org ([193.170.194.197]:50840 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbaFVTC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 15:02:28 -0400
Date: Sun, 22 Jun 2014 21:02:25 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Avi Kivity <avi.kivity@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, peterz@infradead.org, gleb@kernel.org,
        pbonzini@redhat.com, eranian@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/4] kvm: Implement PEBS virtualization
Message-ID: <20140622190225.GN5714@two.firstfloor.org>
References: <1401412327-14810-1-git-send-email-andi@firstfloor.org>
 <1401412327-14810-5-git-send-email-andi@firstfloor.org>
 <53A6E0B9.10408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A6E0B9.10408@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> First, it's not sufficient to pin the debug store area, you also
> have to pin the guest page tables that are used to map the debug
> store.  But even if you do that, as soon as the guest fork()s, it
> will create a new pgd which the host will be free to swap out.  The
> processor can then attempt a PEBS store to an unmapped address which
> will fail, even though the guest is configured correctly.

That's a good point. You're right of course.

The only way I can think around it would be to intercept CR3 writes
while PEBS is active and always pin all the table pages leading 
to the PEBS buffer. That's slow, but should be only needed
while PEBS is running.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

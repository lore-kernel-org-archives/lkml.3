Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab3EOWwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 18:52:10 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:64574 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab3EOWwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 18:52:08 -0400
Date: Thu, 16 May 2013 00:52:03 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: Gleb Natapov <gleb@redhat.com>, Scott Wood <scottwood@freescale.com>,
        linaro-kernel@lists.linaro.org, Marcelo Tosatti <mtosatti@redhat.com>,
        "open list:KERNEL VIRTUAL MA..." <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: allow host header to be included even for
 !CONFIG_KVM
Message-ID: <20130515225201.GA2341@somewhere>
References: <1363823921.25034.35@snotra>
 <20130321072955.GO3889@redhat.com>
 <87ppyshlq5.fsf@linaro.org>
 <1363891354.31522.17@snotra>
 <20130321191600.GG9382@redhat.com>
 <1363894393.31522.20@snotra>
 <20130321211736.GI9382@redhat.com>
 <CAFTL4hz2=VJBLG1w31JSPDtRdobcmL5oY6XkR46vi3zS904VGA@mail.gmail.com>
 <20130324140114.GV3889@redhat.com>
 <87txnz9o7n.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87txnz9o7n.fsf@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 02:14:20PM -0700, Kevin Hilman wrote:
> Gleb Natapov <gleb@redhat.com> writes:
> 
> > On Sun, Mar 24, 2013 at 02:44:26PM +0100, Frederic Weisbecker wrote:
> >> 2013/3/21 Gleb Natapov <gleb@redhat.com>:
> >> > Isn't is simpler for kernel/context_tracking.c to define empty
> >> > __guest_enter()/__guest_exit() if !CONFIG_KVM.
> >> 
> >> That doesn't look right. Off-cases are usually handled from the
> >> headers, right? So that we avoid iffdeffery ugliness in core code.
> > Lets put it in linux/context_tracking.h header then.
> 
> Here's a version to do that.
> 
> Kevin
> 
> From d9d909394479dd7ff90b7bddb95a564945406719 Mon Sep 17 00:00:00 2001
> From: Kevin Hilman <khilman@linaro.org>
> Date: Mon, 25 Mar 2013 14:12:41 -0700
> Subject: [PATCH v2] ontext_tracking: fix !CONFIG_KVM compile: add stub guest
>  enter/exit

Sorry for my very delayed response...

> 
> When KVM is not enabled, or not available on a platform, the KVM
> headers should not be included.  Instead, just define stub
> __guest_[enter|exit] functions.

May be it would be cleaner to move guest_enter/exit definitions altogether
in linux/context_tracking.h

After all that's where the implementation mostly belong to.

Let me see if I can get that in shape.

Thanks.

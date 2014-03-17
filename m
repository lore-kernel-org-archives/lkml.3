Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933392AbaCQOYG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 10:24:06 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:58104 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933272AbaCQOXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 10:23:55 -0400
MIME-Version: 1.0
X-Originating-IP: [85.250.70.16]
In-Reply-To: <53239789.40600@ti.com>
References: <1389658764-39199-1-git-send-email-s-anna@ti.com>
 <52F9282B.5000702@ti.com> <530B8C00.8020001@ti.com> <CAK=WgbZp_RQPCeZJyMRkNTQxaJsnGZ3DnjhSkYYR_-PAE_Kp4g@mail.gmail.com>
 <53239789.40600@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 17 Mar 2014 16:23:34 +0200
Message-ID: <CAK=WgbZCzA7JovSxnysHCQRZZWc3Z2j3AS8ekpM9fOZ160rmCA@mail.gmail.com>
Subject: Re: [PATCHv4 0/7] omap hwspinlock dt support
To: Suman Anna <s-anna@ti.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

On Sat, Mar 15, 2014 at 1:58 AM, Suman Anna <s-anna@ti.com> wrote:
> The series doesn't change the semantics of hwspinlock registration or adds a
> new OF controller registration function. Implementations would still need to
> register a controller using a base_id and number of locks. The series rather
> adds a DT-friendly function _ONLY_ for requesting a specific hwlock, and
> there are no restrictions on the args specifier being relative id numbers.
> Though this is what the simple default xlate helper does (most common
> usage), the added xlate ops and #hwlock-cells should allow individual
> implementation drivers to adjust any variations, and return a relative lock
> w.r.t its registered base_id, as this is how a lock gets registered in the
> first place.

I might be missing something, but why can't we have the
specifier+base_id be the hwlock id and then we can entirely drop most
of the core changes in this patch-set? I realize we couldn't easily
support sparse id numbers, but not sure this is relevant to
hwspinlocks? do we have a use case that couldn't be supported in this
case?

> I actually started out this series with the base_id property, and dropped it
> in v3 based on comments looking at it from the request-specific-lock
> semantics with DT. That said, the drivers still need to manage a 'base_id'
> needed for registration when they get probed for multiple controllers.
> Getting the base_id from DT _may_ be useful just for registration purposes,
> but for requesting a hwlock, a controller phandle and an implementation
> defined args-specifier should suffice IMHO.

How could drivers know what the base_id is if DT doesn't provide it?
please note that we can't depend on order of controller probing; the
hwlock id numbers cannot depend on implementation details.

> The exact notion of informing the hwspinlock core about a list of reserved
> locks is missing at the moment (even in the non-DT case). I am not sure if
> this got lost during the conversion of the registration from per lock to
> registering a bank of locks together, or if it is implied by the base_id +
> num_locks combination. The core today supports requesting only those locks
> that were actually registered, whether allocating a free one dynamically or
> giving a specific one.

Before DT came along, early board code could have reserved specific
hwspinlocks if needed. Now with DT, we should add the list of reserved
locks to the controller node, in order to prevent them from being
dynamically allocated by others.

Thanks,
Ohad.

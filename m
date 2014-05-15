Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbaEOKRw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 06:17:52 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:55025 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753824AbaEOKRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 06:17:51 -0400
Date: Thu, 15 May 2014 11:17:34 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Richard Lee <superlibj8301@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Richard Lee <superlibj@gmail.com>
Subject: Re: [RFC][PATCH 2/2] ARM: ioremap: Add IO mapping space reused
 support.
Message-ID: <20140515101734.GA14737@localhost>
References: <1399861195-21087-1-git-send-email-superlibj8301@gmail.com>
 <1399861195-21087-3-git-send-email-superlibj8301@gmail.com>
 <5146762.jba3IJe7xt@wuerfel>
 <CAHPCO9FRfR5p1N5v7mUk4hUYdPvqfLN6nW1LcnC83sU86ZFbZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHPCO9FRfR5p1N5v7mUk4hUYdPvqfLN6nW1LcnC83sU86ZFbZA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 09:45:08AM +0800, Richard Lee wrote:
> > On Mon, May 12, 2014 at 3:51 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Monday 12 May 2014 10:19:55 Richard Lee wrote:
> >> For the IO mapping, for the same physical address space maybe
> >> mapped more than one time, for example, in some SoCs:
> >> 0x20000000 ~ 0x20001000: are global control IO physical map,
> >> and this range space will be used by many drivers.
> >> And then if each driver will do the same ioremap operation, we
> >> will waste to much malloc virtual spaces.
> >>
> >> This patch add IO mapping space reused support.
> >>
> >> Signed-off-by: Richard Lee <superlibj@gmail.com>
> >
> > What happens if the first driver then unmaps the area?
> 
> If the first driver will unmap the area, it shouldn't do any thing
> except decreasing the 'used' counter.

It's still racy. What if the first driver manage to decrement the used
counter, unmaps the regions but doesn't yet free the vm_struct while
another driver finds the vm_struct, increments the used count and
assumes it can use it?

BTW, vm_area_is_aready_to_free() name implies a query but it has
side-effects like decrementing the counter.

-- 
Catalin

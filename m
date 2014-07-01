Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbaGAM0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 08:26:33 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:61070 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbaGAM0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 08:26:31 -0400
MIME-Version: 1.0
X-Originating-IP: [89.139.36.201]
In-Reply-To: <1398904476-26200-4-git-send-email-s-anna@ti.com>
References: <1398904476-26200-1-git-send-email-s-anna@ti.com> <1398904476-26200-4-git-send-email-s-anna@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 1 Jul 2014 15:26:09 +0300
Message-ID: <CAK=WgbakGbTaYz+4K24aT3vyRkDYwPKCm6XrcJvH667NMMfTTA@mail.gmail.com>
Subject: Re: [PATCHv5 03/15] hwspinlock/core: maintain a list of registered
 hwspinlock banks
To: Suman Anna <s-anna@ti.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

On Thu, May 1, 2014 at 3:34 AM, Suman Anna <s-anna@ti.com> wrote:
>
> The hwspinlock_device structure is used for registering a bank of
> locks with the driver core. The structure already contains the
> necessary members to identify the bank of locks. The core does not
> maintain the hwspinlock_devices itself, but maintains only a radix
> tree for all the registered locks. A specific lock can be requested
> by users using a global lock id, and any device-specific fields
> can be retrieved through a reference to the hwspinlock_device in
> each lock.
>
> The global lock id, however, is not friendly to be requested for
> users using the device-tree model. The device-tree representation
> will typically have each of the hwspinlock devices represented as
> a DT node, and a specific lock can be requested using the device's
> phandle and a lock specifier. Add support to the core therefore to
> maintain all the registered hwspinlock_devices, so that a device
> can be looked up and a specific lock belonging to the device
> requested through a phandle + args approach.
>
> Signed-off-by: Suman Anna <s-anna@ti.com>

I'm not sure we need this patch.

It seems to me that the global lock id can be the base_id + lock
index, where the former should be a property of the parent dt node,
and the latter can just be the phandle argument. Then, with the global
lock id in hand, drivers could just use the existing
hwspin_lock_request_specific API.

If future hardware will bring a more complex scenario, we could then
introduce the xlate proposal to resolve it. As long as we're not
changing the dt data, and this is all handled by kernel code, then I'd
prefer opting for less code now as long as it addresses the
requirements.

Please let me know if currently there is a use case that can't be
addressed using this simpler model.

Thanks,
Ohad.

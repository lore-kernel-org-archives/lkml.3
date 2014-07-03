Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbaGCHAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 03:00:42 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:64783 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbaGCHAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 03:00:40 -0400
MIME-Version: 1.0
X-Originating-IP: [89.139.36.201]
In-Reply-To: <53B47621.6090307@ti.com>
References: <1398904476-26200-1-git-send-email-s-anna@ti.com>
 <1398904476-26200-4-git-send-email-s-anna@ti.com> <CAK=WgbakGbTaYz+4K24aT3vyRkDYwPKCm6XrcJvH667NMMfTTA@mail.gmail.com>
 <53B47621.6090307@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 3 Jul 2014 10:00:18 +0300
Message-ID: <CAK=WgbYtJ7TGqvjG3VAPPD5tVXx9-jEJU3iKEStUMxOvD1v=LQ@mail.gmail.com>
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

On Thu, Jul 3, 2014 at 12:14 AM, Suman Anna <s-anna@ti.com> wrote:
>> I'm not sure we need this patch.
>
> This patch is needed if we use the controller-phandle + args specifier
> for requesting hwlocks by a client, as we need to translate
> controller-phandle to the corresponding hwspinlock_device.
>
> Looks like we still don't have a closure on the semantics of how
> clients have to request a lock in DT. You are suggesting something like
>     hwlocks = <global_lock1 global_lock2 ...>;
>
> whereas this patch is built to support based on comments from
> DT-maintainers,
>     hwlocks = <controller-phandle lock-specifier1>, <controller-phandle
> lock-specifier2>...;

I'm actually ok with this suggestion and haven't suggested otherwise.

All I propose is that we add the base_id property to the controller
node (as you have done in the subsequent patches), and then drivers
will be able to infer the global lock id from the DT data by adding
the controller's base_id to the lock specifier.

Controllers with non standard lock indexing may use an xlate() method
if needed but frankly this is fictional right now. We can start
without this, and add it later when needed, as this doesn't affect the
DT data.

With the global lock id in hand, drivers could simply use the existing
hwspin_lock_request_specific API to obtain a specific lock, and then
we don't need this patch.

Thanks,
Ohad.

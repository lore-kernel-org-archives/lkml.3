Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472AbaKMKDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 05:03:46 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:56039 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932351AbaKMKDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 05:03:43 -0500
MIME-Version: 1.0
X-Originating-IP: [46.116.100.67]
In-Reply-To: <5463B5B6.8040709@ti.com>
References: <1410553499-55951-1-git-send-email-s-anna@ti.com>
 <1410553499-55951-5-git-send-email-s-anna@ti.com> <CAK=WgbamdqAufjC4Xb5moERRBSB-cO6c1RPTE=f+dp75F+Eh7A@mail.gmail.com>
 <5463B5B6.8040709@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 13 Nov 2014 12:03:20 +0200
Message-ID: <CAK=WgbbatPTiz3efDWHVEcuug_UQfkCViMoK0zcfUg3JwB2oTA@mail.gmail.com>
Subject: Re: [PATCHv6 4/5] hwspinlock/core: add common OF helpers
To: Suman Anna <s-anna@ti.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

On Wed, Nov 12, 2014 at 9:32 PM, Suman Anna <s-anna@ti.com> wrote:
>> Is this the validation you mentioned which requires the existence of
>> "hwspinlock/core: maintain a list of registered hwspinlock banks" ?
>
> Well, not exactly. The validation is on the following segment,
>
> +       id = of_hwspin_lock_simple_xlate(bank, &args);
> +       if (id < 0 || id >= bank->num_locks) {
> +               ret = -EINVAL;
> +               goto out;
> +       }

I'm not entirely convinced that this justifies adding the proposed
linked list. Can't we can get the base_id and number of locks by
traversing the DT?

> That said, it is also needed to provide the support for deferred probing
> without changing the return code conventions on the existing API.

Here too, adding a data structure maintaining memory objects and
taking care of it life cycle seems a bit overkill for anything to do
with return values.

> Yes, and wouldn't that require that the id is validated? It just cannot
> return any return value, and expect it will be verified somewhere else
> or in a following API call. Not doing the validation unnecessarily
> complicates the system usage of a lock as you are sharing an invalid
> lock to a remote processor and then you have two validation failure
> paths on different processors.

Validation is great but I'm still not convinced it can't be done
without maintaining another data structure.

Please show me specific technical issues that can't be resolved
without adding the proposed linked list.

Thanks,
Ohad.

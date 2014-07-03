Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbaGCHQB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 03:16:01 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:53797 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbaGCHP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 03:15:59 -0400
MIME-Version: 1.0
X-Originating-IP: [89.139.36.201]
In-Reply-To: <53B47626.4040506@ti.com>
References: <1398904476-26200-1-git-send-email-s-anna@ti.com>
 <1398904476-26200-5-git-send-email-s-anna@ti.com> <CAK=WgbbZvBLT7U638fBfPjF7-MJaP=4WJcrT_fEg6Uu3cXRAyg@mail.gmail.com>
 <53B47626.4040506@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 3 Jul 2014 10:15:38 +0300
Message-ID: <CAK=WgbbJ6a17wrsEcvNq6tPiaciQ=E+22QE06t9EA8RFqicNRg@mail.gmail.com>
Subject: Re: [PATCHv5 04/15] hwspinlock/core: add common OF helpers
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
>> Do we have a use case today that require the xlate() method?
>>
>> If not, let's remove it as we could always add it back if some new
>> hardware shows up that needs it.
>
> The xlate() method is to support the phandle + args specifier way of
> requesting hwlocks, platform implementations are free to implement their
> own xlate functions, but the above supports the simplest case of
> controller + relative lock index within controller.

Do we have a use case for a different implementation other than the
simplest case? If not, it seems to me this will just become redundant
boilerplate code (every platform will use the simple xlate method).

> This function again is to support the phandle + args specifier way of
> requesting hwlocks, the hwspin_lock_request_specific() is invoked
> internally within this function, so we are still reusing the actual
> request code other than handling the DT parsing portion. If we go back
> to using global locks in client hwlocks property, we don't need a
> of_hwspin_lock_get_id(), the same can be achieved using the existing DT
> function, of_property_read_u32_index().

I think you may have misunderstood me, sorry. I'm ok with the phandle
+ args specifier. I just think we can use it, together with the
base_id property, to infer the global lock id from the DT data. This
is not only a must to support heterogenous multi-processing systems,
it will also substantially simplify the code.

Thanks,
Ohad.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab3JIE7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 00:59:53 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:65429 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab3JIE7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 00:59:48 -0400
MIME-Version: 1.0
In-Reply-To: <20131009034057.GO15065@verge.net.au>
References: <20131008143040.52f36df8edb7ab63224d8433@ops.dti.ne.jp>
	<20131008143403.c11f294c8a1701a2ab3bc5fd@ops.dti.ne.jp>
	<20131009034057.GO15065@verge.net.au>
Date: Wed, 9 Oct 2013 13:59:46 +0900
Message-ID: <CANqRtoQs+31mv0ZULOd3SGshkBkvp-kGoaVOSb10+Ncdp+WNXw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] ARM: shmobile: kzm9d: Use common clock framework
From: Magnus Damm <magnus.damm@gmail.com>
To: Simon Horman <horms@verge.net.au>
Cc: takasi-y@ops.dti.ne.jp, SH-Linux <linux-sh@vger.kernel.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        Mike Turquette <mturquette@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devicetree@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

On Wed, Oct 9, 2013 at 12:40 PM, Simon Horman <horms@verge.net.au> wrote:
> On Tue, Oct 08, 2013 at 02:34:03PM +0900, takasi-y@ops.dti.ne.jp wrote:
>> Use common clock framework version of clock
>>  drivers/clk/shmobile/clk-emev2.c
>> instead of sh-clkfwk version
>>  arch/arm/mach-shmobile/clock-emev2.c
>> when it is configured as a part of multi-platform.
>>
>> Signed-off-by: Takashi Yoshii <takasi-y@ops.dti.ne.jp>
>
> Thanks.
>
> I plan to add this patch to a new topic branch,
> topic/emev2-common-clock, in the renesas tree and
> queue it up from there for inclusion in mainline
> if/when the first patch of this series is accepted
> by Mike Turquette.

Thanks for picking up patches, Simon.

I think you can simply merge this patch after the following series:

[PATCH 00/05] ARM: shmobile: KZM9D Multiplatform update

There are no build time dependencies on patch 1 and 2 so this patch
can be merged independently. Regarding run-time operation, the
multiplatform series above makes KZM9D DT reference only build for
multiplatform, and in such case CCF is required.

So if you want to keep KZM9D DT reference working until Mike Turquette
accepts the CCF bits, then I recommend you to wait with "[PATCH 00/05]
ARM: shmobile: KZM9D Multiplatform update" until all EMEV2 CCF bits
have been merged.

Another way is to merge "[PATCH 00/05] ARM: shmobile: KZM9D
Multiplatform update" before the EMEV2 CCF bits, but if so you may as
well merge this patch as well IMO. This
multiplatform-update-series-merge-before-CCF plan will result in
untestable KZM9D DT reference until EMEV2 CCF is merged. Either way is
fine with me.

Cheers,

/ magnus

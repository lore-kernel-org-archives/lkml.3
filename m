Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab3JAKi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 06:38:27 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:34941 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab3JAKiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 06:38:25 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-ff-524aa600f390
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] x86/geode: fix incorrect placement of __initdata tag
Date: Tue, 01 Oct 2013 12:37:47 +0200
Message-id: <4748759.pZGOv2NGcn@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <20131001065950.GC19718@gmail.com>
References: <18427893.G5JGWn465D@amdc1032> <20131001065950.GC19718@gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t9jQV2GZV5BBluO6FtM2yhucbbpDbvF
	5V1z2CxW/zvFaHHpwAImi82bpjJb/NjwmNWB3WPTqk42j3fnzrF7vN93lc2jb8sqRo/Pm+Q8
	TrR8YQ1gi+KySUnNySxLLdK3S+DK+DzzD3vBUY6KVRfbWBsY37B1MXJySAiYSLx/e5IFwhaT
	uHBvPVCci0NIYDqjxI9bO1ghnBYmiQuTHjOCVLEJWElMbF8FZosIKEks/vKRHaSIWeA4o0Tn
	6lVgY4UFPCXaT24DG8sioCrxftpeVhCbV0BT4tTDB8wgtihQzadJS8FsTgF9iWstTWD1QgK+
	Ei+anrJB1AtK/Jh8DyzOLCAvsW//VFYIW0ti/c7jTBMYBWYhKZuFpGwWkrIFjMyrGEVTC5IL
	ipPScw31ihNzi0vz0vWS83M3MYID/pnUDsaVDRaHGAU4GJV4eA3qPYOEWBPLiitzDzFKcDAr
	ifByL/IKEuJNSaysSi3Kjy8qzUktPsQozcGiJM57oNU6UEggPbEkNTs1tSC1CCbLxMEp1cAY
	zcSwMPHUOafJ1cvDVt7rd5eo3Xz3ys+2+4cfdDdOsfzyfZrBrs40hfd9SikKy/d4ek4T89Z8
	0/XxfQDPvNvufW6+mYHpK3JqZlxoPeRq7O6hrpT0YRKLX9qBBbqqV7qC/e6Hf7d8y/xA6mb+
	C7WjlWVeE+Y89GOU/yFt4Pq8wnt7lMLNHg8lluKMREMt5qLiRAA8TcaydAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday, October 01, 2013 08:59:50 AM Ingo Molnar wrote:
> 
> * Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com> wrote:
> 
> > __initdata tag should be placed between the variable name and equal
> > sign for the variable to be placed in the intended .init.data section.
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  arch/x86/platform/geode/alix.c    | 2 +-
> >  arch/x86/platform/geode/geos.c    | 2 +-
> >  arch/x86/platform/geode/net5501.c | 2 +-
> >  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> Does this fix have any runtime effects, i.e. should we queue this up as an 
> urgent fix for v3.12, or does tip:x86/platform with a v3.13 merge suffice?

It has runtime effects as the data now goes into .init.data which was not
a case previously. However it is not an urgent fix so I think that queuing
it for v3.13 is a better option. Thanks.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics


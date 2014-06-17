Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934074AbaFQRFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 13:05:06 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:27904 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933364AbaFQRFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 13:05:03 -0400
X-AuditID: cbfee61b-b7fbb6d000001be3-cd-53a0753c5204
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mikko Perttunen <mperttunen@nvidia.com>, thierry.reding@gmail.com,
        tj@kernel.org, pdeschrijver@nvidia.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 8/9] ata: Add support for the Tegra124 SATA controller
Date: Tue, 17 Jun 2014 19:04:14 +0200
Message-id: <6652229.bPNq3Yp8If@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <53A0686F.4000303@wwwdotorg.org>
References: <1401881559-18469-1-git-send-email-mperttunen@nvidia.com>
 <1470404.13mIFv0Hnj@amdc1032> <53A0686F.4000303@wwwdotorg.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsVy+t9jAV2b0gXBBnP+81tsenyN1eLYjkdM
	Fpd3zWGz6Pwyi83iwdVpbBaT1k5ltHh1sI3F4ueueSwWv5YfZXTg9Ng56y67x6ZVnWwem5fU
	e/Q2v2Pz+LxJzmPj3NAAtigum5TUnMyy1CJ9uwSujKm/xAv+c1Ucnr6dvYHxCUcXIyeHhICJ
	xOv+X0wQtpjEhXvr2UBsIYFFjBJrloV3MXIB2S1MEn3PF4EVsQlYSUxsX8UIYosIaElMevaP
	EaSIWeA9o8T933/AEsICXhKrfn9iBbFZBFQl2qcdB2vmFdCU2Pt6ITOILSrgKbFj+0qwbZwC
	uhI3V75hhtjWxigx/fI8VogGQYkfk++xgNjMAvIS+/ZPZYWwdST2t05jm8AoMAtJ2SwkZbOQ
	lC1gZF7FKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERwBz6R3MK5qsDjEKMDBqMTDy5G7IFiI
	NbGsuDL3EKMEB7OSCO+5LKAQb0piZVVqUX58UWlOavEhRmkOFiVx3oOt1oFCAumJJanZqakF
	qUUwWSYOTqkGRommDomdKixsV/+4PdiwNnl3NNPqthV/Vxd2qiste6AfpO6+MVXF55miuqbB
	lK/PeWSMV3M0rtjY8tFpg97yzZs52xMPl85POLYwiOe414Qs9zf8XL5bTdQza++eypngcfv9
	89Ylfn7zuUxvsrvbKn2Y8mHZ3yn8y9Yp+K3fvuj6Mf7S+28j5yuxFGckGmoxFxUnAgCWtPlq
	fAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday, June 17, 2014 10:10:23 AM Stephen Warren wrote:
> On 06/17/2014 06:14 AM, Bartlomiej Zolnierkiewicz wrote:

[...]

> >> +static struct platform_driver tegra_ahci_driver = {
> >> +	.probe = tegra_ahci_probe,
> >> +	.remove = ata_platform_remove_one,
> >> +	.driver = {
> >> +		.name = "tegra-ahci",
> >> +		.owner = THIS_MODULE,
> >> +		.of_match_table = tegra_ahci_of_match,
> >> +	},
> > 
> > This driver lacks PM suspend/resume support.  I assume that
> > the Tegra124 platform also doesn't support suspend/resume yet
> > (if so a comment in the driver code about this would be useful),
> > otherwise the driver should be fixed.
> 
> We do have basic system suspend/resume support. However, I don't think
> missing suspend/resume in an individual driver should stop it from being
> merged. It can certainly be added later.

There should be at least FIXME in the driver explaining the situation and
I would really prefer to have PM support added when the driver is still
"hot" (meaning there are people actively working on it) instead of possibly
having to chase people months/years later when they have already moved on
and are working on something else.  Please also note that adding PM support
should be quite simple if the driver is designed correctly.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics


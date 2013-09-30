Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab3I3PbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:31:23 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:21755 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557Ab3I3PbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:31:20 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-3f-52499947f018
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] ARM: shmobile: ape6evm: fix incorrect placement of
 __initdata tag
Date: Mon, 30 Sep 2013 17:31:08 +0200
Message-id: <1556252.bjXjV3hKBt@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1800955.Mbr9gmJOD4@avalon>
References: <26068642.Hn7T63a6ac@amdc1032> <1800955.Mbr9gmJOD4@avalon>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsVy+t9jQV33mZ5BBv0zpC2at35ltDjb9Ibd
	onPiEnaLTY+vsVpc3jWHzWLOnynMFg9Wv2VzYPfYOesuu8fsjpmsHpuX1Hv0bVnF6DHn5zcW
	j8+b5ALYorhsUlJzMstSi/TtErgy9j96xlZwhrei8dcZxgbGfu4uRk4OCQETiRsPjjBD2GIS
	F+6tZ+ti5OIQEpjOKHHj3m9WCKeFSeLh6UlsIFVsAlYSE9tXMYLYIgIWEr2LpjOCFDELXGeU
	2HN5MlhCWCBC4t2dbqAGDg4WAVWJ/SvANvAKaEr8WHabHcQWFfCU+DRpKVicU0BD4seBGywg
	tpCAm8SMo8uh6gUlfky+BxZnFpCX2Ld/KiuErSWxfudxpgmMArOQlM1CUjYLSdkCRuZVjKKp
	BckFxUnpuYZ6xYm5xaV56XrJ+bmbGMHh/kxqB+PKBotDjAIcjEo8vAb1nkFCrIllxZW5hxgl
	OJiVRHhfTwAK8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Qah0oJJCeWJKanZpakFoEk2Xi4JRq
	YCzc+J3RtL7joYCBHcMy9v4Op9jlf2rmbQgsC65+nHjvRT9LhWzPvLV7yv9Nq9RLYr68QEKD
	OzTC87p+gpyWz8xVG6Sc1Gp2rJd6eYpnZ/Pi1JZndxycfzTKPjlR+0XkTG/tHQ4ua5s5ibvd
	XzEdE+5+Znj8ca5F2K4nfx5X6r+YvN1jhu4HTSWW4oxEQy3mouJEAMWpfAxzAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday, September 30, 2013 05:05:37 PM Laurent Pinchart wrote:
> Hi Bartlomiej,
> 
> Thank you for the patch.
> 
> On Monday 30 September 2013 15:07:47 Bartlomiej Zolnierkiewicz wrote:
> > __initdata tag should be placed between the variable name and equal
> > sign for the variable to be placed in the intended .init.data section.
> > 
> > In this particular case __initdata is incorrect as ape6evm_keys_pdata
> > can be used as a platform data for gpio-keys driver which can be
> > compiled as module.
> 
> A pointer to the ape6evm_keys_pdata structure is passed to the 
> platform_device_register_data() function, which makes a copy of the structure. 
> Marking it as __initdata is thus correct.

Thanks for catching this. I'll fix the patch and post v2.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  arch/arm/mach-shmobile/board-ape6evm.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm/mach-shmobile/board-ape6evm.c
> > b/arch/arm/mach-shmobile/board-ape6evm.c index 7627385..8954f55 100644
> > --- a/arch/arm/mach-shmobile/board-ape6evm.c
> > +++ b/arch/arm/mach-shmobile/board-ape6evm.c
> > @@ -86,7 +86,7 @@ static struct gpio_keys_button gpio_buttons[] = {
> >  	GPIO_KEY(KEY_VOLUMEDOWN,	329,	"S21"),
> >  };
> > 
> > -static struct __initdata gpio_keys_platform_data ape6evm_keys_pdata = {
> > +static struct gpio_keys_platform_data ape6evm_keys_pdata = {
> >  	.buttons	= gpio_buttons,
> >  	.nbuttons	= ARRAY_SIZE(gpio_buttons),
> >  };


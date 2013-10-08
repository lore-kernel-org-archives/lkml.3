Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab3JHRk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 13:40:56 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:28606 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756520Ab3JHRkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 13:40:52 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-66-525443a385b8
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] thermal: offer TI thermal support only when ARCH_OMAP2PLUS
 is defined
Date: Tue, 08 Oct 2013 19:40:48 +0200
Message-id: <4296924.z1ntgL0xa6@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1830886.95xXFHTq6V@amdc1032>
References: <3702969.8rn3SOscJE@amdc1032> <52542E42.5090805@ti.com>
 <1830886.95xXFHTq6V@amdc1032>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsVy+t9jAd3FziFBBtdniFv8nXSM3WLN/p9M
	Fmeb3rBbXN41h83ic+8RRosnD/vYHNg8fv+axOixeM9LJo++LasYPY7f2M7k8XmTXABrFJdN
	SmpOZllqkb5dAlfG8a8LGQvWc1Y035/B1sB4gL2LkZNDQsBE4uLyuVC2mMSFe+vZuhi5OIQE
	FjFKTPg1nwUkISTQwiRxZVs4iM0mYCUxsX0VI4gtIqAncePFEyaQBmaBlYwSO7pOgk0SFoiR
	mHagFSjBwcEioCrxod0ZJMwroCmxZ04f2ExRAU+JT5OWMoPYnAJaEo++/AIrFxJIlri+2Aqi
	XFDix+R7YOXMAvIS+/ZPZYWwdST2t05jm8AoMAtJ2SwkZbOQlC1gZF7FKJpakFxQnJSea6RX
	nJhbXJqXrpecn7uJERzYz6R3MK5qsDjEKMDBqMTD+4A/JEiINbGsuDL3EKMEB7OSCK+JLFCI
	NyWxsiq1KD++qDQntfgQozQHi5I478FW60AhgfTEktTs1NSC1CKYLBMHp1QDY+by1TWPD9kL
	JKycyn51n8/n32a7z8gaWa3wnhjwIT7nvv4W91BZi0Olx29nbDyUJbiX48JHzsfc724+nCri
	5uCWnt/xZxfDM6Nvct+itWKddgZP7V+y9m2iQaT1rJKTGT96dxjNL/6Q+EjOOrBPO0Tjq5Fh
	qpva6mdvT36Xcn/+bP/0imPrliixFGckGmoxFxUnAgBX/UIAaAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 08, 2013 06:59:19 PM Bartlomiej Zolnierkiewicz wrote:

[...]

> > Restricting drivers to be compiled to specific architecture is a poor
> > design strategy. Specifically, on the TI Bandgap device driver, as I
> > already mentioned to you, this is again clear, as it is currently used
> > on different archs, and the code can be easily reused when other archs,
> > different than DRA and OMAP, need it.
> 
> It is the correct strategy to restrict hardware specific device drivers
> (i.e. ARM Exynos thermal driver) to be compiled only for hardware that
> it is available on (i.e. ARM Exynos SoCs). If TI bandgap driver is not
> hardware specific and can be used on non TI hardware than you're of
> course right.

Just small addition. We are not using TI bandgap IP in any current ARM
Samsung SoCs so TI bandgap IP support should not be available on them
(=> we should not use ARCH_HAS_BANDGAP at all, usage for EXYNOS_THERMAL
is incorrect as I already explained in previous mail).

OTOH archs/SoCs that are using such IP can select ARCH_HAS_BANDGAP freely.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics


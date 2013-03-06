Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120Ab3CFG2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 01:28:36 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:35932 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758621Ab3CFG2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 01:28:30 -0500
X-AuditID: cbfee68d-b7f636d0000009be-d9-5136e20c91a4
Date: Wed, 06 Mar 2013 06:28:13 +0000 (GMT)
From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: Re: [PATCH 05/32] lib: devres: don't enclose pcim_*() functions in
 CONFIG_HAS_IOPORT
To: Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Eran Ben-Avi <benavi@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jingoo Han <jg1.han@samsung.com>
Reply-to: jg1.han@samsung.com
MIME-version: 1.0
X-MTR: 20130306062714220@jg1.han
Msgkey: 20130306062714220@jg1.han
X-EPLocale: en_US.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130306062714220@jg1.han
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: Y
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <17540873.418471362551288113.JavaMail.weblogic@epml07>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJsWRmVeSWpSXmKPExsVy+t8zY12eR2aBBmuWyFlc3jWHzYHR4/Mm
	uQDGqAZGm8Si5IzMslSF1Lzk/JTMvHRbpdAQN10LJYWM/OISW6VoIwNjPSNTEz0jE3M9S4NY
	KyNTJYW8xNxUW6UKXaheJYWi5AKg2tzKYqABOal6UHG94tS8FIes/FKQS/SKE3OLS/PS9ZLz
	c5UUyhJzSoFGKOknTGXMOHv3OnPBM96KPatbGBsYt/B2MXJyCAkoSUw6uZexi5GDQ0LAROLq
	6xSQsISAmMSFe+vZuhi5gEqWMUrMvzuLHSJhIrFr4iVmiMR8RollfcdZQBIsAioSE66+ZQWx
	2QTUJSb8bgaLCwskSqxc2wcWFxGIl3hw/TMTSDOzwAN2iUVTPzBCXCErcW/ybGYQm1dAUOLk
	zCcsEBcpSPQtyoEIK0pcWPWZFeIICYk79/dD2bwSM9qfskDYchLTvq5hhrClJc7P2sAI883i
	74+h4vwSx27vYIIYzyvx5H4wzJjdm7+wQdgCElPPHIRqVZVYeH8f1Co+iTUL30KtEpQ4fa2b
	Gaa3YeNvcPgwA505pfshlK0l8eXHPjZUX4HYThL9p3exTWBUnoUkNQtJ+ywk7chqFjCyrGIU
	TS1ILihOSi8yRI7sTYyQNNi7g/H2AetDjPsZgXEykVlKNDkfmEjzSuINjY1NzExMTcwtTc1N
	KRA2NzI1AKZUA0PqCCuJ88pdkgkUEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwLj/9detoXfl
	68QWR794KnHJcloPmwffBHuTPWwTV7yY2h33pthF78xKi6nn0v0rmf3+zm60TFi7fjfj0Q3a
	b3msklIZzuw7eHtGi1jmnfBN4WviTx6fs3qqie8MqdPTMlct+ZTQ8mPJSdOu81Z1XH/tLgj+
	uxI3qzC4pGKjUGT0NL4Q3unByWVKLMUZiYZazEXFiQAvpC5E9gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42I5/e/2dF2eR2aBBvd+SFhc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz1jy1grQwMDI1OgqoSM
	jLN3rzMXPOOt2LO6hbGBcQtvFyMnh5CAksSkk3sZQWwJAROJXRMvMUPYYhIX7q1n62LkAqqZ
	zyixrO84C0iCRUBFYsLVt6wgNpuAusSE381gcWGBRImVa/vA4iIC8RIPrn9mAmlmFnjALrFo
	6gdGiG2yEvcmzwbbwCsgKHFy5hOgZg6gbQoSfYtyIMKKEhdWfWaFOEJC4s79/VA2r8SM9qcs
	ELacxLSva6AOlZY4P2sDI8zRi78/horzSxy7vYMJYjyvxJP7wTBjdm/+wgZhC0hMPXMQqlVV
	YuH9fVCr+CTWLHwLtUpQ4vS1bmaY3oaNv9lBbGagM6d0P4SytSS+/NjHhuorENtJov/0LrYJ
	jHKzkKRmIWmfhaQdWc0CRpZVjKKpBckFxUnpFUZ6xYm5xaV56XrJ+bmbGMEp6tmiHYz/zlsf
	YhTgYFTi4Z2gYhYoxJpYVlyZe4hRgoNZSYSX6wxQiDclsbIqtSg/vqg0J7X4EGMyMAInMkuJ
	JucD02deSbyhsbGJmYmpuYGFgaU5acJK4rxbrNUDhQTSE0tSs1NTC1KLYLYwcXBKNTDKVxr/
	fM2x5YOL2GH38tN7p63/Vy7JtTz2RZJn4lHbziTxkO8n04ozj1ofXZzbK5Gfc+bwRy2ljgvH
	g63v7Th/o08zzbR7c3dxzuJLAW9tktZ2+0wSenbZnSF7Xc/6u/U62pYdIaIXUr1mVT5Z2rR4
	2SS9/Ld39B5ObvXN0829s7bNQvdMNo8SS3FGoqEWc1FxIgBi2vEMlQMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r266SiYP011860

On Tuesday, March 05, 2013 5:30 AM, Arnd Bergmann wrote:
> 
> On Monday 04 March 2013, Thomas Petazzoni wrote:
> > FWIW, a patch that is doing what I was initially proposing has been
> > merged for 3.9, and it doesn't contain the
> > IS_ENABLED(CONFIG_HAS_IOPORT) test you were proposing (and which I
> > think was correct). See:
> >
> > commit 9ed8a30f3471347c1b763bd062fa78ae80f18eae
> > Author: Jingoo Han <jg1.han@samsung.com>
> > Date:   Wed Feb 27 17:02:42 2013 -0800
> >
> 
> Sigh.
> 
> I'll take it as an additional incentive to finally clean up the logic behind
> CONFIG_HAS_IOPORT by introducing a CONFIG_HAS_IOPORT_MAP symbol to replace it.
> 
> Thanks for the heads up.


Hi Thomas Petazzoni
Sorry, I did not know that you submitted the patch.
Like you, I am developing PCIe Host driver.
Also, I experienced the annoying build error related to
CONFIG_HAS_IOPORT.

Hi Arnd Bergmann,
I have just read the mailing thread.
If you resolve this situation properly, it will be very helpful.
Thank you.

Best regards,
Jingoo Han

> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•

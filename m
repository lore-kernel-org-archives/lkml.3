Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbaBWXdX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 18:33:23 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:14817 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbaBWXdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 18:33:21 -0500
X-AuditID: cbfee68e-b7f566d000002344-36-530a853fa3d0
Date: Sun, 23 Feb 2014 23:33:19 +0000 (GMT)
From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [patch 07/26] pci: pcie-designware: Remove irq_desc abuse
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Mohit Kumar <mohit.kumar@st.com>,
        pci <linux-pci@vger.kernel.org>, Jingoo Han <jg1.han@samsung.com>
Reply-to: jg1.han@samsung.com
MIME-version: 1.0
X-MTR: 20140223233259179@jg1.han
Msgkey: 20140223233259179@jg1.han
X-EPLocale: en_US.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140223233259179@jg1.han
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: Y
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <21860356.103351393198399120.JavaMail.weblogic@epml01>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJsWRmVeSWpSXmKPExsVy+t8zA137Vq5gg8//9S0u75rD5sDo8XmT
	XABjVAOjTWJRckZmWapCal5yfkpmXrqtUmiIm66FkkJGfnGJrVK0kYGxnpGpiZ6RibmepUGs
	lZGpkkJeYm6qrVKFLlSvkkJRcgFQbW5lMdCAnFQ9qLhecWpeikNWfinIJXrFibnFpXnpesn5
	uUoKZYk5pUAjlPQTpjJm9G5MKWgSqDh1qpmpgfEEfxcjJ4eQgJLEpJN7GUFsCQETif4j05gh
	bDGJC/fWs3UxcgHVLGOU2N7yjB2m6M/934wQifmMEh/+32cCSbAIqErcWHOKFcRmE1CXmPC7
	mQXEFhZwkzj5dRfYVBGBYIkdLdvAbGaBZ4wSLdcKIa6Qlbg3eTZYnFdAUOLkzCcsEMsUJF4/
	vgYVV5S48uAGE0RcQuLO/f2sEDavxIz2p1D1chLTvq6B+kBa4vysDYww3yz+/hgqzi9x7PYO
	oDkcYL1P7gfDjNm9+QsbhC0gMfXMQahWVYmXNz9CtfJJrFn4FmqVoMTpa93MML0NG3+zQ7yl
	KDGl+yGUrSXx5cc+NnRv8Qo4SRzf84xlAqPyLCSpWUjaZyFpR1azgJFlFaNoakFyQXFSepER
	cmRvYoSkwb4djDcPWB9i3M8IjJOJzFKiyfnARJpXEm9obGZkYWpiamxkbmlGobCJqYWFiRFV
	hJXEeRc9TAoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwLj0XV2QJHO4x0UudqZTN/eemP5Z
	45cB97v+Wx53p944s3l+jvPDfZ7XinNErR1maV0o9pde8fvKnCrr7LWC9sEaJ7q/d21vlr//
	9JDOBqt137/t+7/n32UpZ8kpud/nOdecWuJUZH276nWT4AyNa8YzZ1zybH7EbaO8TLRgctYj
	210Lp53xKwhXYinOSDTUYi4qTgQADci0T/YDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e/2dF37Vq5gg/sXdCwu75rD5sDo8XmT
	XABjVIZNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrSRgbGekamJnpGxgZ6xZayVoYGBkSlQVUJG
	Ru/GlIImgYpTp5qZGhhP8HcxcnIICShJTDq5lxHElhAwkfhz/zeULSZx4d56ti5GLqCa+YwS
	H/7fZwJJsAioStxYc4oVxGYTUJeY8LuZBcQWFnCTOPl1FzOILSIQLLGjZRuYzSzwjFGi5Voh
	xDJZiXuTZ4PFeQUEJU7OfMICsUxB4vXja1BxRYkrD24wQcQlJO7c388KYfNKzGh/ClUvJzHt
	6xpmCFta4vysDXBHL/7+GCrOL3Hs9g6gORxgvU/uB8OM2b35CxuELSAx9cxBqFZViZc3P0K1
	8kmsWfgWapWgxOlr3cwwvQ0bf7NDvKUoMaX7IZStJfHlxz42dG/xCjhJHN/zjGUCo9wsJKlZ
	SNpnIWlHVrOAkWUVo2hqQXJBcVJ6haFecWJucWleul5yfu4mRnCCerZwB+OX89aHGAU4GJV4
	eCWquYKFWBPLiitzDzFKcDArifDWlAGFeFMSK6tSi/Lji0pzUosPMSYDI3Ais5Rocj4weeaV
	xBsaG5uYmZiaG1gYWJqTJqwkznv3ZlKQkEB6YklqdmpqQWoRzBYmDk6pBkbJb84P67MbMq0u
	7E1VXthj3nTGbesO32/Sb5NaaqcJykQmfi/yfaf3InLzksYTmlubEht67XOTvhTq+W7u3dQb
	P3tLS2rWqqmONrc1Vj31jniUwS50qsOhQjrh+rKfig+nZvyIUyx6mMWi7Rnz4X3fmvr5NU5n
	/2yVOvF+9r42xsK1i66XMSmxFGckGmoxFxUnAgDa2zQwlAMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1NNXT0T010372

On Monday, February 24, 2014 6:40 AM, Thomas Gleixner wrote:
> 
> There is no reason to care about irq_desc in that context, escpecially
> as irq_data for that interrupt is retrieved as well.
> 
> Use the proper accessor for the msi descriptor
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Jingoo Han <jg1.han@samsung.com>
> Cc: Mohit Kumar <mohit.kumar@st.com>
> Cc: pci <linux-pci@vger.kernel.org>

Acked-by: Jingoo Han <jg1.han@samsung.com>

A few days ago, I noticed that irq_data_get_msi() can be used.
However, I did not submit the same patch. I really appreciate
your patch. :-)

Best regards,
Jingoo Han

> ---
>  drivers/pci/host/pcie-designware.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> Index: tip/drivers/pci/host/pcie-designware.c
> ===================================================================
> --- tip.orig/drivers/pci/host/pcie-designware.c
> +++ tip/drivers/pci/host/pcie-designware.c
> @@ -294,14 +294,12 @@ no_valid_irq:
>  static void clear_irq(unsigned int irq)
>  {
>  	unsigned int pos, nvec;
> -	struct irq_desc *desc;
>  	struct msi_desc *msi;
>  	struct pcie_port *pp;
>  	struct irq_data *data = irq_get_irq_data(irq);
> 
>  	/* get the port structure */
> -	desc = irq_to_desc(irq);
> -	msi = irq_desc_get_msi_desc(desc);
> +	msi = irq_data_get_msi(data);
>  	pp = sys_to_pcie(msi->dev->bus->sysdata);
>  	if (!pp) {
>  		BUG();ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•

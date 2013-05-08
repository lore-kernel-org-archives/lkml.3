Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab3EHX1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 19:27:20 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25602 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab3EHX1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 19:27:18 -0400
X-AuditID: cbfee68f-b7f066d000003683-3e-518adf543384
Date: Wed, 08 May 2013 23:27:16 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: Fwd: [PATCH v2] MIPS: Make virt_to_phys() work for all unmapped
 addresses.
To: David Daney <ddaney.cavm@gmail.com>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>
Cc: Jiang Liu <liuj97@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130508232513655@eunb.song
Msgkey: 20130508232513655@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130508232513655@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <20691271.332801368055634504.JavaMail.weblogic@epml11>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+Znm7I/a5Ag1v7TS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGhy75gibmiq/XDrA3MH5h6mLk5BASUJFo+f+dsYuRg0NCwETi
	3Ts5kLCEgJjEhXvr2boYuYBKljFK7PnWyAKRMJFo2HSKHSIxn1Fi/bk5jCAJFqBBTz8eYQax
	2QS0Jd5+ecAKYgsLBEt0X5vACNIgIjCZUeLt5ZdgCWaBXkaJ5/ctIK6Ql5h8+jI7iM0rIChx
	cuYTqG1KEhfvP2WGiCtLbPn9lxEiLiExa/oFVgibV2JG+1OoejmJaV/XMEPY0hLnZ21ghHln
	8ffHUHF+iWO3dzBBfMwr8eR+MMyY3Zu/sEHYAhJTzxyEalWX6Pv3gQnC5pNYs/AtC8yYXaeW
	M8P03t8ylwniLUWJKd0P2SFsLYkvP/axoXqLA8h2knj9MGYCo/IsJJlZSLpnIelGVrOAkWUV
	o2hqQXJBcVJ6kbFecWJucWleul5yfu4mRkhS6N/BePeA9SHGZGCUTGSWEk3OByaVvJJ4Q2Mz
	IwtTE1NjI3NLM9KElcR51VqsA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUw5s2Y37fXKfzG
	6luz9S5/i9y1PVPkfPC0d7MtX8j15xjHTjXr/Xe5cMLm1YcCA7bsblr8sKecv0hg7f5LrQnJ
	Ws3Ftww9v568lesuEnzRSjP5vb+NYIbvDhXZb4bBq5in3Phs0bXwqLjAyhoVmX3Munwz459Y
	JmQy5e1s1uKvteC4c/qH3UkOJZbijERDLeai4kQA13hNhyADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e/2TN2Q+12BBm87jC0u75rD5sDo8XmT
	XABjVIZNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrSRgbGekamJnpGxgZ6JQayVoYGBkSlQVUJG
	xocu+YIm5oqv1w6wNzB+Yepi5OQQElCRaPn/nRHElhAwkWjYdIodwhaTuHBvPVsXIxdQzXxG
	ifXn5oAVsQA1PP14hBnEZhPQlnj75QEriC0sECzRfW0CI0iDiMBkRom3l1+CJZgFehklnt+3
	gNgmLzH59GWwDbwCghInZz5hgdimJHHx/lNmiLiyxJbff6EukpCYNf0CK4TNKzGj/SlUvZzE
	tK9rmCFsaYnzszYwwly9+PtjqDi/xLHbO4C+5ADrfXI/GGbM7s1f2CBsAYmpZw5CtapL9P37
	wARh80msWfiWBWbMrlPLmWF672+ZywTxlqLElO6H7BC2lsSXH/vYUL3FAWQ7Sbx+GDOBUW4W
	kswsJN2zkHQjq1nAyLKKUTS1ILmgOCm9wkSvODG3uDQvXS85P3cTIzhBPVuyg7HhgvUhRgEO
	RiUe3ozErkAh1sSy4srcQ4wSHMxKIrx3W4FCvCmJlVWpRfnxRaU5qcWHGJOBETiRWUo0OR+Y
	PPNK4g2NDYwNDS3NDUwNjSxIE1YS533Wah0oJJCeWJKanZpakFoEs4WJg1OqgdFT8FnSwVPV
	zkv+bt4tGLDlsmW1CAvjmc1G+84HMbiuUghi16wpSl+7ctH20uj8F3N5nqd+mvniTsDJ5U+N
	JvRaGoXoHzKeJy8c+a/pfJJ/Rrvh5Vs89VGCz5aV3+r53b4jZYZizlKRJ6+On/5e1HPm1LbX
	6teM5H2OM5TUOBVe036z7sFEiV4lluKMREMt5qLiRADdPpH0lAMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r48NRXBg012534

> From: David Daney 

> This one appears to build against Linus' tree.

> This could also fix problems noted by Eunbong Song with the
> free_initmem_default() call.

I tested your patch, And i confirmed your patch fixes panic at free_initmem_default() problem.
Thanks. ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•

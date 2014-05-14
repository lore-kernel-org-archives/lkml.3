Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbaENDJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 23:09:37 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:43737 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751958AbaENDJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 23:09:36 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: Neil Zhang <zhangwm@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>
Date: Tue, 13 May 2014 20:09:10 -0700
Subject: RE: [PATCH] ARM64: kernel: add compatable cpuinfo
Thread-Topic: [PATCH] ARM64: kernel: add compatable cpuinfo
Thread-Index: Ac9vIJjY0Svxvh0ZTzWWwjJzx2WyhgAASzAQ
Message-ID: <9034CBD80F070943B59700D7F8149ED9A0875740@SC-VEXCH4.marvell.com>
References: <1400036398-16591-1-git-send-email-zhangwm@marvell.com>
In-Reply-To: <1400036398-16591-1-git-send-email-zhangwm@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-13_07:2014-05-13,2014-05-13,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1405140042
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4E39fHh001984


> -----Original Message-----
> From: Neil Zhang [mailto:zhangwm@marvell.com]
> Sent: 2014Äê5ÔÂ14ÈÕ 11:00
> To: linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> Cc: catalin.marinas@arm.com; will.deacon@arm.com; Neil Zhang
> Subject: [PATCH] ARM64: kernel: add compatable cpuinfo
> 

Fix typo in version 2.

> Print the necessary features in order to be backwards compatable with
> ARMv7 and earlier version.
> 
> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> ---
>  arch/arm64/kernel/setup.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c index
> 7ec7846..a09ecfe 100644
> --- a/arch/arm64/kernel/setup.c
> +++ b/arch/arm64/kernel/setup.c
> @@ -451,6 +451,11 @@ static int c_show(struct seq_file *m, void *v)
>  		if (elf_hwcap & (1 << i))
>  			seq_printf(m, "%s ", hwcap_str[i]);
> 
> +#ifdef CONFIG_COMPAT
> +	seq_puts(m, "half thumb fastmult edsp tls vfp vfpv3 vfpv4 neon ");
> +	seq_puts(m, "idiva idivt ");
> +#endif
> +
>  	seq_printf(m, "\nCPU implementer\t: 0x%02x\n", read_cpuid_id() >>
> 24);
>  	seq_printf(m, "CPU architecture: AArch64\n");
>  	seq_printf(m, "CPU variant\t: 0x%x\n", (read_cpuid_id() >> 20) & 15);
> --
> 1.7.9.5

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

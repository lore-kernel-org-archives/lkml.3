Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbaLEJ3v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 04:29:51 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:58993 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaLEJ3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 04:29:48 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sB59Rs5p027730, This message is accepted by code: ctloc85258
From: =?gb2312?B?vrTI8Q==?= <micky_ching@realsil.com.cn>
To: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "chris@printf.net" <chris@printf.net>,
        "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "rogerable@realtek.com" <rogerable@realtek.com>,
        =?gb2312?B?zfXsvw==?= <wei_wang@realsil.com.cn>
Subject: Re: [PATCH v4 1/6] mfd: rtsx: add func to split u32 into register
Thread-Topic: [PATCH v4 1/6] mfd: rtsx: add func to split u32 into register
Thread-Index: AQHQEE+fRoR/oTBMgUiwD+7H/IHqKZyANMIA
Date: Fri, 5 Dec 2014 09:27:54 +0000
Message-ID: <54817A9A.8000809@realsil.com.cn>
References: <cover.1417758564.git.micky_ching@realsil.com.cn>
 <17ba65f4bdf4707bdf038e407ecf5dc012bca281.1417758564.git.micky_ching@realsil.com.cn>
In-Reply-To: <17ba65f4bdf4707bdf038e407ecf5dc012bca281.1417758564.git.micky_ching@realsil.com.cn>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.29.41.103]
Content-Type: text/plain; charset="gb2312"
Content-ID: <80132F540AB57546BCC5C34474FE52E4@realsil.com.cn>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sB5EEMgG011937

Hi Lee,

this patch can be applied if you think it is ok, it doesn't depends 
other patches.

regards.
micky.
On 12/05/2014 01:54 PM, micky_ching@realsil.com.cn wrote:
> From: Micky Ching <micky_ching@realsil.com.cn>
>
> Add helper function to write u32 to registers, if we want to put u32
> value to 4 continuous register, this can help us reduce tedious work.
>
> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> ---
>   include/linux/mfd/rtsx_pci.h | 9 +++++++++
>   1 file changed, 9 insertions(+)
>
> diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
> index 74346d5..9234449 100644
> --- a/include/linux/mfd/rtsx_pci.h
> +++ b/include/linux/mfd/rtsx_pci.h
> @@ -558,6 +558,7 @@
>   #define SD_SAMPLE_POINT_CTL		0xFDA7
>   #define SD_PUSH_POINT_CTL		0xFDA8
>   #define SD_CMD0				0xFDA9
> +#define   SD_CMD_START			0x40
>   #define SD_CMD1				0xFDAA
>   #define SD_CMD2				0xFDAB
>   #define SD_CMD3				0xFDAC
> @@ -967,4 +968,12 @@ static inline u8 *rtsx_pci_get_cmd_data(struct rtsx_pcr *pcr)
>   	return (u8 *)(pcr->host_cmds_ptr);
>   }
>   
> +static inline void rtsx_pci_write_be32(struct rtsx_pcr *pcr, u16 reg, u32 val)
> +{
> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg,     0xFF, val >> 24);
> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 1, 0xFF, val >> 16);
> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 2, 0xFF, val >> 8);
> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 3, 0xFF, val);
> +}
> +
>   #endif
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

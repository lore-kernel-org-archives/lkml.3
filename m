Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab3EHFQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 01:16:53 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:9756 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751088Ab3EHFQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 01:16:51 -0400
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT003.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: PS-6(zz98dI936eI1432I13e6Kzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2fh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Qiaowei Ren <qiaowei.ren@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        Xiaoyan Zhang <xiaoyan.zhang@intel.com>, Gang Wei <gang.wei@intel.com>
Subject: Re: [PATCH 3/4] driver: provide sysfs interfaces to access TXT log
Thread-Topic: [PATCH 3/4] driver: provide sysfs interfaces to access TXT log
Thread-Index: AQHOSvE9bxnf/3s/7UWUo8Zw/n8iKpj6wJAA
Date: Wed, 8 May 2013 05:16:43 +0000
Message-ID: <1367990202.2425.26.camel@x230>
References: <1367938519-840-1-git-send-email-qiaowei.ren@intel.com>
	 <1367938519-840-4-git-send-email-qiaowei.ren@intel.com>
In-Reply-To: <1367938519-840-4-git-send-email-qiaowei.ren@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <61966D219BF4B646874C4D67E97F1619@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r485GwKi007194

On Tue, 2013-05-07 at 22:55 +0800, Qiaowei Ren wrote:

> +What:		/sys/devices/platform/intel_txt/log/log_header
> +Date:		May 2013
> +KernelVersion:	3.9

How different are these logs to the TPM measurements exported via
securityfs?

> +What:		/sys/devices/platform/intel_txt/log/block_index
> +Date:		May 2013
> +KernelVersion:	3.9
> +Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
> +Description:	The "block_index" property allows you to set the block
> +		index for output.

So I write a value here and then I see different chunks of log? This
doesn't seem like an optimal interface. What do these logs actually
contain? How do I know which block I should be reading?

> +static int are_uuids_equal(const struct uuid *uuid1,
> +			   const struct uuid *uuid2)
> +{
> +	return (memcmp(uuid1, uuid2, sizeof(*uuid1)) == 0) ? 1 : 0;
> +}

Use one of the uuidcmp functions from uuid.h?

> +EXPORT_SYMBOL_GPL(sysfs_create_log);
> +
> +MODULE_LICENSE("GPL");

Same as for the previous patch - you don't need these.

> +struct uuid {
> +	uint32_t data1;
> +	uint16_t data2;
> +	uint16_t data3;
> +	uint16_t data4;
> +	uint8_t  data5[6];
> +} __packed;

There's already UUID structures in uuid.h

> +#define TBOOT_LOG_UUID		{0xc0192526, 0x6b30, 0x4db4, 0x844c, \
> +				{0xa3, 0xe9, 0x53, 0xb8, 0x81, 0x74} }

uuid.h again.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab3EIMCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 08:02:25 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:27269 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751260Ab3EIMCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 08:02:23 -0400
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT005.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: PS-3(zz98dIc89bh936eI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275dhz2fh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "Ren, Qiaowei" <qiaowei.ren@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "Wei, Gang" <gang.wei@intel.com>
Subject: Re: [PATCH 3/4] driver: provide sysfs interfaces to access TXT log
Thread-Topic: [PATCH 3/4] driver: provide sysfs interfaces to access TXT log
Thread-Index: AQHOSvE9bxnf/3s/7UWUo8Zw/n8iKpj6wJAAgAG87bCAAEa7AA==
Date: Thu, 9 May 2013 12:02:18 +0000
Message-ID: <1368100938.2425.36.camel@x230>
References: <1367938519-840-1-git-send-email-qiaowei.ren@intel.com>
	 <1367938519-840-4-git-send-email-qiaowei.ren@intel.com>
	 <1367990202.2425.26.camel@x230>
	 <9E0BE1322F2F2246BD820DA9FC397ADE9A9BD2@SHSMSX102.ccr.corp.intel.com>
In-Reply-To: <9E0BE1322F2F2246BD820DA9FC397ADE9A9BD2@SHSMSX102.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6D4AA352115FF9489380276ACF93B1C4@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r49C2URs014985

On Thu, 2013-05-09 at 08:05 +0000, Ren, Qiaowei wrote:
> On 2013-05-08, Matthew Garrett wrote:
> > How different are these logs to the TPM measurements exported via
> > securityfs?
> 
> These logs come from tboot (Trusted Boot, an open source, pre-kernel/VMM module that uses IntelÂ® Trusted Execution Technology (IntelÂ® TXT) to perform a measured and verified launch of an OS kernel/VMM.), and should be different from those TPM measurements (from BIOS?) exported via security.

Different in what way? What are they actually logging?

> > So I write a value here and then I see different chunks of log? This
> > doesn't seem like an optimal interface. What do these logs actually
> > contain? How do I know which block I should be reading?
> 
> Yes. Since total log size is bigger than one page 4K, the log have to be displayed in 4K-block indexed by block_index.
> These logs will be very helpful for txt related debugging.

If they're only intended for debugging then sysfs probably isn't the
best place for them. debugfs might make more sense.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

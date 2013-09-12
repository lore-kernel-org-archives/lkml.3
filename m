Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab3ILOgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:36:54 -0400
Received: from [207.46.163.235] ([207.46.163.235]:29384 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752489Ab3ILOgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:36:52 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Borislav Petkov <bp@alien8.de>
CC: Dave Young <dyoung@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "zohar@linux.vnet.ibm.com" <zohar@linux.vnet.ibm.com>,
        "d.kasatkin@samsung.com" <d.kasatkin@samsung.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>
Subject: Re: [PATCH 15/16] bootparam: Pass acpi_rsdp pointer in bootparam
Thread-Topic: [PATCH 15/16] bootparam: Pass acpi_rsdp pointer in bootparam
Thread-Index: AQHOrm8Iv5zR2iaV9k2899UcNK3725m/k/YAgADXq4CAACHhAIAADQwAgAEdioCAAFlLAIAAHEEA
Date: Thu, 12 Sep 2013 14:34:58 +0000
Message-ID: <1378996498.945.4.camel@x230.lan>
References: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
	 <1378849471-10521-16-git-send-email-vgoyal@redhat.com>
	 <522FA2A8.8080703@zytor.com> <20130911114419.GB31551@x1.alien8.de>
	 <20130911134534.GB15364@redhat.com> <20130911143216.GA933@x1.alien8.de>
	 <20130912064930.GA5288@dhcp-16-126.nay.redhat.com>
	 <20130912125350.GB9280@x1.alien8.de>
In-Reply-To: <20130912125350.GB9280@x1.alien8.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [64.134.240.212]
x-forefront-prvs: 0967749BC1
x-forefront-antispam-report: SFV:NSPM;SFS:(377424004)(24454002)(199002)(189002)(19580405001)(83322001)(63696002)(79102001)(46102001)(80022001)(81816001)(51856001)(81686001)(81342001)(69226001)(36756003)(19580395003)(74876001)(33646001)(66066001)(65816001)(49866001)(47736001)(4396001)(81542001)(76796001)(80976001)(47976001)(50986001)(76786001)(54356001)(53806001)(74366001)(31966008)(76482001)(83072001)(77096001)(59766001)(77982001)(74502001)(54316002)(74662001)(74706001)(56776001)(47446002)(56816003);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB221;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:64.134.240.212;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <3A76A262E8F59E4B9A638565CAA71CF3@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8CEb1ui013085

On Thu, 2013-09-12 at 14:53 +0200, Borislav Petkov wrote:

> Why userspace part - I'm thinking the kexec'ed kernel would simply add
> the mappings made by SetVirtualAddressMap without calling it. And it
> will know which mappings go to which virtual addresses because we start
> at the -4G virtual address and go downwards and the mappings will have
> the same addresses per UEFI implementation.

The second kernel still needs to be passed a pointer to the EFI tables
and memory map.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

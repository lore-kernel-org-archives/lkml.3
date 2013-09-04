Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621Ab3IDTDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 15:03:50 -0400
Received: from [207.46.163.210] ([207.46.163.210]:20294 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755519Ab3IDTDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 15:03:49 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: David Woodhouse <dwmw2@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH V3 02/11] PCI: Lock down BAR access when module security
 is enabled
Thread-Topic: [PATCH V3 02/11] PCI: Lock down BAR access when module
 security is enabled
Thread-Index: AQHOqQBjqKk67KL8RE6ch/Xxg088dpm1zbuAgAAhz4+AAADlAA==
Date: Wed, 4 Sep 2013 19:01:54 +0000
Message-ID: <1378321314.13193.7.camel@x230>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
	 <1378252218-18798-3-git-send-email-matthew.garrett@nebula.com>
	 <1378313861.4210.39.camel@i7.infradead.org> <1378314286.13193.5.camel@x230>
	 <1378321109.2627.9.camel@shinybook.infradead.org>
In-Reply-To: <1378321109.2627.9.camel@shinybook.infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [209.6.207.143]
x-forefront-prvs: 095972DF2F
x-forefront-antispam-report: SFV:NSPM;SFS:(377424004)(24454002)(199002)(189002)(51704005)(76786001)(54316002)(76796001)(19580395003)(81686001)(81816001)(56776001)(76482001)(54356001)(69226001)(80022001)(65816001)(66066001)(77982001)(59766001)(33646001)(33716001)(63696002)(79102001)(46102001)(81542001)(83322001)(19580405001)(81342001)(51856001)(47736001)(4396001)(47976001)(50986001)(49866001)(74366001)(31966008)(74662001)(74502001)(74706001)(47446002)(53806001)(80976001)(74876001)(83072001)(77096001)(56816003);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB222;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:209.6.207.143;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <481BA1B98576C84B98CA7978BF68F865@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r84J3tgg025177

On Wed, 2013-09-04 at 19:58 +0100, David Woodhouse wrote:
> On Wed, 2013-09-04 at 17:04 +0000, Matthew Garrett wrote:

> > How does virt passthrough work in this case? The current situation
> > appears to be that qemu just passes the BARs through to the guest, and
> > it's the guest that sets things up. We'd need to be able to ensure that
> > there's no way the guest driver can cause DMA into the host kernel.
> 
> We set up the IOMMU page tables so that the virtual bus addresses seen
> by the PCI device are 1:1 mapped to the guest "physical" address space.
> 
> That is, what the PCI device sees as a "physical" address is equivalent
> to what the guest sees as a "physical" address space. It can access
> memory which belongs to that guest, and nothing else. So that should be
> fine.

But presumably the guest's view of RAM is what gets written to the BARs?
I guess if we know it's constrained then there's no need to restrict the
addresses that can be set - we know that they'll be unable to overlap
the host RAM.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

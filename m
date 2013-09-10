Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab3IJDxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 23:53:40 -0400
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:35219
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751377Ab3IJDxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 23:53:37 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: David Lang <david@lang.hm>
CC: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
Thread-Topic: [PATCH 00/12] One more attempt at useful kernel lockdown
Thread-Index: AQHOrYDL2QYLBLFVskGOdCrAsfX2cpm9uPUAgABSI3WAADlnjYAABsNQgAAMWQA=
Date: Tue, 10 Sep 2013 03:53:32 +0000
Message-ID: <1378785208.17982.54.camel@x230.lan>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
	 <19562.1378747124@turing-police.cc.vt.edu>
	 <alpine.DEB.2.02.1309091119330.2479@nftneq.ynat.uz>
	 <1378767723.17982.27.camel@x230.lan>
	 <alpine.DEB.2.02.1309091614010.2479@nftneq.ynat.uz>
	 <1378774394.17982.36.camel@x230.lan>
	 <alpine.DEB.2.02.1309091938420.1820@nftneq.ynat.uz>
	 <1378781715.17982.42.camel@x230.lan>
	 <alpine.DEB.2.02.1309092002060.1820@nftneq.ynat.uz>
In-Reply-To: <alpine.DEB.2.02.1309092002060.1820@nftneq.ynat.uz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:5d52:9ee3:3e84:6668]
x-forefront-prvs: 096507C068
x-forefront-antispam-report: SFV:NSPM;SFS:(24454002)(51704005)(189002)(199002)(15404003)(377424004)(74876001)(80976001)(56816003)(53806001)(77096001)(19580405001)(19580395003)(83322001)(76482001)(54356001)(79102001)(77982001)(59766001)(83072001)(56776001)(54316002)(80022001)(63696002)(46102001)(81342001)(81816001)(65816001)(69226001)(51856001)(47446002)(74706001)(74366001)(74502001)(74662001)(31966008)(47736001)(50986001)(47976001)(49866001)(76796001)(81686001)(81542001)(36756003)(76786001)(4396001)(33646001)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB223;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:5d52:9ee3:3e84:6668;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <142CB707003E2D4F94939C0D3F9BE56B@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8A3rnpB024821

On Mon, 2013-09-09 at 20:09 -0700, David Lang wrote:
> On Tue, 10 Sep 2013, Matthew Garrett wrote:

> > Someone adds a new "install_evil()" syscall and adds a disable bit. If I
> > don't disable it, I'm now vulnerable. Please pay attention to earlier
> > discussion.
> 
> so instead they add install_evil() and don't have it be disabled by your big 
> switch.

And that's a bug, so we fix it.

> > Describe the security case for disabling PCI BAR access but permitting
> > i/o port access.
> 
> Simple, I have some device that lives on those I/O ports that I want to be able 
> to use.

That's a great argument for permitting i/o port access. But in that
case, why are you disabling BAR access? You can use the i/o port access
to reprogram the device in question into a range you can modify, which
allows you to avoid the BAR restriction.

> > Because then someone disables selinux on the kernel command line.
> 
> If they can modify the command line, they can remove your command line switch to 
> turn this on.

Not in the secure boot case.

> If you really care about this, why are you using a bootloader that lets you 
> modify the kernel command line in the first place?

And then the user just modifies the configuration file instead.

> In any case, even if you make it impossible to change from the command line, you 
> won't prevent people from changing your system (unless you take control 
> completely away from them with TPM or similar)

That's fine. People are free to modify their own systems.

> remember that the system integrity checking of the original Tivo was defeated by 
> someone dong a binary patch to bypass a routine that they didn't understand that 
> took a lot of time, so they did a binary patch to the bios to speed up boot and 
> discovered that what they did was disable the system integrity checking.

That's why modern systems require signed firmware updates.

> users who own the systems are going to modify them and bypass any restrictions 
> you want to impose.

The idea isn't to produce something that's impossible for the owner of a
system to disable. The idea is to produce something that can't be used
to circumvent the security policy that the system owner has chosen.
Could you please give me the benefit of the doubt and assume that I'm
not completely unaware of how computers work?

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

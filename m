Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab3IJCzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 22:55:23 -0400
Received: from mail-bl2lp0206.outbound.protection.outlook.com ([207.46.163.206]:20760
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753565Ab3IJCzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 22:55:21 -0400
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
Thread-Index: AQHOrYDL2QYLBLFVskGOdCrAsfX2cpm9uPUAgABSI3WAADlnjYAAAtiA
Date: Tue, 10 Sep 2013 02:55:15 +0000
Message-ID: <1378781715.17982.42.camel@x230.lan>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
	 <19562.1378747124@turing-police.cc.vt.edu>
	 <alpine.DEB.2.02.1309091119330.2479@nftneq.ynat.uz>
	 <1378767723.17982.27.camel@x230.lan>
	 <alpine.DEB.2.02.1309091614010.2479@nftneq.ynat.uz>
	 <1378774394.17982.36.camel@x230.lan>
	 <alpine.DEB.2.02.1309091938420.1820@nftneq.ynat.uz>
In-Reply-To: <alpine.DEB.2.02.1309091938420.1820@nftneq.ynat.uz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:5d52:9ee3:3e84:6668]
x-forefront-prvs: 096507C068
x-forefront-antispam-report: SFV:NSPM;SFS:(377424004)(24454002)(51704005)(189002)(199002)(51856001)(59766001)(81342001)(76796001)(56776001)(54316002)(80022001)(19580405001)(83322001)(65816001)(36756003)(49866001)(4396001)(47736001)(81542001)(47976001)(76786001)(50986001)(79102001)(46102001)(74366001)(77982001)(69226001)(33646001)(81686001)(81816001)(19580395003)(56816003)(77096001)(83072001)(74876001)(47446002)(53806001)(74502001)(54356001)(63696002)(74662001)(31966008)(80976001)(76482001)(74706001)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB221;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:5d52:9ee3:3e84:6668;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <717980D93F543F408B29467DC1C0C3D9@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8A2tUjY024679

On Mon, 2013-09-09 at 19:44 -0700, David Lang wrote:
> On Tue, 10 Sep 2013, Matthew Garrett wrote:
> > No. Say someone adds an additional lockdown bit to forbid raw access to
> > mounted block devices. The "Turn everything off" approach now means that
> > I won't be able to perform raw access to mounted block devices, even if
> > that's something that my use case relies on.
> 
> I was meaning that if you only turn off features that you know about, the 
> addition of a new thing that can be disabled doesn't make you any worse off than 
> you were.

Someone adds a new "install_evil()" syscall and adds a disable bit. If I
don't disable it, I'm now vulnerable. Please pay attention to earlier
discussion.

> >> so if you only have a single bit, how do you deal with the case where that bit
> >> locks down something that's required? (your reason for not just setting all bits
> >> in the first approach)
> >
> > Because that bit is well-defined, and if anything is added to it that
> > doesn't match that definition then it's a bug.
> 
> it may be well defined, but that doesn't mean that it actually matches what the 
> system owner wants to do.

If it doesn't match what the system owner wants to do, the system owner
doesn't set it. The system owner uses a more appropriate security
mechanism instead.

> The idea that the programmer can possibly anticipate all possible needs and 
> provide a switch for exactly that need is just wrong. Users will have needs that 
> you never thought of. The best systems are the ones where the creators look at 
> what users are doing and react with "I never imagined doing that"

Describe the security case for disabling PCI BAR access but permitting
i/o port access.

> > Anything more granular means that you trust your userspace, and if you
> > trust your userspace then you can already set up a granular policy using
> > the existing tools for that job. So just use the existing tools.
> 
> If you can't trust your userspace, how do you know that the userspace has set 
> the big hammer flag in the first place? if you can trust it to throw that 
> switch, you can trust it to throw multiple smaller switches.

Hence the final patch in the series, and hence also the suggestion for
exposing it as a command line option that can be set by the bootloader
during an attested boot.

> >> And if SELinux can do the job, what is the reason for creating this new option?
> >
> > Because you can't embed an unmodifiable selinux policy in the kernel.
> 
> Why not, have the policy set in an initramfs that's part of the kernel and have 
> part of that policy be to block all access to the selinux controls.

Because then someone disables selinux on the kernel command line.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

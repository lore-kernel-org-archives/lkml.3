Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab3IJAxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 20:53:22 -0400
Received: from mail-bn1lp0152.outbound.protection.outlook.com ([207.46.163.152]:36096
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756257Ab3IJAxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 20:53:21 -0400
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
Thread-Index: AQHOrYDL2QYLBLFVskGOdCrAsfX2cpm9uPUAgABSI3WAABooAA==
Date: Tue, 10 Sep 2013 00:53:14 +0000
Message-ID: <1378774394.17982.36.camel@x230.lan>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
	 <19562.1378747124@turing-police.cc.vt.edu>
	 <alpine.DEB.2.02.1309091119330.2479@nftneq.ynat.uz>
	 <1378767723.17982.27.camel@x230.lan>
	 <alpine.DEB.2.02.1309091614010.2479@nftneq.ynat.uz>
In-Reply-To: <alpine.DEB.2.02.1309091614010.2479@nftneq.ynat.uz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:5d52:9ee3:3e84:6668]
x-forefront-prvs: 096507C068
x-forefront-antispam-report: SFV:NSPM;SFS:(24454002)(51704005)(189002)(199002)(15404003)(377424004)(80976001)(74876001)(56816003)(53806001)(77096001)(19580405001)(19580395003)(83322001)(76482001)(54356001)(79102001)(77982001)(59766001)(83072001)(56776001)(54316002)(80022001)(63696002)(46102001)(81342001)(81816001)(65816001)(69226001)(74366001)(47446002)(74502001)(31966008)(74706001)(74662001)(47736001)(49866001)(47976001)(50986001)(76786001)(4396001)(76796001)(51856001)(81686001)(81542001)(36756003)(33646001)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB223;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:5d52:9ee3:3e84:6668;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <C6F5DB27F4467445BC5576EE74DD9198@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8A0rRdW024068

On Mon, 2013-09-09 at 16:19 -0700, David Lang wrote:
> On Mon, 9 Sep 2013, Matthew Garrett wrote:
> > Having thought about this, the answer is no. It presents exactly the
> > same problem as capabilities do - the set can never be meaningfully
> > extended. If an application sets only the bits it knows about, and if a
> > new security-sensitive feature is added to the kernel, the feature will
> > be left enabled and the system will be insecure. Alternatively, if an
> > application sets all the bits regardless of whether it knows them or
> > not, it may enable a lockdown feature that it otherwise required.
> 
> In this case you are no less secure than you were before the feature was added, 
> you just can't take advantage of the new feature without updating userspace.

No. Say someone adds an additional lockdown bit to forbid raw access to
mounted block devices. The "Turn everything off" approach now means that
I won't be able to perform raw access to mounted block devices, even if
that's something that my use case relies on.

> > The only way this is useful is if all the bits are semantically
> > equivalent, and in that case there's no point in having anything other
> > than a single bit. Users who want a more fine-grained interface should
> > use one of the existing mechanisms for doing so - leave the kernel open
> > and impose the security policy from userspace using either capabilities
> > or selinux.
> 
> so if you only have a single bit, how do you deal with the case where that bit 
> locks down something that's required? (your reason for not just setting all bits 
> in the first approach)

Because that bit is well-defined, and if anything is added to it that
doesn't match that definition then it's a bug.

> your arguments don't seem self consistent.

You don't seem to have been paying attention to the past 12 months of
discussion.

> If I'm building a kiosk PC (or voting machine), I want to disable a lot of 
> things that I could not get away with disabling on a generic laptop. Are we 
> going to have Securelevel, ReallySecurelevel, ReallyReallySecurelevel, etc? or 
> can we accept that security is not binary and allow users to disable features 
> in a more granualar way?

Anything more granular means that you trust your userspace, and if you
trust your userspace then you can already set up a granular policy using
the existing tools for that job. So just use the existing tools.

> And if SELinux can do the job, what is the reason for creating this new option?

Because you can't embed an unmodifiable selinux policy in the kernel.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

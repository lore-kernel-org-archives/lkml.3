Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab3H1XF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 19:05:56 -0400
Received: from mail-bn1lp0151.outbound.protection.outlook.com ([207.46.163.151]:1271
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119Ab3H1XFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 19:05:55 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Lenny Szubowicz <lszubowi@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "jwboyer@redhat.com" <jwboyer@redhat.com>,
        "keescook@chromium.org" <keescook@chromium.org>
Subject: Re: [PATCH 0/10] Add additional security checks when module loading
 is restricted
Thread-Topic: [PATCH 0/10] Add additional security checks when module
 loading is restricted
Thread-Index: Nz5hbGPlr11vDxoZBtCj48/bXxVZzqCFps4AWFn4cQH9PTbugA==
Date: Wed, 28 Aug 2013 23:05:51 +0000
Message-ID: <1377731151.27493.9.camel@x230>
References: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com>
	 <1241952070.8587861.1377729463830.JavaMail.root@redhat.com>
	 <1377729714.27493.2.camel@x230>
	 <761791749.8594444.1377730692707.JavaMail.root@redhat.com>
In-Reply-To: <761791749.8594444.1377730692707.JavaMail.root@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:51f:6613:ec7a:9b2f]
x-forefront-prvs: 09525C61DB
x-forefront-antispam-report: SFV:NSPM;SFS:(24454002)(199002)(189002)(377424004)(56816003)(77096001)(74706001)(74876001)(81686001)(76796001)(76786001)(47446002)(74662001)(31966008)(74502001)(81816001)(76482001)(54356001)(53806001)(79102001)(63696002)(74366001)(54316002)(56776001)(59766001)(77982001)(65816001)(80022001)(19580395003)(69226001)(19580405001)(83322001)(83072001)(80976001)(50986001)(47976001)(81542001)(81342001)(46102001)(33646001)(4396001)(47736001)(49866001)(33716001)(51856001)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB222;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:51f:6613:ec7a:9b2f;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <D248729DCEAE394EB36B0005A502DBA0@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7SN60a1010488

On Wed, 2013-08-28 at 18:58 -0400, Lenny Szubowicz wrote:

> I'm root. So I can write anything I want to the swap file that looks
> like a valid hibernate image but is code of my choosing. I can read
> anything I need from /dev/mem or /dev/kmem to help me do that.
> I can then immediately initiate a reboot.

No, you're blocked from /dev/mem and /dev/kmem. That doesn't make it
impossible, but it does make it much harder. A more realistic attack is
to write something that looks like (but isn't) a hibernation image which
effectively jumps back into the resume kernel after modifying it, but
you'd still need to generate a bunch of kernel state.

The need for a reboot makes it a less significant attack than the others
that this patchset protects against, which all allow the modification of
the already running kernel. If you also want to protect against attacks
involving reboots then you need to secure the on-disk representation of
the kernel as well, which means Secure Boot, and that also means you
want encrypted hibernation support.

If you need something for the short term then I'd suggest just adding a
config option that disables hibernation when a system is in Secure Boot
mode, but the best plan is pretty much to review the encrypted
hibernation patches that got posted recently. It'd be easy to tie those
into appropriate policy.
-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

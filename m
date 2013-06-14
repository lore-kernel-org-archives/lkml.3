Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab3FNW2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 18:28:00 -0400
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:29787
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751512Ab3FNW17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 18:27:59 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Roman Yepishev <roman.yepishev@gmail.com>,
        Jiang Liu <jiang.liu@huawei.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: Re: [PATCH] PCI: Remove not needed check in disable aspm link
Thread-Topic: [PATCH] PCI: Remove not needed check in disable aspm link
Thread-Index: AQHOaSy7q8T6unfYO0y0KlbpsoIbopk1uWwAgAAOSICAAAKsgA==
Date: Fri, 14 Jun 2013 22:27:34 +0000
Message-ID: <1371248853.2490.5.camel@x230>
References: <CAE9FiQVu5QyxaKsYzzQoroQD=TvsziHzDOtoeg=FvhZ8HyN5yw@mail.gmail.com>
	 <CAErSpo7ChfRiEn0eR1rf-mVheUS9Yf8f+j4n78PJcGYh+yMVgA@mail.gmail.com>
	 <CAE9FiQXkDg7Y336S=DXoms44=5HLaiUx=sWviupz1fJmaDUEzQ@mail.gmail.com>
	 <CAE9FiQU5c=ztzbskNnYFFKF9V5zO+jnRcMBCivLxA1F3fSfX5w@mail.gmail.com>
	 <20130401235256.GA31966@google.com>
	 <CAE9FiQV8cPh-s6=EQu_cZTtn86+NwZE5KuGMhf43aOhzkL=hwA@mail.gmail.com>
	 <CAErSpo7Jni1ZSf_W=vB3kqsucPpoepa2Q5g=77a6D3FaPwe9LA@mail.gmail.com>
	 <CAE9FiQWjQXwiTWju6cBc_o25jy_wmZ1u+Pifh1wdnxtV=i5ENw@mail.gmail.com>
	 <CAErSpo7=a-wX6BLbm_O1nUMMrQHOgtSm3xZHKuRqaz8rnKSbRA@mail.gmail.com>
	 <CAE9FiQUbw7OUhRB+gKMxkuE9+nm9097+mwZ2z4adO8Hv_NjF1Q@mail.gmail.com>
	 <20130614141101.GA29452@google.com>
	 <CAE9FiQVr-OWeqEHFXn0MjNiSD0WM=FNO_DFo6m9UbbG60uonpw@mail.gmail.com>
	 <CAErSpo7grN-93zZfBJOHZH-pR1wDYrojTwt=B=++QqA0rPb3Rg@mail.gmail.com>
	 <CAE9FiQUO350kqrXB5=yQ-OxOeSJj4+P6WPg4gGgXxFEvfoLyng@mail.gmail.com>
	 <CAErSpo6vEOw10YV=Sou6wjjSc2GWr-oX=Dvbt7Xt=RJKi4RELw@mail.gmail.com>
	 <CAE9FiQWevd6ZNDdqGkqbLrGujKYuTiwibPAT+30VPpC_H-rLJA@mail.gmail.com>
	 <CAErSpo66qtgg8=BqX+4sm4h1vXD5gR6aiH7hHK7gvz1x3rEQZA@mail.gmail.com>
	 <CAE9FiQWxDhagFNAYc2eNDe_1jYtVTa5Azg0zifiprND5m3CmMw@mail.gmail.com>
In-Reply-To: <CAE9FiQWxDhagFNAYc2eNDe_1jYtVTa5Azg0zifiprND5m3CmMw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
x-forefront-antispam-report: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:BY2PR05MB221;H:BY2PR05MB222.namprd05.prod.outlook.com;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <D141784C3C2CD4439E3C574B5E93F81A@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5EMS8UT008478

On Fri, 2013-06-14 at 15:17 -0700, Yinghai Lu wrote:

> after those two patches, it aspm_disabled is set, via _osc early,
> pre-1.1 devices aspm register will be touched even aspm_force is not specified.

I don't follow. We were previously automatically disabling ASPM on
pre-1.1 devices even if _OSC didn't give us control. I've confirmed that
this was the wrong thing for us to be doing, and my patch changed the
behaviour such that if the firmware enables ASPM on a pre-1.1 device and
refuses to give us control via _OSC we will leave ASPM enabled.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

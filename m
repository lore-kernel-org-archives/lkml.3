Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab3FOBkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 21:40:20 -0400
Received: from [207.46.163.209] ([207.46.163.209]:31042 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753899Ab3FOBkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 21:40:16 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Aaron Lu <aaron.lu@intel.com>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Zhang Rui <rui.zhang@intel.com>, Aaron Lu <aaron.lwe@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>
Subject: Re: [PATCH 3/3] i915: Don't provide ACPI backlight interface if
 firmware expects Windows 8
Thread-Topic: [PATCH 3/3] i915: Don't provide ACPI backlight interface if
 firmware expects Windows 8
Thread-Index: AQHOZWVb86pe7osyu0+xw9CXu6ntE5k0yzOAgACziwCAAIVRgIAAAxsA
Date: Sat, 15 Jun 2013 01:38:05 +0000
Message-ID: <1371260284.523.2.camel@x230>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
	 <1370818899-8595-4-git-send-email-matthew.garrett@nebula.com>
	 <51BABC6F.3050201@intel.com> <1371230988.2490.2.camel@x230>
	 <51BBC2E1.9040401@intel.com>
In-Reply-To: <51BBC2E1.9040401@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
x-forefront-antispam-report: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:BY2PR05MB222;H:BY2PR05MB222.namprd05.prod.outlook.com;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <2861A50AFD728848B4788028958ADD4A@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5F1eVuv009266

On Sat, 2013-06-15 at 09:26 +0800, Aaron Lu wrote:
> On 06/15/2013 01:29 AM, Matthew Garrett wrote: 
> > How would that work with existing userspace?
> 
> User space tool will need to be updated to use this as stated in the
> gist page, I've patches for gsd-backlight-helper and xorg-x11-drv-intel,
> for others we can add I think if the priority based solution is deemed
> useful.

Right, that's not a great solution.

> > We shouldn't export interfaces if we don't expect them to work.
> 
> It's not easy to decide if they work or not sometimes, e.g. I came
> across a system that claims win8 in ACPI table and has an Intel GPU,
> while its ACPI video interface also works. With this patch, the working
> ACPI video interface is removed, while with the priority based solution,
> the GPU's interface priority gets higher, but the ACPI video interface
> still stays.

Well, Windows 8 will only use the ACPI backlight interface if the GPU
driver decides to, right? So the logic for deciding whether to remove
the ACPI backlight control or not should be left up to the GPU. There's
no harm in refusing to expose a working method if there's another
working method, but there is harm in exposing a broken one and expecting
userspace to know the difference.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

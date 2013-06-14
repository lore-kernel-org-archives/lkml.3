Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab3FNR3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 13:29:55 -0400
Received: from mail-bn1lp0152.outbound.protection.outlook.com ([207.46.163.152]:47647
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752615Ab3FNR3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 13:29:52 -0400
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
Thread-Index: AQHOZWVb86pe7osyu0+xw9CXu6ntE5k0yzOAgACziwA=
Date: Fri, 14 Jun 2013 17:29:48 +0000
Message-ID: <1371230988.2490.2.camel@x230>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
	 <1370818899-8595-4-git-send-email-matthew.garrett@nebula.com>
	 <51BABC6F.3050201@intel.com>
In-Reply-To: <51BABC6F.3050201@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
x-forefront-antispam-report: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:BY2PR05MB223;H:BY2PR05MB222.namprd05.prod.outlook.com;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <89367251F921144BA1652F68756238DC@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5EHU1lY006778

On Fri, 2013-06-14 at 14:47 +0800, Aaron Lu wrote:

> What about a priority based solution? We can introduce a new field named
> priority to backlight_device and instead of calling another module's
> function like the unregister one here(which cause unnecessary module
> dependency), we only need to boost priority for its own interface. This
> field will be exported to sysfs, so user can change it during runtime
> too. And we can also introduce a new kernel command line as
> backlight.force_interface=raw/firmware/platform, to overcome the limited
> functionality provided by acpi_backlight=video/vendor, which does not
> involve GPU's interface.

How would that work with existing userspace?

> And we can place the quirk code in backlight layer instead of individual
> backlight functionality provider module. Suppose we have a backlight
> manager there, for all win8 systems, we can boost the raw type's
> priority on its registration, so no need to add code in
> intel/amd/etc./'s GPU driver code.

But we'd need to add code to every piece of userspace that currently
uses the backlight, right?

> With priority based solution, all backlight control interfaces stay,
> the priority field is an indication given by kernel to user space.

We shouldn't export interfaces if we don't expect them to work.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

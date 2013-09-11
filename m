Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab3IKKcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 06:32:23 -0400
Received: from [207.46.163.241] ([207.46.163.241]:18691 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753049Ab3IKKcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 06:32:21 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Jani Nikula <jani.nikula@linux.intel.com>
CC: Aaron Lu <aaron.lu@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Daniel Vetter" <daniel@ffwll.ch>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Yves-Alexis Perez <corsac@debian.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Lee Chun-Yi <jlee@novell.com>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 2/2] ACPI / video / i915: Remove ACPI backlight if
 firmware expects Windows 8
Thread-Topic: [PATCH 2/2] ACPI / video / i915: Remove ACPI backlight if
 firmware expects Windows 8
Thread-Index: AQHOrTh4P2SImvKSpUu3tJlbFkAqyJm9JHkAgAAt1ACAADO4AIAAVGuAgAElbgCAAFwIAIAAZyGAgAB5BYCAAByP8YAAAMSA
Date: Wed, 11 Sep 2013 10:30:17 +0000
Message-ID: <1378895417.945.2.camel@x230.lan>
References: <522D88C3.7000808@intel.com> <5155010.Y1gov7SKhP@vostro.rjw.lan>
	 <87eh8wail7.fsf@intel.com> <1889567.vxI8heiC3B@vostro.rjw.lan>
	 <20130911013206.GA556@mint-spring.sh.intel.com> <87hadrycf4.fsf@intel.com>
	 <1378889140.945.0.camel@x230.lan> <87d2ofy7li.fsf@intel.com>
In-Reply-To: <87d2ofy7li.fsf@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:91f6:fb4b:7e67:dab0]
x-forefront-prvs: 09669DB681
x-forefront-antispam-report: SFV:NSPM;SFS:(24454002)(189002)(199002)(377424004)(51704005)(54356001)(36756003)(74876001)(83072001)(74706001)(53806001)(33646001)(79102001)(19580405001)(59766001)(47736001)(77982001)(46102001)(63696002)(83322001)(51856001)(49866001)(81542001)(50986001)(47976001)(19580395003)(69226001)(4396001)(81342001)(56776001)(76786001)(80976001)(54316002)(80022001)(31966008)(74662001)(81816001)(47446002)(81686001)(74502001)(56816003)(65816001)(74366001)(76796001)(76482001)(77096001)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB222;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:91f6:fb4b:7e67:dab0;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <4847B66A956DC249A340F90BA1CD9519@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8BAWVY9004027

On Wed, 2013-09-11 at 13:29 +0300, Jani Nikula wrote:
> On Wed, 11 Sep 2013, Matthew Garrett <matthew.garrett@nebula.com> wrote:
> > On Wed, 2013-09-11 at 11:45 +0300, Jani Nikula wrote:
> >
> >> Before plunging forward, have you observed any difference between the
> >> boot modes? We have reports [1] that the backlight behaviour is
> >> different with UEFI vs. UEFI+CSM or legacy boot. So I'm wondering if the
> >> acpi_gbl_osi_data >= ACPI_OSI_WIN_8 check in patch 2/2 is the whole
> >> story.
> >> 
> >> Further, if we tell the BIOS we're Windows 8 to use the tested BIOS code
> >> paths, what guarantees do we have of UEFI+CSM or legacy boots working?
> >
> > We have no evidence of Windows behaving differently based on the exposed
> > firmware type.
> 
> By "behaving differently", do you mean internally adapting to the boot
> mode, or exhibiting different behaviour to the user?

As far as backlight control goes, both.

> We have evidence of the firmware behaving differently (VBT, backlight)
> based on the boot mode, all else being equal. We don't adapt to that,
> and we fail. I don't know if we should adapt, or do things differently
> altogether. I don't even know if Windows 8 works on all boot modes on
> the machines in question.

Sure, but Windows knows nothing about VBT or opregion-backed backlight
control. That's up to the Intel driver.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

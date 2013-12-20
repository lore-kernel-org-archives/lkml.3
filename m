Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850Ab3LTA2N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 19:28:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:60547 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917Ab3LTA2L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 19:28:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,516,1384329600"; 
   d="scan'208";a="447304872"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: Takashi Iwai <tiwai@suse.de>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: "Brown, Len" <len.brown@intel.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "ibm-acpi-devel@lists.sourceforge.net" 
	<ibm-acpi-devel@lists.sourceforge.net>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lv Zheng <zetalog@gmail.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>
Subject: RE: [alsa-devel] [RFC PATCH 15/15] ACPI/thinkpad: Fix wrong
 <acpi/acpi.h> inclusion in Thinkpad ACPI users.
Thread-Topic: [alsa-devel] [RFC PATCH 15/15] ACPI/thinkpad: Fix wrong
 <acpi/acpi.h> inclusion in Thinkpad ACPI users.
Thread-Index: AQHO++YZuXv36/5GrUCXFs8cRgdj8ppZZfSAgALRnJA=
Date: Fri, 20 Dec 2013 00:28:02 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E8802499192@SHSMSX101.ccr.corp.intel.com>
References: <cover.1387336613.git.lv.zheng@intel.com>
	<f82182940fe88b1b6428eecc2df1cb1684f0ca80.1387336613.git.lv.zheng@intel.com>
	<20131218114117.GB29631@khazad-dum.debian.net> <s5hd2kuux4o.wl%tiwai@suse.de>
In-Reply-To: <s5hd2kuux4o.wl%tiwai@suse.de>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Takashi and Henrique

Thanks for reviewing and commenting.

> From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-owner@vger.kernel.org] On Behalf Of Takashi Iwai
> Sent: Wednesday, December 18, 2013 9:06 PM
> 
> At Wed, 18 Dec 2013 09:41:17 -0200,
> Henrique de Moraes Holschuh wrote:
> >
> > On Wed, 18 Dec 2013, Lv Zheng wrote:
> > > CONFIG_ACPI dependent code should include <linux/acpi.h> instead of
> > > directly including <acpi/acpi.h>.  This patch cleans up such wrong
> > > inclusions for Thinkpad ACPI users.
> >
> > ...
> >
> > >  drivers/platform/x86/thinkpad_acpi.c |    1 -
> > >  include/linux/thinkpad_acpi.h        |    2 ++
> > >  sound/pci/hda/patch_conexant.c       |    1 -
> > >  sound/pci/hda/patch_realtek.c        |    1 -
> >
> > I'd prefer if you left the include outside of thinkpad_acpi.h, and just fix
> > the include in the two ALSA users.
> 
> Agreed.
> 
> > We might add some extra stuff to thinkpad_acpi.h someday, and not everything
> > thinkpad_acpi does that might be useful to export to other areas of the
> > kernel would require acpi.h.
> >
> > Looking at patch_conexant and patch_realtek, it might be better to actually
> > move the "am I running on a thinkpad" stuff they use acpi.h for into
> > thinkpad_acpi, and provide a prototype for that in thinkpad_acpi.h.
> 
> True, but we don't want to bind with thinkpad_acpi before identified
> that it's a thinkpad, so the code needs to be in hd-audio codec
> driver.
> 

It looks to me like that there is a relationship between two Henrique's suggestions.
His opinion is all ACPI stuff should be bound into thinkpad_acpi.c, that's why he suggested not to include <linux/acpi.h> in <linux/thinkpad_acpi.h>.
So we might address both of them in order to follow.

I'm not sure if your opinion is: the hd-audio codec driver's needs cannot be met by addressing the second comment.
And I'm not the right person that is able to test such code restructuring work.
The target of this patchset is cleaning up wrong <acpi/acpi.h> inclusions, so let me focus on the first comment.

Can I just update this patch with <acpi/acpi.h> inclusions replaced by <linux/acpi.h> inclusions?

Thanks and best regards
-Lv

> 
> thanks,
> 
> Takashi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

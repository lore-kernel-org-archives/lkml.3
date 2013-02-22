Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab3BVELz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 23:11:55 -0500
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.92]:31017 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755487Ab3BVELs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 23:11:48 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "FlorianSchandinat@gmx.de" <FlorianSchandinat@gmx.de>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH RFC] video: Add Hyper-V Synthetic Video Frame Buffer
 Driver
Thread-Topic: [PATCH RFC] video: Add Hyper-V Synthetic Video Frame Buffer
 Driver
Thread-Index: AQHOC6xQKsSDc1Q1WkuxN29CXfjd55iB8XAA//+EDqCAAJpbgP//f3DggAN2zYCAAEMw0w==
Date: Fri, 22 Feb 2013 04:11:39 +0000
Message-ID: <e0484554d9b44ade88b84f9e4e5ecc2d@DFM-DB3MBX15-08.exchange.corp.microsoft.com>
References: <1360955396-14183-1-git-send-email-haiyangz@microsoft.com>
 <20130219165118.GA17715@aepfle.de>
 <1ca36b5d55c64ac6b8854c4f216ef8e5@DFM-TK5MBX15-06.exchange.corp.microsoft.com>
 <20130219184009.GA21783@aepfle.de>
 <7267f77544c24531b8fcccc2192b9f48@DFM-TK5MBX15-06.exchange.corp.microsoft.com>,<20130221155359.GA28637@aepfle.de>
In-Reply-To: <20130221155359.GA28637@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Forefront-Antispam-Report: CIP:131.107.1.17;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(377454001)(51704002)(24454001)(164054002)(189002)(199002)(56776001)(76482001)(4396001)(31966008)(50986001)(44976002)(50466001)(23726001)(876001)(16406001)(51856001)(79102001)(5343655001)(59766001)(47446002)(77982001)(74662001)(74502001)(65816001)(54316002)(56816002)(47976001)(49866001)(47736001)(46406002)(47776003)(80022001)(33646001)(54356001)(46102001)(53806001)(20776003)(63696002)(66066001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BLUSR01MB603;H:hybrid.exchange.microsoft.com;RD:mail1.exchange.microsoft.com;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 07658B8EA3
X-OriginatorOrg: DuplicateDomain-7923a859-03c9-4312-a77c-440aa45aaf52.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: Olaf Hering
> Sent: Thursday, February 21, 2013 10:53 AM
> To: Haiyang Zhang
> Cc: FlorianSchandinat@gmx.de; linux-fbdev@vger.kernel.org; KY Srinivasan; jasowang@redhat.com; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org
> Subject: Re: [PATCH RFC] video: Add Hyper-V Synthetic Video Frame Buffer Driver
> 
> On Tue, Feb 19, Haiyang Zhang wrote:
> 
> > In my test, the vesafb doesn't automatically give up the emulated video device,
> > unless I add the DMI based mechanism to let it exit on Hyper-V.
> 
> From reading the code, it seems to do that via
> do_remove_conflicting_framebuffers(). hypervfb does not set apertures
> etc, so that function is a noop.

We are currently allocating a new framebuffer for hyperv_fb, which is different
from the framebuffer for the emulated video. So this cannot be detected by
do_remove_conflicting_framebuffers() based on apertures_overlap().

> My point is that with this new driver distro kernel will have no console
> output until hypervfb is loaded. On native hardware there is at least
> vesafb which can display something until initrd is running. So if the
> hypervisor allows that hypervfb can shutdown the emulated vesa hardware
> then it should do that.

Since the generic vga driver starts to work early in the boot process, the console
messages are still displayed without vesafb. Actually, I didn't see any console 
messages missing when comparing it to the original VM before my patch.

Thanks,
- Haiyang

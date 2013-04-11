Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762631Ab3DKI3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 04:29:01 -0400
Received: from mga03.intel.com ([143.182.124.21]:1894 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083Ab3DKI27 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 04:28:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,454,1363158000"; 
   d="scan'208";a="225887097"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Thomas Renninger <trenn@suse.de>
CC: Tang Chen <tangchen@cn.fujitsu.com>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Early microcode signing in secure boot environment -  Was: x86,
 microcode: Use common get_ramdisk_image()
Thread-Topic: Early microcode signing in secure boot environment -  Was:
 x86, microcode: Use common get_ramdisk_image()
Thread-Index: AQHONb60g0rx3Qsj60u0yQfcUn2kTpjPqqxQgAFsXgD//5dAIA==
Date: Thu, 11 Apr 2013 08:28:37 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C712205594C20D@ORSMSX105.amr.corp.intel.com>
References: <1365119186-23487-1-git-send-email-yinghai@kernel.org>
 <17075291.dMPGPSzlWd@skinner.arch.suse.de>
 <3E5A0FA7E9CA944F9D5414FEC6C712205594BABA@ORSMSX105.amr.corp.intel.com>
 <1478755.iNa1PauEka@skinner.arch.suse.de>
In-Reply-To: <1478755.iNa1PauEka@skinner.arch.suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Thomas Renninger [mailto:trenn@suse.de]
> Sent: Thursday, April 11, 2013 12:32 AM
> On Wednesday, April 10, 2013 05:47:25 PM Yu, Fenghua wrote:
> > > -----Original Message-----
> > > From: Thomas Renninger [mailto:trenn@suse.de]
> > > Sent: Wednesday, April 10, 2013 12:41 AM
> > > Hello,
> > >
> > > On Wednesday, April 10, 2013 01:34:33 PM Tang Chen wrote:
> > > > On 04/05/2013 07:46 AM, Yinghai Lu wrote:
> > > > > Use common get_ramdisk_image() to get ramdisk start phys
> address.
> > > > >
> > > > > We need this to get correct ramdisk adress for 64bit bzImage
> that
> > > > > initrd can be loaded above 4G by kexec-tools.disk_size;
> > >
> > > don't know whether this question came up when this feature got
> > > submitted (if yes a pointer would be appreciated).
> > >
> > > Is there a concept how signed microcode can get verified when
> applied
> > > early,
> > > like it is done via firmware loader?
> > >
> > > If not, early microcode loading is not really usable in secure boot
> > > environment, right?
> >
> > The microcode is cryptographically authenticated by the CPU itself,
> so there
> > is no security issue related to early microcode loading.
> 
> So Intel HW is allowed to authenticate its firmware itself, bypassing
> the UEFI
> certificates...
> Does this apply for other vendors as well?
This should apply for other vendors as well as this is defined in X86 SDM.

> Does this apply to secure boot specification?
Secure boot can add another level of security because the early loaded
microcode is part of initrd and initrd is measured by secure boot.

> 
> Is this "cryptographically authenticated by the CPU itself" thing
> documented
> somewhere so that security people can double check that it is really
> secure?

X86 SDM defines that the second part of microcode update is the encrypted data.

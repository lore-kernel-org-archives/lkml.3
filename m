Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab3JPOwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 10:52:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:31467 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755Ab3JPOw3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 10:52:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,508,1378882800"; 
   d="scan'208";a="375579820"
From: "Luck, Tony" <tony.luck@intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>,
        Matt Fleming <matt@console-pimps.org>
CC: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Fleming, Matt" <matt.fleming@intel.com>
Subject: RE: [PATCH 5/5] efi: Capsule update support and pstore backend
Thread-Topic: [PATCH 5/5] efi: Capsule update support and pstore backend
Thread-Index: AQHOynbXia3XS3Tiv0y3jvGPj16o5pn31eqA//+SeZA=
Date: Wed, 16 Oct 2013 14:52:25 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31D31122@ORSMSX106.amr.corp.intel.com>
References: <1381931460-6999-1-git-send-email-matt@console-pimps.org>
 <1381931460-6999-6-git-send-email-matt@console-pimps.org>
 <20131016141939.GA28684@srcf.ucam.org>
In-Reply-To: <20131016141939.GA28684@srcf.ucam.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Where by "May not function correctly" you mean "May crash the system"? 
> I'm a little uneasy having this run by default if enabled, even if it's 
> disabled by default in the config.

There's also an "either/or" choice between using efi-capsule with pstore, and the
traditional kexec/kdump method for getting a memory dump from a crash.  We
have to go through a reset to save the capsule - but we don't want a reset for
kexec.   Perhaps we can pass the reset parameters through the kexec path to
the new kernel to make it do the right kind of reset ... but the value of the capsule
dump is minimal if kdump managed to dump everything.

Bottom line: users need to make an informed choice to use efi-capsule + pstore.

-Tony

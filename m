Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760964Ab3JQAGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 20:06:52 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:57166 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760618Ab3JQAGu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 20:06:50 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Luck, Tony" <tony.luck@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Matt Fleming <matt@console-pimps.org>
CC: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
        "Fleming, Matt" <matt.fleming@intel.com>
Subject: RE: [PATCH 5/5] efi: Capsule update support and pstore backend
Thread-Topic: [PATCH 5/5] efi: Capsule update support and pstore backend
Thread-Index: AQHOynbQD9FZS4Tc00+Pc4kQtqDERZn3o5+AgAAJKICAAFbXIA==
Date: Thu, 17 Oct 2013 00:06:34 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D443EF862E@USINDEM103.corp.hds.com>
References: <1381931460-6999-1-git-send-email-matt@console-pimps.org>
 <1381931460-6999-6-git-send-email-matt@console-pimps.org>
 <20131016141939.GA28684@srcf.ucam.org>
 <3908561D78D1C84285E8C5FCA982C28F31D31122@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31D31122@ORSMSX106.amr.corp.intel.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-10-16_07:2013-10-17,2013-10-16,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1310160116
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There's also an "either/or" choice between using efi-capsule with pstore, and the
> traditional kexec/kdump method for getting a memory dump from a crash.  We
> have to go through a reset to save the capsule - but we don't want a reset for
> kexec.   Perhaps we can pass the reset parameters through the kexec path to
> the new kernel to make it do the right kind of reset ... but the value of the capsule
> dump is minimal if kdump managed to dump everything.

Tony,

I tried to log kmsg into the kexec path months ago.
It was rejected due to the impelementation problem.

But, as Eric said, it should be OK if it is implemented in the kdump kenel.

http://marc.info/?l=linux-kernel&m=136917686732183&w=2

The only problem with kdump here is the implementation in the initial
ram disk.  Fixing the initial ramdisk so it logs to kmsg before it
touches scarier hardware should be the solution.

Seiji

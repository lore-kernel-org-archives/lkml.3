Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab3EGXqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 19:46:23 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58527 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123Ab3EGXqW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 19:46:22 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] regulator: support operating mode in the device
 tree structure
Thread-Topic: [PATCH 1/2] regulator: support operating mode in the device
 tree structure
Thread-Index: Ac5LJBJM/oddlFLaRlaDBPM6ywYW8///qt2A//8JIlA=
Date: Tue, 7 May 2013 23:46:12 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E5C9C8@DQHE06.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F82E5C95D@DQHE06.ent.ti.com>
 <20130507160431.GV7478@sirena.org.uk>
In-Reply-To: <20130507160431.GV7478@sirena.org.uk>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Mark Brown [mailto:broonie@kernel.org]
> Sent: Wednesday, May 08, 2013 1:05 AM
> To: Kim, Milo
> Cc: Liam Girdwood; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/2] regulator: support operating mode in the
> device tree structure
> 
> On Tue, May 07, 2013 at 01:09:14PM +0000, Kim, Milo wrote:
> > For better power efficiency, regulator subsystem provides operating
> mode.
> > (fast, normal, idle and standby)
> > The operating mode is selective by a regulator consumer.
> >
> > With this patch, regulator operating mode can be set in the DT
> structure.
> > If any operating mode is configured, then 'valid_ops_mask' should be
> set with
> > REGULATOR_CHANGE_MODE.
> 
> It's not clear to me that these modes are a useful thing to be exposing
> in device tree - they've always been rather arbatrary and are becoming
> less and less relevant as regulator hardware improves in its ability to
> adapt to load.  I think for fixed modes that don't vary dynamically at
> runtime the best thing is just to make the modes custom so they map
> onto
> the device datasheets clearly.  That seems to be most of the usage
> anyway.

I agree the operating mode depends on the device.

It's my intention to guarantee same operations in the DT as the regulator
constraints in the platform side.
In case a regulator has specific 'valid_modes_mask', the operating mode is 
unable to be set with the device tree.
For some regulator drivers such as LP8720/5 and LP8788, this patch would be
useful because there is no difference between configuration in the platform side
 and the device tree.

Thanks,
Milo


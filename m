Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab3AMXfO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 18:35:14 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:45700 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab3AMXfM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 18:35:12 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Axel Lin <axel.lin@ingics.com>, "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/3] regulator-core: update all enable GPIO state in
 _enable/disable
Thread-Topic: [PATCH 2/3] regulator-core: update all enable GPIO state in
 _enable/disable
Thread-Index: Ac3vF1MMan6DWOu1ROel6fNImsx4zQChN5iAABFMXqA=
Date: Sun, 13 Jan 2013 23:35:03 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E12A0D@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F69E122AA@DQHE02.ent.ti.com>
 <20130113224220.GE5041@opensource.wolfsonmicro.com>
In-Reply-To: <20130113224220.GE5041@opensource.wolfsonmicro.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.78]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> 
> This isn't quite going to work properly - we need to actually move the
> state (and also a reference count) into some sort of shared state.
> Otherwise consider what happens in this scenario:
> 
> 	1. regulator 1 enables
> 	2. regulator 2 enables
> 	3. regulator 1 disables
> 
> Since regulator 1 doesn't know anything about regulator 2 it'll not
> know
> that regulator 2 should still be enabled so it'll put the GPIO into the
> disabled state.  It'll be OK if regulator 1 and regulator 2 always have
> the same state but if they ever differ then we'll not do the right
> thing.

Thanks for your opinion.
My understanding is 'shared' enable pin means regulators are enabled/disabled
at the same time.
Any other case is possible?

Best Regards,
Milo

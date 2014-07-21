Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933417AbaGUSWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 14:22:25 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:65358 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933237AbaGUSWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 14:22:24 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <53CD4DD2.10906@amd.com>
References: <53C7D645.3070607@amd.com>
	<20140720174652.GE3068@gmail.com>
	<53CD0961.4070505@amd.com>
	<53CD17FD.3000908@vodafone.de>
	<20140721152511.GW15237@phenom.ffwll.local>
	<20140721155851.GB4519@gmail.com>
	<20140721170546.GB15237@phenom.ffwll.local>
	<53CD4DD2.10906@amd.com>
Date: Mon, 21 Jul 2014 20:22:23 +0200
X-Google-Sender-Auth: VaUuMRR2T9f8bgsitVVPLWwLY9U
Message-ID: <CAKMK7uFhvGtxj_d6X=4OBdVSm6cT1-Z-DiTE-FTWMnFjY2uqMQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/25] AMDKFD kernel driver
From: Daniel Vetter <daniel@ffwll.ch>
To: Oded Gabbay <oded.gabbay@amd.com>
Cc: Jerome Glisse <j.glisse@gmail.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <deathsimple@vodafone.de>,
        David Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Bridgman <John.Bridgman@amd.com>, Joerg Roedel <joro@8bytes.org>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Ben Goz <Ben.Goz@amd.com>, Alexey Skidanov <Alexey.Skidanov@amd.com>,
        Evgeny Pinchuk <Evgeny.Pinchuk@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 7:28 PM, Oded Gabbay <oded.gabbay@amd.com> wrote:
>> I'm not sure whether we can do the same trick with the hw scheduler. But
>> then unpinning hw contexts will drain the pipeline anyway, so I guess we
>> can just stop feeding the hw scheduler until it runs dry. And then unpin
>> and evict.
> So, I'm afraid but we can't do this for AMD Kaveri because:

Well as long as you can drain the hw scheduler queue (and you can do
that, worst case you have to unmap all the doorbells and other stuff
to intercept further submission from userspace) you can evict stuff.
And if we don't want compute to be a denial of service on the display
side of the driver we need this ability. Now if you go through an
ioctl instead of the doorbell (I agree with Jerome here, the doorbell
should be supported by benchmarks on linux) this gets a bit easier,
but it's not a requirement really.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch

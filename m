Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbaGVJYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 05:24:21 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:54039 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbaGVJYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 05:24:20 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <CAKMK7uH+okhn4YGOzrXZ1LM3S2myxdu=_63LGMduwV-WZn06CA@mail.gmail.com>
References: <20140720174652.GE3068@gmail.com>
	<53CD0961.4070505@amd.com>
	<53CD17FD.3000908@vodafone.de>
	<20140721152511.GW15237@phenom.ffwll.local>
	<20140721155851.GB4519@gmail.com>
	<20140721170546.GB15237@phenom.ffwll.local>
	<53CD4DD2.10906@amd.com>
	<CAKMK7uFhvGtxj_d6X=4OBdVSm6cT1-Z-DiTE-FTWMnFjY2uqMQ@mail.gmail.com>
	<53CD5ED9.2040600@amd.com>
	<20140721190306.GB5278@gmail.com>
	<20140722072851.GH15237@phenom.ffwll.local>
	<53CE1E9C.8020105@amd.com>
	<CAKMK7uH+okhn4YGOzrXZ1LM3S2myxdu=_63LGMduwV-WZn06CA@mail.gmail.com>
Date: Tue, 22 Jul 2014 11:24:19 +0200
Message-ID: <CAKMK7uFdM_nQfRYv_vQsMTwHL1zrgThBC9dik0Yvhe6c8WO+8Q@mail.gmail.com>
Subject: Re: [PATCH v2 00/25] AMDKFD kernel driver
From: Daniel Vetter <daniel.vetter@ffwll.ch>
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

On Tue, Jul 22, 2014 at 11:21 AM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> On Tue, Jul 22, 2014 at 10:19 AM, Oded Gabbay <oded.gabbay@amd.com> wrote:
>>> Exactly, just prevent userspace from submitting more. And if you have
>>> misbehaving userspace that submits too much, reset the gpu and tell it
>>> that you're sorry but won't schedule any more work.
>>
>> I'm not sure how you intend to know if a userspace misbehaves or not. Can
>> you elaborate ?
>
> Well that's mostly policy, currently in i915 we only have a check for
> hangs, and if userspace hangs a bit too often then we stop it. I guess
> you can do that with the queue unmapping you've describe in reply to
> Jerome's mail.

Not just graphics, and especially not just graphics from amd. My
experience is that soc designers are _really_ good at stitching
randoms stuff together. So you need to deal with non-radeon drivers
very likely, too.

Also the real problem isn't really the memory sharing - we have
dma-buf already and could add a special mmap flag to make sure it will
work with svm/iommuv2. The problem is synchronization (either with the
new struct fence stuff from Maarten or with android syncpoints or
something like that). And for that to be possible you need to go
through the kernel.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch

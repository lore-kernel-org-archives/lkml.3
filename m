Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbaGPIVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:21:20 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:40397 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaGPIVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:21:15 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <D89D60253BB73A4E8C62F9FD18A939CA01050211@storexdag02.amd.com>
References: <20140710222423.GA14219@gmail.com>
	<019CCE693E457142B37B791721487FD91809E4C2@storexdag01.amd.com>
	<20140711211850.GU1870@gmail.com>
	<019CCE693E457142B37B791721487FD9180A193B@storexdag01.amd.com>
	<20140713035535.GB5301@gmail.com>
	<D89D60253BB73A4E8C62F9FD18A939CA0103C0EB@storexdag02.amd.com>
	<20140713164901.GB10624@gmail.com>
	<53C396D3.9000600@vodafone.de>
	<CAPM=9txM=0Rd8sP56X1v2sXhAYiRJDoz-j8+N0wXpam-+kYJ8Q@mail.gmail.com>
	<D89D60253BB73A4E8C62F9FD18A939CA01050131@storexdag02.amd.com>
	<20140715173704.GA3421@gmail.com>
	<D89D60253BB73A4E8C62F9FD18A939CA01050211@storexdag02.amd.com>
Date: Wed, 16 Jul 2014 10:21:14 +0200
X-Google-Sender-Auth: AB4mR76UF-tGUcHdYFpJ6jsfyTc
Message-ID: <CAKMK7uHzfb5nPbpoO1-gQp=wzRdWoNggXnEkQj9Pnkr6hKZB4g@mail.gmail.com>
Subject: Re: [PATCH 00/83] AMD HSA kernel driver
From: Daniel Vetter <daniel@ffwll.ch>
To: "Bridgman, John" <John.Bridgman@amd.com>
Cc: Jerome Glisse <j.glisse@gmail.com>,
        "Lewycky, Andrew" <Andrew.Lewycky@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 7:53 PM, Bridgman, John <John.Bridgman@amd.com> wrote:
[snip away the discussion about hsa device discover, I'm hijacking
this thread just for the event/fence stuff here.]

> ... There's an event mechanism still to come - mostly for communicating fences and shader interrupts back to userspace, but also used for "device change" notifications, so no polling of sysfs.

That could would be interesting. On i915 my plan is to internally use
the recently added struct fence from Maarten. For the external
interface for userspace that wants explicit control over fences I'm
leaning towards polishing the android syncpt stuff (currently in
staging). But in any case I _really_ want to avoid that we end up with
multiple different and incompatible explicit fencing interfaces on
linux.

Adding relevant people.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch

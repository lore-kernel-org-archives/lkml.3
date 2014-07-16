Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759783AbaGPI1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:27:49 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:60087 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759628AbaGPI1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:27:43 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <20140715180445.GB3421@gmail.com>
References: <20140711211850.GU1870@gmail.com>
	<019CCE693E457142B37B791721487FD9180A193B@storexdag01.amd.com>
	<20140713035535.GB5301@gmail.com>
	<D89D60253BB73A4E8C62F9FD18A939CA0103C0EB@storexdag02.amd.com>
	<20140713164901.GB10624@gmail.com>
	<53C396D3.9000600@vodafone.de>
	<CAPM=9txM=0Rd8sP56X1v2sXhAYiRJDoz-j8+N0wXpam-+kYJ8Q@mail.gmail.com>
	<D89D60253BB73A4E8C62F9FD18A939CA01050131@storexdag02.amd.com>
	<20140715173704.GA3421@gmail.com>
	<D89D60253BB73A4E8C62F9FD18A939CA01050211@storexdag02.amd.com>
	<20140715180445.GB3421@gmail.com>
Date: Wed, 16 Jul 2014 10:27:42 +0200
X-Google-Sender-Auth: _sWUtbw5y1tpuxS8NT8_64ENCs4
Message-ID: <CAKMK7uEohJaiNCdDeV-6GNtH=0YSsw-o8V1zMYtOFEnkbOK+wA@mail.gmail.com>
Subject: Re: [PATCH 00/83] AMD HSA kernel driver
From: Daniel Vetter <daniel@ffwll.ch>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: "Bridgman, John" <John.Bridgman@amd.com>,
        "Lewycky, Andrew" <Andrew.Lewycky@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 8:04 PM, Jerome Glisse <j.glisse@gmail.com> wrote:
>> Yes although it can be skipped on most systems. We figured that topology
>> needed to cover everything that would be handled by a single OS image, so
>> in a NUMA system it would need to cover all the CPUs. I think that is still
>> the right scope, do you agree ?
>
> I think it is a idea to duplicate cpu. I would rather have each device
> give its afinity against each cpu and for cpu just keep the existing
> kernel api that expose this through sysfs iirc.

It's all there already if we fix up the hsa dev-node model to expose
one dev node per underlying device instead of one for everything:
- cpus already expose the full numa topology in sysfs
- pci devices have a numa_node file in sysfs to display the link
- we can easily add similar stuff for platform devices on arm socs
without pci devices.

Then the only thing userspace needs to do is follow the device link in
the hsa instance node in sysfs and we have all the information
exposed. Iff we expose one hsa driver instance to userspace per
physical device (which is the normal linux device driver model
anyway).

I don't see a need to add anything hsa specific here at all (well
maybe some description of the cache architecture on the hsa device
itself, the spec seems to have provisions for that).
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch

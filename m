Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029AbaGMJnJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 05:43:09 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:33804 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbaGMJm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 05:42:59 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <20140712164928.GA5301@gmail.com>
References: <1405028727-5276-1-git-send-email-oded.gabbay@amd.com>
	<20140710222423.GA14219@gmail.com>
	<019CCE693E457142B37B791721487FD91809E4C2@storexdag01.amd.com>
	<20140711211850.GU1870@gmail.com>
	<53C0FEE1.50206@amd.com>
	<20140712111032.GV17271@phenom.ffwll.local>
	<20140712164928.GA5301@gmail.com>
Date: Sun, 13 Jul 2014 11:42:58 +0200
X-Google-Sender-Auth: XY3B46hB4zNTxafGanZ7LJzSUKY
Message-ID: <CAKMK7uEfccyxzEy3HvAqJEZWWF6-brf81EmBEg47xtrhCT_txA@mail.gmail.com>
Subject: Re: [PATCH 00/83] AMD HSA kernel driver
From: Daniel Vetter <daniel@ffwll.ch>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        "Gabbay, Oded" <Oded.Gabbay@amd.com>,
        "oded.gabbay@gmail.com" <oded.gabbay@gmail.com>,
        "Lewycky, Andrew" <Andrew.Lewycky@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 6:49 PM, Jerome Glisse <j.glisse@gmail.com> wrote:
>> Hm, so the hsa part is a completely new driver/subsystem, not just an
>> additional ioctl tacked onto radoen? The history of drm is littered with
>> "generic" ioctls that turned out to be useful for exactly one driver.
>> Which is why _all_ the command submission is now done with driver-private
>> ioctls.
>>
>> I'd be quite a bit surprised if that suddenly works differently, so before
>> we bless a generic hsa interface I really want to see some implementation
>> from a different vendor (i.e. nvdidia or intel) using the same ioctls.
>> Otherwise we just repeat history and I'm not terribly inclined to keep on
>> cleanup up cruft forever - one drm legacy is enough ;-)
>>
>> Jesse is the guy from our side to talk to about this.
>> -Daniel
>
> I am not worried about that side, the hsa foundation has pretty strict
> guidelines on what is hsa compliant hardware ie the hw needs to understand
> the pm4 packet format of radeon (well small subset of it). But of course
> this require hsa compliant hardware and from member i am guessing ARM Mali,
> ImgTech, Qualcomm, ... so unless Intel and NVidia joins hsa you will not
> see it for those hardware.
>
> So yes for once same ioctl would apply to different hardware. The only things
> that is different is the shader isa. The hsafoundation site has some pdf
> explaining all that but someone thought that slideshare would be a good idea
> personnaly i would not register to any of the website just to get the pdf.
>
> So to sumup i am ok with having a new device file that present uniform set
> of ioctl. It would actualy be lot easier for userspace, just open this fix
> device file and ask for list of compliant hardware.
>
> Then radeon kernel driver would register itself as a provider. So all ioctl
> decoding marshalling would be share which makes sense.

There's also the other side namely that preparing the cp ring in
userspace and submitting the entire pile through a doorbell to the hw
scheduler isn't really hsa exclusive. And for a solid platform with
seamless gpu/cpu integration that means we need standard ways to set
gpu context priorities and get at useful stats like gpu time used by a
given context.

To get there I guess intel/nvidia need to reuse the hsa subsystem with
the command submission adjusted a bit. Kinda like drm where kms and
buffer sharing is common and cs driver specific.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch

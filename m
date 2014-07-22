Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800AbaGVPT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:19:58 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:45476 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbaGVPT5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:19:57 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <53CE77B4.6020801@amd.com>
References: <20140709093124.11354.3774.stgit@patser>
	<20140709122953.11354.46381.stgit@patser>
	<CAPM=9tyD2ZbrcGDC3hfNb7qNdzsfnyD-ZwM7G-nOgxeu5YKuSg@mail.gmail.com>
	<53CE2421.5040906@amd.com>
	<20140722114607.GL15237@phenom.ffwll.local>
	<20140722115737.GN15237@phenom.ffwll.local>
	<53CE56ED.4040109@vodafone.de>
	<53CE6FB0.90500@canonical.com>
	<53CE7410.3090603@amd.com>
	<53CE74B5.3000201@canonical.com>
	<53CE77B4.6020801@amd.com>
Date: Tue, 22 Jul 2014 17:19:56 +0200
X-Google-Sender-Auth: Q8pdSbxp6cjTx0YpUs7KaqUQedo
Message-ID: <CAKMK7uESXrDtCov8whOTsffg6eZdibF4qaTFaCubM=mnhN=gNQ@mail.gmail.com>
Subject: Re: [PATCH 09/17] drm/radeon: use common fence implementation for fences
From: Daniel Vetter <daniel@ffwll.ch>
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <deathsimple@vodafone.de>,
        Dave Airlie <airlied@gmail.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "Deucher, Alexander" <alexander.deucher@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 4:39 PM, Christian König
<christian.koenig@amd.com> wrote:
> Am 22.07.2014 16:27, schrieb Maarten Lankhorst:
>
>> op 22-07-14 16:24, Christian König schreef:
>>>>
>>>> No, you really shouldn't be doing much in the check anyway, it's meant
>>>> to be a lightweight check. If you're not ready yet because of a lockup
>>>> simply return not signaled yet.
>>>
>>> It's not only the lockup case from radeon I have in mind here. For
>>> userspace queues it might be necessary to call copy_from_user to figure out
>>> if a fence is signaled or not.
>>>
>>> Returning false all the time is probably not a good idea either.
>>
>> Having userspace implement a fence sounds like an awful idea, why would
>> you want to do that?
>
>
> Marketing moves in mysterious ways. Don't ask me, but that the direction it
> currently moves with userspace queues and IOMMU etc...

Fence-based syncing between userspace queues submitted stuff through
doorbells and anything submitted by the general simply wont work.
Which is why I think the doorbell is a stupid interface since I just
don't see cameras and v4l devices implementing all that complexity to
get a pure userspace side sync solution.

But that's a different problem really, and I guess marketing will
eventually figure this one out, too.
-Daniel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713AbaGWJzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 05:55:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47948 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbaGWJzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 05:55:38 -0400
Message-ID: <53CF8693.1040006@canonical.com>
Date: Wed, 23 Jul 2014 11:55:31 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>
CC: Thomas Hellstrom <thellstrom@vmware.com>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "Deucher, Alexander" <alexander.deucher@amd.com>
Subject: Re: [Nouveau] [PATCH 09/17] drm/radeon: use common fence implementation
 for fences
References: <20140709093124.11354.3774.stgit@patser>	<53CE8A57.2000803@vodafone.de>	<53CF58FB.8070609@canonical.com>	<53CF5B9F.1050800@amd.com>	<53CF5EFE.6070307@canonical.com>	<53CF63C2.7070407@vodafone.de>	<CAKMK7uGJj+UwcnnzA+fj_=uWPN3i0sneWkoD+wfPJ_8Q6Y-DQg@mail.gmail.com>	<53CF6622.6060803@amd.com>	<53CF699D.9070902@canonical.com>	<53CF6B18.5070107@vodafone.de>	<CAKMK7uGd65HR11thcv8KjDw-RnTa7W-QGOzFGFd+oO_hp8wyHA@mail.gmail.com>	<53CF7035.2060808@amd.com>	<53CF7191.2090008@canonical.com>	<CAKMK7uGLqzePAREsWhX0D1oN4FdqKwPgAL6x8sULpJSqYH5LwA@mail.gmail.com>	<53CF765E.7020802@vodafone.de>	<CAKMK7uE1G-EjbJ2RAXC3ZfkaCo=Gber5PJuRG623Yoz9D=FmGw@mail.gmail.com>	<53CF8010.9060809@amd.com>	<CAKMK7uEowhvc+4Jc6t2NAeE1joFaohJ6cP7sU-Akut6b3ta=1g@mail.gmail.com>	<53CF822E.7050601@amd.com>	<CAKMK7uG85KV94PTqkzvY8RPxg6ApRKHVZrD20e48GHZM=s06=w@mail.gmail.com> <CAKMK7uHEgdU+Uz-OnRGvT_wFjOXHpZmgZcrORsBrST_MY5_ADA@mail.gmail .com> <53CF84C7.2020507@vodafone.de>
In-Reply-To: <53CF84C7.2020507@vodafone.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

op 23-07-14 11:47, Christian König schreef:
> Am 23.07.2014 11:44, schrieb Daniel Vetter:
>> On Wed, Jul 23, 2014 at 11:39 AM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>>> The scheduler needs to keep track of a lot of fences, so I think we'll
>>> have to register callbacks, not a simple wait function. We must keep
>>> track of all the non-i915 fences for all oustanding batches. Also, the
>>> scheduler doesn't eliminate the hw queue, only keep it much slower so
>>> that we can sneak in higher priority things.
>>>
>>> Really, scheduler or not is orthogonal.
>> Also see my other comment about interactions between wait_fence and
>> the i915 reset logic. We can't actually use it from within the
>> scheduler code since that would deadlock.
>
> Yeah, I see. You would need some way to abort the waiting on other devices fences in case of a lockup.
>
> What about an userspace thread to offload waiting and command submission to?
You would still need enable_signaling, else polling on the dma-buf wouldn't work. ;-)
Can't wait synchronously with multiple shared fences, need to poll for that.
And the dma-buf would still have fences belonging to both drivers, and it would still call from outside the driver.

~Maarten


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747AbaGWJie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 05:38:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47848 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757486AbaGWJid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 05:38:33 -0400
Message-ID: <53CF828E.5020201@canonical.com>
Date: Wed, 23 Jul 2014 11:38:22 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
CC: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "Deucher, Alexander" <alexander.deucher@amd.com>
Subject: Re: [Nouveau] [PATCH 09/17] drm/radeon: use common fence implementation
 for fences
References: <20140709093124.11354.3774.stgit@patser>	<53CE6AFA.1060807@vodafone.de>	<CAKMK7uG1d31zU_i__wc+Yq46A0x0tPeKnMBs+NHSmHS82uMsXQ@mail.gmail.com>	<53CE84AA.9030703@amd.com>	<CAKMK7uFa8vMBV9_JenbFGnFXtV_r9dk=WjbMkkCDWcauhrDdJg@mail.gmail.com>	<53CE8A57.2000803@vodafone.de>	<53CF58FB.8070609@canonical.com>	<53CF5B9F.1050800@amd.com>	<53CF5EFE.6070307@canonical.com>	<53CF63C2.7070407@vodafone.de>	<CAKMK7uGJj+UwcnnzA+fj_=uWPN3i0sneWkoD+wfPJ_8Q6Y-DQg@mail.gmail.com>	<53CF6622.6060803@amd.com>	<53CF699D.9070902@canonical.com>	<53CF6B18.5070107@vodafone.de>	<CAKMK7uGd65HR11thcv8KjDw-RnTa7W-QGOzFGFd+oO_hp8wyHA@mail.gmail.com>	<53CF7035.2060808@amd.com>	<53CF7191.2090008@canonical.com>	<CAKMK7uGLqzePAREsWhX0D1oN4FdqKwPgAL6x8sULpJSqYH5LwA@mail.gmail.com>	<53CF765E.7020802@vodafone.de>	<CAKMK7uE1G-EjbJ2RAXC3ZfkaCo=Gber5PJuRG623Yoz9D=FmGw@mail.gmail.com>	<53CF8010.9060809@amd.com> <CAKMK7uEowhvc+4Jc6t2NAeE1joFaohJ6cP7sU-Akut6b3ta=1g@mail.gmail.com> <53CF822E.7050601@amd.com>
In-Reply-To: <53CF822E.7050601@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

op 23-07-14 11:36, Christian König schreef:
> Am 23.07.2014 11:30, schrieb Daniel Vetter:
>> On Wed, Jul 23, 2014 at 11:27 AM, Christian König
>> <christian.koenig@amd.com> wrote:
>>> You submit a job to the hardware and then block the job to wait for radeon
>>> to be finished? Well than this would indeed require a hardware reset, but
>>> wouldn't that make the whole problem even worse?
>>>
>>> I mean currently we block one userspace process to wait for other hardware
>>> to be finished with a buffer, but what you are describing here blocks the
>>> whole hardware to wait for other hardware which in the end blocks all
>>> userspace process accessing the hardware.
>> There is nothing new here with prime - if one context hangs the gpu it
>> blocks everyone else on i915.
>>
>>> Talking about alternative approaches wouldn't it be simpler to just offload
>>> the waiting to a different kernel or userspace thread?
>> Well this is exactly what we'll do once we have the scheduler. But
>> this is an orthogonal issue imo.
>
> Mhm, could have the scheduler first?
>
> Cause that sounds like reducing the necessary fence interface to just a fence->wait function.
You would also lose benefits like having a 'perf timechart' for gpu's.

~Maarten


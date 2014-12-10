Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbaLJOzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 09:55:05 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:56106 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423AbaLJOzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 09:55:03 -0500
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <CAKMK7uHNeM9ebkpWKi30zz73-xferz39WQMvh6G4SrKAJyFxjw@mail.gmail.com>
References: <20141210140306.GC32722@mwanda>
	<CAKMK7uHNeM9ebkpWKi30zz73-xferz39WQMvh6G4SrKAJyFxjw@mail.gmail.com>
Date: Wed, 10 Dec 2014 15:55:02 +0100
Message-ID: <CAKMK7uGg7cpKvU=VUgDBmeNYVrj-8yeSv=RBVruMrWkZorhESg@mail.gmail.com>
Subject: Re: [drm-intel:topic/core-stuff 32/37] drivers/gpu/drm/drm_crtc.c:4472
 drm_mode_crtc_set_gamma_size() warn: double check that we're allocating
 correct size: 2 vs 6
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: kbuild@01.org, Thierry Reding <treding@nvidia.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgotten to add mailing lists.
-Daniel

On Wed, Dec 10, 2014 at 3:53 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> On Wed, Dec 10, 2014 at 3:03 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>> From a style prespective this should be:
>>
>>         crtc->gamma_store = kcalloc(gamma_size * 3, sizeof(uint16_t),
>>                                     GFP_KERNEL);
>>
>> Because the elements are sizeof(uint16_t), we are allocating 3
>> arrays of gamma_size elements.  But I guess it's nice to move all the
>> constants to one side of the equation so that it tests for integer
>> overflows...  Whatever you decided is fine, this is a one time email
>> that is auto-genenerated.
>
> Imo the point of kcalloc and kmalloc_array is to get the overflow
> checks correct. Putting the *3 to the gamma_size (which can be fairly
> big and migth come from dubios places) means we still have to deal
> with overflow headaches. sizeof(uint16_t)*3 is trivial to see that
> it's not overflowing.
>
> I think your style guide here is exactly _not_ what we should do as
> best practice for safe code.
> -Daniel
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch

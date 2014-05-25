Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbaEYMgc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 08:36:32 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:45303 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbaEYMgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 08:36:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140521131712.GG14357@phenom.ffwll.local>
References: <1400674586-17968-1-git-send-email-dh.herrmann@gmail.com>
	<20140521131712.GG14357@phenom.ffwll.local>
Date: Sun, 25 May 2014 14:36:30 +0200
Message-ID: <CANq1E4T4=4Sx85_zWVNhH=LYPXWwSaxEAHAG=rdB7GkGwok=ow@mail.gmail.com>
Subject: Re: [PATCH] drm/gem: remove obsolete BUG_ON
From: David Herrmann <dh.herrmann@gmail.com>
To: David Herrmann <dh.herrmann@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Rob Clark <robdclark@gmail.com>, Dave Airlie <airlied@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, May 21, 2014 at 3:17 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Wed, May 21, 2014 at 02:16:26PM +0200, David Herrmann wrote:
>> The shmem subsystem supports relocating pages on swap-in in case it was
>> loaded into the wrong zone. This was implemented 2 years ago in:
>>
>>     commit bde05d1ccd512696b09db9dd2e5f33ad19152605
>>     Author: Hugh Dickins <hughd@google.com>
>>     Date:   Tue May 29 15:06:38 2012 -0700
>>
>>         shmem: replace page if mapping excludes its zone
>>
>> If a driver requires pages to be in a specific zone, they _must_ set the
>> correct GFP flags (like __GFP_DMA32) in mapping_gfp_mask(mapping). shmem
>> will make sure that any page leaving the swap-cache is located in a
>> compatible zone.
>>
>> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
>
> Imo the BUG_ON is nice since we want to make sure this never blows up. We
> have a similar one in i915_gem.c since we do have platforms with 32bit
> limits that support more than 4G or ram.
>
> Imo better to update the comment and state that this is fixed now, but
> better be paranoid.

Ok, I've kept the BUG_ON. I've also appended some more patches that
clean-up the shmem handling. v2 is on the list.

Thanks
David

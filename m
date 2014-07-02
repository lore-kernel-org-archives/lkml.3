Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaGBJNB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 05:13:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44065 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbaGBJM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 05:12:58 -0400
Message-ID: <53B3CD00.5030003@canonical.com>
Date: Wed, 02 Jul 2014 11:12:32 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-arch@vger.kernel.org, thellstrom@vmware.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, robdclark@gmail.com,
        thierry.reding@gmail.com, ccross@google.com, daniel@ffwll.ch,
        sumit.semwal@linaro.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 0/9] Updated fence patch series
References: <20140701103432.12718.82795.stgit@patser> <20140702053758.GA7578@kroah.com>
In-Reply-To: <20140702053758.GA7578@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

op 02-07-14 07:37, Greg KH schreef:
> On Tue, Jul 01, 2014 at 12:57:02PM +0200, Maarten Lankhorst wrote:
>> So after some more hacking I've moved dma-buf to its own subdirectory,
>> drivers/dma-buf and applied the fence patches to its new place. I believe that the
>> first patch should be applied regardless, and the rest should be ready now.
>> :-)
>>
>> Changes to the fence api:
>> - release_fence -> fence_release etc.
>> - __fence_init -> fence_init
>> - __fence_signal -> fence_signal_locked
>> - __fence_is_signaled -> fence_is_signaled_locked
>> - Changing BUG_ON to WARN_ON in fence_later, and return NULL if it triggers.
>>
>> Android can expose fences to userspace. It's possible to make the new fence
>> mechanism expose the same fences to userspace by changing sync_fence_create
>> to take a struct fence instead of a struct sync_pt. No other change is needed,
>> because only the fence parts of struct sync_pt are used. But because the
>> userspace fences are a separate problem and I haven't really looked at it yet
>> I feel it should stay in staging, for now.
> Ok, that's reasonable.
>
> At first glance, this all looks "sane" to me, any objection from anyone
> if I merge this through my driver-core tree for 3.17?
>
Sounds good to me, let me know when you pull it in, so I can rebase my drm conversion on top of it. :-)

~Maarten

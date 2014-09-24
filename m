Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbaIXPaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:30:52 -0400
Received: from lists.s-osg.org ([54.187.51.154]:37441 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611AbaIXPau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:30:50 -0400
Message-ID: <5422E3A7.7060607@osg.samsung.com>
Date: Wed, 24 Sep 2014 09:30:47 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, m.chehab@samsung.com,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org, crope@iki.fi,
        olebowle@gmx.com, dheitmueller@kernellabs.com, ramakrmu@cisco.com,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com
CC: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 2/5] media: v4l2-core changes to use media tuner token
 api
References: <cover.1411397045.git.shuahkh@osg.samsung.com> <b83cf780636a80aec53e3b7e8f101645049e94f3.1411397045.git.shuahkh@osg.samsung.com> <5422B1B8.1080401@xs4all.nl>
In-Reply-To: <5422B1B8.1080401@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2014 05:57 AM, Hans Verkuil wrote:
> Hi Shuah,
> 
> Here is my review...
> 
> On 09/22/2014 05:00 PM, Shuah Khan wrote:
>> Changes to v4l2-core to hold tuner token in v4l2 ioctl that change
>> the tuner modes, and reset the token from fh exit. The changes are
>> limited to vb2 calls that disrupt digital stream. vb1 changes are
>> made in the driver. The following ioctls are changed:
>>
>> S_INPUT, S_OUTPUT, S_FMT, S_TUNER, S_MODULATOR, S_FREQUENCY,
> 
> S_MODULATOR doesn't need to take a token. Certainly not a tuner token,
> since it is a modulator, not a tuner. There aren't many modulator drivers,
> and none of them have different modes.
> 
> The same is true for S_OUTPUT: it deals with outputs, so it has nothing
> to do with tuners since those are for input.
> 
>> S_STD, S_HW_FREQ_SEEK:
>>
>> - hold tuner in shared analog mode before calling appropriate
>>    ops->vidioc_s_*
>> - return leaving tuner in shared mode.
>> - Note that S_MODULATOR is now implemented in the core
>>    previously FCN.
>>
>> QUERYSTD:
>> - hold tuner in shared analog mode before calling
>>    ops->vidioc_querystd
>> - return after calling put tuner - this simply decrements the
>>    owners. Leaves tuner in shared analog mode if owners > 0
> 
> I would handle QUERYSTD the same as the ones in the first group.
> It's a fair assumption that once you call QUERYSTD you expect to
> switch the tuner to analog mode and keep it there.
> 
> I'm missing STREAMON in this list as well.
> 
> With regards to G_TUNER and ENUM_INPUT, I will reply to the post that
> discusses that topic.

Hans,

Didn't see you address G_TUNER and ENUM_INPUT in your other response.
Hope I didn't miss it.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978

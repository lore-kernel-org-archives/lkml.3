Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbbA2LZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 06:25:51 -0500
Received: from aer-iport-4.cisco.com ([173.38.203.54]:22842 "EHLO
	aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447AbbA2LZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 06:25:48 -0500
X-Greylist: delayed 587 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Jan 2015 06:25:47 EST
X-IronPort-AV: E=Sophos;i="5.09,485,1418083200"; 
   d="scan'208";a="326815598"
Message-ID: <54CA166B.6000101@cisco.com>
Date: Thu, 29 Jan 2015 12:15:55 +0100
From: Hans Verkuil <hansverk@cisco.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Davidlohr Bueso <dave@stgolabs.net>, Shuah Khan <shuahkh@osg.samsung.com>
CC: m.chehab@samsung.com, hans.verkuil@cisco.com, dheitmueller@kernellabs.com,
        prabhakar.csengg@gmail.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, ttmesterr@gmail.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] media: au0828 - convert to use videobuf2
References: <1422042075-7320-1-git-send-email-shuahkh@osg.samsung.com>	 <54C96D4C.6070200@osg.samsung.com> <1422530027.4604.32.camel@stgolabs.net>
In-Reply-To: <1422530027.4604.32.camel@stgolabs.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: hansverk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/29/15 12:13, Davidlohr Bueso wrote:
> On Wed, 2015-01-28 at 16:14 -0700, Shuah Khan wrote:
>> On 01/23/2015 12:41 PM, Shuah Khan wrote:
>>> Convert au0828 to use videobuf2. Tested with NTSC.
>>> Tested video and vbi devices with xawtv, tvtime,
>>> and vlc. Ran v4l2-compliance to ensure there are
>>> no failures. 
>>>
>>> Video compliance test results summary:
>>> Total: 75, Succeeded: 75, Failed: 0, Warnings: 18
>>>
>>> Vbi compliance test results summary:
>>> Total: 75, Succeeded: 75, Failed: 0, Warnings: 0
>>>
>>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>>> ---
>>
>> Hi Hans,
>>
>> Please don't pull this in. Found a bug in stop_streaming() when
>> re-tuning that requires re-working this patch.
> 
> ... and also:
> 
>  drivers/media/usb/au0828/Kconfig        |   2 +-
>  drivers/media/usb/au0828/au0828-vbi.c   | 122 ++--
>  drivers/media/usb/au0828/au0828-video.c | 962 ++++++++++++--------------------
>  drivers/media/usb/au0828/au0828.h       |  61 +-
>  4 files changed, 443 insertions(+), 704 deletions(-)
> 
> in a single patch. Lets be nice to reviewers, we can spare a few extra
> hash ids.

You can't split this up, it's one of those changes that is all or
nothing.

Regards,

	Hans

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbbA2BoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:44:13 -0500
Received: from lists.s-osg.org ([54.187.51.154]:41414 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757225AbbA2BoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:44:11 -0500
Message-ID: <54C96D4C.6070200@osg.samsung.com>
Date: Wed, 28 Jan 2015 16:14:20 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: m.chehab@samsung.com, hans.verkuil@cisco.com, dheitmueller@kernellabs.com,
        prabhakar.csengg@gmail.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, ttmesterr@gmail.com
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] media: au0828 - convert to use videobuf2
References: <1422042075-7320-1-git-send-email-shuahkh@osg.samsung.com>
In-Reply-To: <1422042075-7320-1-git-send-email-shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2015 12:41 PM, Shuah Khan wrote:
> Convert au0828 to use videobuf2. Tested with NTSC.
> Tested video and vbi devices with xawtv, tvtime,
> and vlc. Ran v4l2-compliance to ensure there are
> no failures. 
> 
> Video compliance test results summary:
> Total: 75, Succeeded: 75, Failed: 0, Warnings: 18
> 
> Vbi compliance test results summary:
> Total: 75, Succeeded: 75, Failed: 0, Warnings: 0
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---

Hi Hans,

Please don't pull this in. Found a bug in stop_streaming() when
re-tuning that requires re-working this patch.

stop_streaming() calls is doing more than it should while
holding slock triggering lock warning.

It shouldn't call
v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 0);

while holding slock triggering lock warning.

I will send patch v6.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978

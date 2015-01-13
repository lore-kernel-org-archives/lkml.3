Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbbAMCIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 21:08:15 -0500
Received: from lists.s-osg.org ([54.187.51.154]:47805 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbbAMCIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 21:08:14 -0500
Message-ID: <54B47E0C.50500@osg.samsung.com>
Date: Mon, 12 Jan 2015 19:08:12 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, m.chehab@samsung.com,
        hans.verkuil@cisco.com, dheitmueller@kernellabs.com,
        prabhakar.csengg@gmail.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, ttmesterr@gmail.com
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] media: au0828 remove video and vbi buffer timeout
 work-around
References: <cover.1418918401.git.shuahkh@osg.samsung.com> <7210fb24807adf46f76197a12dab11358f4dcd30.1418918402.git.shuahkh@osg.samsung.com> <54B3D5D5.9060602@xs4all.nl>
In-Reply-To: <54B3D5D5.9060602@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2015 07:10 AM, Hans Verkuil wrote:
> On 12/18/2014 05:20 PM, Shuah Khan wrote:
>> au0828 does video and vbi buffer timeout handling to prevent
>> applications such as tvtime from hanging by ensuring that the
>> video frames continue to be delivered even when the ITU-656
>> input isn't receiving any data. This work-around is complex
>> as it introduces set and clear tier code paths in start/stop
>> streaming, and close interfaces. After the vb2 conversion, the
>> timeout handling is introducing instability as well as feeding
>> too many blank green screens, resulting in degraded video quality.
> 
> Why would this result in degraded video quality? And which instability
> exactly?

What I noticed was that I was seeing a few too many green screens
and I had to re-tune xawtv when the timeout code is in place. My
thinking was that this timeout handling could be introducing blank
green frames when there is no need. However, I can't reproduce the
problem on 3.19-rc4 base which is what I am using to test the changes
to the patch series. Hence, I am not positive if the timeout code
indeed was doing anything bad.

> 
>> Without this timeout handling, both xawtv, and tvtime are working
>> well with good quality video.

I am seeing tvtime hangs.

> 
> Erm, tvtime without the recent 'tvtime: don't block indefinitely waiting
> for frames' patch will not work well with au0828 without the timeout code
> if there is no valid video data.
> 
> This should at minimum be mentioned in the commit log.

I will resend the patch with the updated commit log knowing full well
that it might not be accepted.

I do have to re-cut the patch after the changes to address your
comments on the vb2 conversion patch. It applies, with fuzz, so
I decided to re-cut the patch.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978

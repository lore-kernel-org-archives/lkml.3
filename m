Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbbAWTgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 14:36:23 -0500
Received: from lists.s-osg.org ([54.187.51.154]:54275 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756466AbbAWTgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 14:36:19 -0500
Message-ID: <54C2A2B1.2020301@osg.samsung.com>
Date: Fri, 23 Jan 2015 12:36:17 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, m.chehab@samsung.com,
        hans.verkuil@cisco.com, dheitmueller@kernellabs.com,
        prabhakar.csengg@gmail.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, ttmesterr@gmail.com
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] media: au0828 - convert to use videobuf2
References: <1421970125-8169-1-git-send-email-shuahkh@osg.samsung.com> <54C21952.7010602@xs4all.nl> <54C26204.9000106@osg.samsung.com> <54C29E3E.7010009@osg.samsung.com>
In-Reply-To: <54C29E3E.7010009@osg.samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2015 12:17 PM, Shuah Khan wrote:
> On 01/23/2015 08:00 AM, Shuah Khan wrote:
>> On 01/23/2015 02:50 AM, Hans Verkuil wrote:
>>> Hi Shuah,
>>>
>>> On 01/23/2015 12:42 AM, Shuah Khan wrote:
>>>> Convert au0828 to use videobuf2. Tested with NTSC.
>>>> Tested video and vbi devices with xawtv, tvtime,
>>>> and vlc. Ran v4l2-compliance to ensure there are
>>>> no regressions. video now has no failures and vbi
>>>> has 3 fewer failures.
>>>>
>>>> video before:
>>>> test VIDIOC_G_FMT: FAIL 3 failures
>>>> Total: 72, Succeeded: 69, Failed: 3, Warnings: 0
>>>>
>>>> Video after:
>>>> Total: 72, Succeeded: 72, Failed: 0, Warnings: 18
>>>>
>>>> vbi before:
>>>>     test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: FAIL
>>>>     test VIDIOC_EXPBUF: FAIL
>>>>     test USERPTR: FAIL
>>>>     Total: 72, Succeeded: 66, Failed: 6, Warnings: 0
>>>>
>>>> vbi after:
>>>>     test VIDIOC_QUERYCAP: FAIL
>>>>     test MMAP: FAIL
>>>>     Total: 78, Succeeded: 75, Failed: 3, Warnings: 0
>>>
>>> There shouldn't be any fails for VBI. That really needs to be fixed.
>>> Esp. the QUERYCAP fail should be easy to fix.
>>>
>>> BTW, can you paste the full v4l2-compliance output next time? That's
>>> more informative than just these summaries.
>>>
>>
>> I will re-run the tests and fix it and resend the patch. I think I was
>> seeing querycap compliance failure when run with -V0 option and not when
>> I run it without. I can attach the full log.
>>
> 
> Hi Hans,
> 
> Finally some sanity. When I ran the compliance test on vbi device
> with incorrect options, hence it was treated as a video device which
> explains the following fail message:
> fail: v4l2-compliance.cpp(347): node->is_video && !(dcaps & video_caps)
> 	test VIDIOC_QUERYCAP: FAIL
> 
> This is my bad - I must have did command recall and just changed the
> device file. Sorry for the confusion.
> 
> Re-ran the test correctly this time and I don't see any querycap errors.
> Please see attached files for vbi and video. I will resend the patch
> with updated change log with the correct results.
> 
TRY_FMT and S_FMT both don't handle invalid pixelformats. Looks like
there is reason behind this based on the comments:

 /* format->fmt.pix.width only support 720 and height 480 */
        if (width != 720)
                width = 720;
        if (height != 480)
                height = 480;

-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978

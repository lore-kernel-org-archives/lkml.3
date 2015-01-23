Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbbAWJuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 04:50:44 -0500
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:54765 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753186AbbAWJuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 04:50:40 -0500
Message-ID: <54C21952.7010602@xs4all.nl>
Date: Fri, 23 Jan 2015 10:50:10 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Shuah Khan <shuahkh@osg.samsung.com>, m.chehab@samsung.com,
        hans.verkuil@cisco.com, dheitmueller@kernellabs.com,
        prabhakar.csengg@gmail.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, ttmesterr@gmail.com
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] media: au0828 - convert to use videobuf2
References: <1421970125-8169-1-git-send-email-shuahkh@osg.samsung.com>
In-Reply-To: <1421970125-8169-1-git-send-email-shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shuah,

On 01/23/2015 12:42 AM, Shuah Khan wrote:
> Convert au0828 to use videobuf2. Tested with NTSC.
> Tested video and vbi devices with xawtv, tvtime,
> and vlc. Ran v4l2-compliance to ensure there are
> no regressions. video now has no failures and vbi
> has 3 fewer failures.
> 
> video before:
> test VIDIOC_G_FMT: FAIL 3 failures
> Total: 72, Succeeded: 69, Failed: 3, Warnings: 0
> 
> Video after:
> Total: 72, Succeeded: 72, Failed: 0, Warnings: 18
> 
> vbi before:
>     test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: FAIL
>     test VIDIOC_EXPBUF: FAIL
>     test USERPTR: FAIL
>     Total: 72, Succeeded: 66, Failed: 6, Warnings: 0
> 
> vbi after:
>     test VIDIOC_QUERYCAP: FAIL
>     test MMAP: FAIL
>     Total: 78, Succeeded: 75, Failed: 3, Warnings: 0

There shouldn't be any fails for VBI. That really needs to be fixed.
Esp. the QUERYCAP fail should be easy to fix.

BTW, can you paste the full v4l2-compliance output next time? That's
more informative than just these summaries.

Regards,

	Hans

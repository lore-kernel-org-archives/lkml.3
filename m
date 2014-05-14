Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420AbaENS0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 14:26:55 -0400
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1821 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaENS0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 14:26:53 -0400
Message-ID: <5373B556.5010101@xs4all.nl>
Date: Wed, 14 May 2014 20:26:30 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/2] media: davinci: vpif capture: upgrade the driver
 with v4l offerings
References: <1399885110-9899-1-git-send-email-prabhakar.csengg@gmail.com> <1399885110-9899-2-git-send-email-prabhakar.csengg@gmail.com> <5370997C.1060700@xs4all.nl> <CA+V-a8vMtY32gMy6BWvewL1jafEKuuL5U_J8+BbFfWWsZn0hqg@mail.gmail.com>
In-Reply-To: <CA+V-a8vMtY32gMy6BWvewL1jafEKuuL5U_J8+BbFfWWsZn0hqg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 07:28 PM, Prabhakar Lad wrote:
> Hi Hans,
> 
> Thanks for the review.
> 
> On Mon, May 12, 2014 at 3:20 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Hi Prabhakar,
>>
>> Thanks for the patch, but I have a few comments...
>>
>> On 05/12/2014 10:58 AM, Lad, Prabhakar wrote:
>>> Buffer ioctls:
>>>         test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>>>                 fail: v4l2-test-buffers.cpp(506): q.has_expbuf()
>>
>> This is weird. I'm not sure why this happens since you seem to have VB2_DMABUF set
>> and also vb2_ioctl_expbuf.
>>
>>>         test VIDIOC_EXPBUF: FAIL
>>>
>>> Total: 38, Succeeded: 35, Failed: 3, Warnings: 0
>>
>> Also test with 'v4l2-compliance -s' (streaming). The '-i' option is available to
>> test streaming from a specific input.
>>
> BTW the output is with -s option set.

Something is wrong. With -s you should see something like this:

Buffer ioctls:
        test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
        test VIDIOC_EXPBUF: OK (Not Supported)
        test read/write: OK
        test MMAP: OK                                     
        test USERPTR: OK                                  
        test DMABUF: Cannot test, specify --expbuf-device

Regards,

	Hans


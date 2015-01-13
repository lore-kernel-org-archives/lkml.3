Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbbAMCAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 21:00:15 -0500
Received: from lists.s-osg.org ([54.187.51.154]:47542 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879AbbAMCAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 21:00:14 -0500
Message-ID: <54B47C29.2020802@osg.samsung.com>
Date: Mon, 12 Jan 2015 19:00:09 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, m.chehab@samsung.com,
        hans.verkuil@cisco.com, dheitmueller@kernellabs.com,
        prabhakar.csengg@gmail.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, ttmesterr@gmail.com
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] media: au0828 - convert to use videobuf2
References: <cover.1418918401.git.shuahkh@osg.samsung.com> <14b955f13c972a55bcfeaf6734f3487c320260bb.1418918402.git.shuahkh@osg.samsung.com> <54B3D7FF.2030106@xs4all.nl>
In-Reply-To: <54B3D7FF.2030106@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2015 07:19 AM, Hans Verkuil wrote:
> On 12/18/2014 05:20 PM, Shuah Khan wrote:
>> Convert au0828 to use videobuf2. Tested with NTSC.
>> Tested video and vbi devices with xawtv, tvtime,
>> and vlc. Ran v4l2-compliance to ensure there are
>> no new regressions in video and vbi now has 3 fewer
>> failures.
>>
>> video before:
>> test VIDIOC_G_FMT: FAIL 3 failures
>> Total: 72, Succeeded: 69, Failed: 3, Warnings: 0
>>
>> Video after:
>> test VIDIOC_G_FMT: FAIL 3 failures
>> Total: 72, Succeeded: 69, Failed: 3, Warnings: 0
>>
>> vbi before:
>> test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: FAIL
>> test VIDIOC_EXPBUF: FAIL
>> test USERPTR: FAIL
>> Total: 72, Succeeded: 66, Failed: 6, Warnings: 0
>>
>> vbi after:
>> test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>> test VIDIOC_EXPBUF: OK (Not Supported)
>> test USERPTR: OK
>> Total: 72, Succeeded: 69, Failed: 3, Warnings: 0
>>
>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>> ---
>>  drivers/media/usb/au0828/Kconfig        |   2 +-
>>  drivers/media/usb/au0828/au0828-cards.c |   2 +-
>>  drivers/media/usb/au0828/au0828-vbi.c   | 122 ++--
>>  drivers/media/usb/au0828/au0828-video.c | 949 +++++++++++++-------------------
>>  drivers/media/usb/au0828/au0828.h       |  61 +-
>>  5 files changed, 444 insertions(+), 692 deletions(-)
>>
>> diff --git a/drivers/media/usb/au0828/Kconfig b/drivers/media/usb/au0828/Kconfig
>> index 1d410ac..78b797e 100644
>> --- a/drivers/media/usb/au0828/Kconfig
>> +++ b/drivers/media/usb/au0828/Kconfig
>> @@ -4,7 +4,7 @@ config VIDEO_AU0828
>>  	depends on I2C && INPUT && DVB_CORE && USB
>>  	select I2C_ALGOBIT
>>  	select VIDEO_TVEEPROM
>> -	select VIDEOBUF_VMALLOC
>> +	select VIDEOBUF2_VMALLOC
>>  	select DVB_AU8522_DTV if MEDIA_SUBDRV_AUTOSELECT
>>  	select MEDIA_TUNER_XC5000 if MEDIA_SUBDRV_AUTOSELECT
>>  	select MEDIA_TUNER_MXL5007T if MEDIA_SUBDRV_AUTOSELECT
>> diff --git a/drivers/media/usb/au0828/au0828-cards.c b/drivers/media/usb/au0828/au0828-cards.c
>> index 9eb77ac..ae2e563 100644
>> --- a/drivers/media/usb/au0828/au0828-cards.c
>> +++ b/drivers/media/usb/au0828/au0828-cards.c
>> @@ -39,7 +39,7 @@ static void hvr950q_cs5340_audio(void *priv, int enable)
>>  struct au0828_board au0828_boards[] = {
>>  	[AU0828_BOARD_UNKNOWN] = {
>>  		.name	= "Unknown board",
>> -		.tuner_type = UNSET,
>> +		.tuner_type = -1U,
>>  		.tuner_addr = ADDR_UNSET,
>>  	},
>>  	[AU0828_BOARD_HAUPPAUGE_HVR850] = {
> 
> I would split off this au0828-cards.c change into a separate patch. It has nothing to
> do with the vb2 conversion.
> 

I will split this patch and add it to the series.

-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978

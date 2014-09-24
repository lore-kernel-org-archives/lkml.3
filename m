Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbaIXN4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:56:47 -0400
Received: from lists.s-osg.org ([54.187.51.154]:37390 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754312AbaIXN4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:56:46 -0400
Message-ID: <5422CD95.7010905@osg.samsung.com>
Date: Wed, 24 Sep 2014 07:56:37 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, m.chehab@samsung.com,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org, crope@iki.fi,
        olebowle@gmx.com, dheitmueller@kernellabs.co, ramakrmu@cisco.com,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com
CC: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 1/5] media: add media token device resource framework
References: <cover.1411397045.git.shuahkh@osg.samsung.com> <78fed57ab9b3bed4269a078c9a7361bfe9ff6d92.1411397045.git.shuahkh@osg.samsung.com> <5422AA63.1070406@xs4all.nl>
In-Reply-To: <5422AA63.1070406@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2014 05:26 AM, Hans Verkuil wrote:
> Hi Shuah,
> 
> Here is my review...
> 
> On 09/22/2014 05:00 PM, Shuah Khan wrote:
>> Add media token device resource framework to allow sharing
>> resources such as tuner, dma, audio etc. across media drivers
>> and non-media sound drivers that control media hardware. The
>> Media token resource is created at the main struct device that
>> is common to all drivers that claim various pieces of the main
>> media device, which allows them to find the resource using the
>> main struct device. As an example, digital, analog, and
>> snd-usb-audio drivers can use the media token resource API
>> using the main struct device for the interface the media device
>> is attached to.
>>
>> The media token resource contains token for tuner, dma, and
>> audio.
> 
> Why dma and audio? Neither is being used in this patch series. I
> would leave them out until you actually show how they are used in a
> driver.

Yeah I can remove these. I am not using them in this series.

>> +static int __media_get_tkn(struct media_tkn *tkn,
>> +                enum media_tkn_mode mode, bool exclusive)
>> +{
>> +    int rc = 0;
>> +
>> +    spin_lock(&tkn->lock);
>> +    if (tkn->is_exclusive)
>> +        rc = -EBUSY;
>> +    else if (tkn->owners && ((mode != tkn->mode) || exclusive))
>> +        rc = -EBUSY;
>> +    else {
>> +        if (tkn->owners < INT_MAX)
>> +            tkn->owners++;
>> +        else
>> +            tkn->owners = 1;
> 
> Somewhat weird. Can owners ever become INT_MAX?
> 

I didn't have this at first. I was testing with tvtime and
noticed the count going up to 40k+ while it is streaming.
The count kept going up. So I figured I might as well add
the check to cover for cases where application like tvtime
run for a very longtime like a couple of hours.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978

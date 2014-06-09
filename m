Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbaFIRpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 13:45:35 -0400
Received: from mail.kernel.org ([198.145.19.201]:59439 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbaFIRpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 13:45:33 -0400
Message-ID: <5395F32C.10100@kernel.org>
Date: Mon, 09 Jun 2014 18:47:24 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Reyad Attiyat <reyad.attiyat@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input <linux-input@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCHv2 3/3] IIO: hid-sensor-magn-3d: Add in support for True/Magnetic
 North HID usages
References: <1401750890-31854-1-git-send-email-reyad.attiyat@gmail.com> <1401750890-31854-4-git-send-email-reyad.attiyat@gmail.com> <538E092F.9040004@linux.intel.com> <CA+BWVUTxnS_C+EXm1SuShywk998+E5KfTdtTrS6_a0+k+4U4ig@mail.gmail.com> <538F3E6A.4080905@linux.intel.com>
In-Reply-To: <538F3E6A.4080905@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/14 16:42, Srinivas Pandruvada wrote:
> On 06/04/2014 08:23 AM, Reyad Attiyat wrote:
>> Hey Srinivas,
>>
>> On Tue, Jun 3, 2014 at 12:43 PM, Srinivas Pandruvada
>> <srinivas.pandruvada@linux.intel.com> wrote:
>>
>>>
>>> May be we should have a field in const struct iio_chan_spec, so that we
>>> can dynamically enable disable channels. In this way we can statically
>>> define channels, but can be enabled/disabled dynamically.
>>>
>> Would this require changing iio subsystem to create sysfs entries only
>> when enabled? Would we need to add functions to disable and enable
>> later on?
>
> This is just a thought. You don't have to change it. I am sure Jonathan will have some opinion this.
Replied to earlier message.  If there is some common code we can factor out into
the core then I'm happy to do so, but I don't see an advantage in using
a field, rather than just tailoring the copy in the first place. e.g.

1) Pass whatever is needed to figure out how many channels are present.
2) Allocate space for that many channels.
3) Copy said channels from predefined versions, perhaps amending as necessary.

This is a reasonably common pattern in complex parts or those with hugely
variable numbers of channels...
>
>>>
>>> I think we need to present angle in radians. Are you basing change present
>>> in linux-next? This will automatically do in this function.
>>>
>> I'll look into this. What function should I use to make the iio chanel
>> to report radians?
> I think it will work if the existing sequence is maintained
>   st->scale_precision = hid_sensor_format_scale(
>                                  HID_USAGE_SENSOR_COMPASS_3D,
>                                  &st->magn[CHANNEL_SCAN_INDEX_X],
>                                  &st->scale_pre_decml, &st->scale_post_decml);
>
> So as long as you call this function, the scale value to user space will
> be returned correctly.
>
>>>
>>>
>>> I don't see kfree. Try devm_kcalloc?
>>>
>> I changed kmemdup to kcalloc so there is still a kfree in the exsiting
>> code. I can change this to devm_kcalloc but only if we don't go with
>> static channels that are enabled as found.
>>
> Since you are changing this part, devm_ calls are preferred, I think.
As long as it doesn't add complexity or possibility of race conditions,
devm calls are usually a good idea.
>
> Thanks,
> Srinivas
>
>
>> Thanks,
>> Reyad Attiyat
>>
>


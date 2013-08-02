Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016Ab3HBIZJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 04:25:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:8706 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754911Ab3HBIZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 04:25:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,799,1367996400"; 
   d="scan'208";a="379983255"
Message-ID: <51FB6D0D.4060407@intel.com>
Date: Fri, 02 Aug 2013 16:25:49 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Felipe Contreras <felipe.contreras@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH] acpi: video: fix reversed indexed BQC
References: <1375400042-989-1-git-send-email-felipe.contreras@gmail.com> <51FB137D.7070000@gmail.com> <CAMP44s1A+z4=DGJLK1qf5LPc1vbYvtJwjFiMt17vzyZFRU0qmg@mail.gmail.com> <51FB35CD.7040709@intel.com> <CAMP44s1honSdnoMnmpEcsXtdkJuPYgQgnLwcN+oxs5f=a+3Stg@mail.gmail.com> <51FB3C9C.6070002@intel.com> <CAMP44s1RkwTfxdoiARHgREy-fwLuRu2tKbM-4kB3+Xf3Sme5Uw@mail.gmail.com> <51FB5826.80305@intel.com> <CAMP44s3+L8ZY9tcUbNhia8sRx+KJ1w44Jn7n=RMdPfeQqvPaqw@mail.gmail.com> <51FB689F.30100@intel.com> <CAMP44s3mgbis8BO-kmwwQk+GKG60HMN1q1u6x67pD7Vj3OKU=Q@mail.gmail.com>
In-Reply-To: <CAMP44s3mgbis8BO-kmwwQk+GKG60HMN1q1u6x67pD7Vj3OKU=Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 04:14 PM, Felipe Contreras wrote:
> On Fri, Aug 2, 2013 at 3:06 AM, Aaron Lu <aaron.lu@intel.com> wrote:
>> On 08/02/2013 03:59 PM, Felipe Contreras wrote:
>>> On Fri, Aug 2, 2013 at 1:56 AM, Aaron Lu <aaron.lu@intel.com> wrote:
>>>> On 08/02/2013 02:44 PM, Felipe Contreras wrote:
>>>
>>>>> The initial _BCM commands don't work, so the level remains at 100%.
>>>>> Since the level is max_level, acpi_video_bqc_quirk() tries with the
>>>>> first level, which is 0, and 0 happens to be the index of 100.
>>>>>
>>>>> So _BQC is returning 100, which is not the index of 0 (what we tested
>>>>> for), but actually 100.
>>>>>
>>>>> I think the current code is correct, but acpi_video_bqc_quirk() should
>>>>> be testing br->levels[3], or anything other than 0/100 which can be
>>>>> easily confused.
>>>>>
>>>>> If so, the code would find that _BQC doesn't work on this machine (in
>>>>> win8 mode)... at least initially. My guess is that it only starts to
>>>>> work after acpi_video_bus_start_devices() is called.
>>>>>
>>>>> Forcing br->flags._BQC_use_index = 0 seems to work.
>>>>
>>>> Seems ASUS machines tend to have this issue:
>>>> https://bugzilla.kernel.org/show_bug.cgi?id=52951
>>>> https://bugzilla.kernel.org/show_bug.cgi?id=56711
>>>
>>> I don't see any real solution for the ACPI driver.
>>>
>>>> I have a patch to enhance the quirk some time ago:
>>>> https://github.com/aaronlu/linux/commit/0a3d2c5b59caf80ae5bb1ca1fda0f7bf448b38c9
>>>
>>> I think this is unnecessarily complicated; the comment makes it clear
>>
>> For your system, yes it is unnecessarily complicated. But since this is
>> a quirk, it better solves as many potential problems as possible, or we
>> would simply use a DMI entry to do the quirk.
> 
> The only difference between my patch and yours is that your patch
> checks that br->level[i] is not the current level, but that check is
> not necessary. If _BQC always returns the max level, all we need to do

_BQC does not always returns the max level.

> is pick another value, any other value, and br->level[3] works just
> fine.

For a _BCL only having 4 elements { 100, 40, 40, 100 }, the br->levels[3]
will be the max level. The example here may be too crazy to be true, but
since we are dealing with firmware, I tend to believe anything could
happen.

-Aaron

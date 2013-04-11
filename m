Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964942Ab3DKUjD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:39:03 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:59105 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932836Ab3DKUi5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:38:57 -0400
MIME-Version: 1.0
In-Reply-To: <5166D314.1090508@arm.com>
References: <1365501657-4213-1-git-send-email-serban.constantinescu@arm.com>
	<1365501657-4213-4-git-send-email-serban.constantinescu@arm.com>
	<CAMP5XgdNi4BV-aWDGhmFgNGceGoT2msdU_rA4U=wqs6xtYRc_A@mail.gmail.com>
	<516562C5.2050306@arm.com>
	<CAMP5XgcvwxWkQV3BJyMz+JSSFRmMj_1a+q_t9htPZ6ZvGd5foQ@mail.gmail.com>
	<5166D314.1090508@arm.com>
Date: Thu, 11 Apr 2013 13:38:56 -0700
Message-ID: <CAMP5XgeqQsxQt=s0pHki-eGfgGv3n0vkkhb4y0oVksgz5SjArw@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] staging: android: binder: fix binder interface for
 64bit compat layer
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Serban Constantinescu <Serban.Constantinescu@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 8:13 AM, Serban Constantinescu
<Serban.Constantinescu@arm.com> wrote:
...
>>>
>>>>> unsigned long read_buffer;
>>>>> };
>>>>>
>>>>> /* Use with BINDER_VERSION, driver fills in fields. */
>>>>> struct binder_version {
>>>>> /* driver protocol version -- increment with incompatible change */
>>>>> - signed long protocol_version;
>>>>> + __s32 protocol_version;
>>>>
>>>>
>>>>
>>>> How does user-space know if it should use 32 bit or 64 bit pointers.
>>>> Without this change, the BINDER_VERSION ioctl would only match when
>>>> the size of long matches.
>>>
>>>
>>>
>>> The userspace can check the values returned by uname(). That will
>>> determine
>>> if the kernel is 32 or 64bit and depending on this select what binder
>>> structures to use. Next a BINDER_VERSION ioctl will fail on 64bit kernels
>>> using protocol_version as 64bit signed long(that is old kernel versions
>>> with
>>> no 64bit support).
>>>
>>> Leaving this value as signed long would mean that older versions of the
>>> binder(without 64bit support) will pass the check. Furthermore the
>>> protocol
>>> version will probably never exceed the values that could be represented
>>> on
>>> 32bit. It will also mean that BINDER_VERSION will have a different
>>> userspace/kernel handler for 64/32 systems.
>>>
>>> Let me know what are your thoughts related to these changes,
>>> Thanks for your feedback,
>>> Serban
>>>
>>
>> I think user-space should get the binder pointer size from the binder
>> driver, not elsewhere. Since the current driver does not appear to be
>> functional on a 64 bit system, I think adding an ioctl to get the
>> size, or encoding it into the binder version (use an unsigned type if
>> you do this), would be best.
>
>
> I will think about the best way of getting the pointer size and add it to
> the patch set for binder compat. For this patch set I will only modify the
> protocol_version from long to __s32.
>

OK, but if you are using this change let a 64 bit user-space know that
the driver has been fixed, then this patch needs to go after the
patches that change the structures on 64 bit systems.

--
Arve Hjønnevåg

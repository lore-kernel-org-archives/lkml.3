Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760190Ab3D3KJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 06:09:41 -0400
Received: from service87.mimecast.com ([91.220.42.44]:54043 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759863Ab3D3KJk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 06:09:40 -0400
Message-ID: <517F985E.7040100@arm.com>
Date: Tue, 30 Apr 2013 11:09:34 +0100
From: Serban Constantinescu <Serban.Constantinescu@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "arve@android.com" <arve@android.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>
Subject: Re: [PATCH v3 0/6] Android Binder IPC Fixes
References: <1365769555-6052-1-git-send-email-serban.constantinescu@arm.com> <20130430073145.GA3623@shutemov.name> <517F8652.4070103@arm.com> <20130430100431.GA3973@shutemov.name>
In-Reply-To: <20130430100431.GA3973@shutemov.name>
X-OriginalArrivalTime: 30 Apr 2013 10:09:33.0164 (UTC) FILETIME=[CFA232C0:01CE458A]
X-MC-Unique: 113043011093316501
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/04/13 11:04, Kirill A. Shutemov wrote:
> On Tue, Apr 30, 2013 at 09:52:34AM +0100, Serban Constantinescu wrote:
>> Hi Kirill,
>>
>> On 30/04/13 08:31, Kirill A. Shutemov wrote:
>>> On Fri, Apr 12, 2013 at 01:25:49PM +0100, Serban Constantinescu wrote:
>>>> The patch set has been successfully tested with a 64bit Linux userspace and
>>>> 64bit binder unit-tests.
>>>>
>>>> This patch set has been successfully tested on 32bit platforms(ARMv7 VExpress)
>>>> and 64bit platforms(ARMv8 RTSM) running a 32bit Android userspace and an in
>>>> kernel binder compat layer.
>>>
>>> I've tried to replace ugly hack with your patches to be able to boot
>>> 32-bit userspace on x86-64. It fails. :(
>>>
>>
>> This patch set fixes the binder interface so that it works on 32/32
>> or 64/64 systems and preps the driver for the compat layer - 64bit
>> kernel/32bit userspace. As discussed with the Android developers the
>> binder compat will live in the userspace.
>
> Does the compat layer already exist or it's a plan?
We were working with a kernel compat layer. However this wasn't 
encouraged by the Android developers who would prefer a userspace binder 
compat.

The changes in this patch set fix the kernel interface so that it will 
work with the yet to be developed userspace wrapper.

Some support for 64/32 systems has already been integrated - see ashmem.

Thanks,
Serban


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935588Ab3DHNMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 09:12:44 -0400
Received: from service87.mimecast.com ([91.220.42.44]:39082 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935201Ab3DHNMn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 09:12:43 -0400
Message-ID: <5162C251.7060606@arm.com>
Date: Mon, 08 Apr 2013 14:12:49 +0100
From: Serban Constantinescu <Serban.Constantinescu@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: =?windows-1252?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
CC: Greg KH <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>
Subject: Re: [PATCH 0/8] Android Binder IPC Fixes
References: <1365078758-28674-1-git-send-email-serban.constantinescu@arm.com> <20130405220039.GA31680@kroah.com> <CAMP5Xgeh-5nLY1CLBOma2jNcS7J2tMMCkZO8Jg-_W0vCke4zmw@mail.gmail.com>
In-Reply-To: <CAMP5Xgeh-5nLY1CLBOma2jNcS7J2tMMCkZO8Jg-_W0vCke4zmw@mail.gmail.com>
X-OriginalArrivalTime: 08 Apr 2013 13:12:37.0450 (UTC) FILETIME=[BDB0BAA0:01CE345A]
X-MC-Unique: 113040814124108401
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/13 00:38, Arve Hjønnevåg wrote:
> On Fri, Apr 5, 2013 at 3:00 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> On Thu, Apr 04, 2013 at 01:32:30PM +0100, Serban Constantinescu wrote:
>>> Hi all,
>>>
>>> This set of patches will clean-up and fix some of the issues that arise
>>> with the current binder interface when moving to a 64bit kernel. All these
>>> changes will not affect the existing 32bit Android interface and are meant
>>> to stand as the base for the 64bit binder compat layer.
>>>
>>> This patch set has been successfully tested on 32bit platforms(ARMv7 VExpress)
>>> and 64bit platforms(ARMv8 RTSM) running a 32bit Android userspace and an in
>>> kernel binder compat layer.
>>
>> I need some acks from some of the Android developers before I can take
>> this.
>>
>
> I still think it is better to change user-space to use 64 bit pointer
> types when running on a 64 bit kernel. These changes do not seem to
> allow 64 bit user-space processes on a 64 bit kernel.

This patch set is independent of whether the binder compat layer lives 
in the kernel or in the userspace. However we need these changes so that 
the same kernel driver supports calls from 32bit userspace and calls 
from 64bit userspace(from the binder kernel driver perspective same as 
64bit kernel/32bit userspace with the compat layer expanding pointers 
and structures to 64bit in the userspace).

We have tested 64/64 functionality using a 64bit Linux filesystem and 
64bit binder unit tests. All tests passed for both kernel/filesystem 
configurations supported by this patch set - 32/32 and 64/64.

Thanks for your feedback,
Serban


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935797Ab3DHMZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 08:25:28 -0400
Received: from service87.mimecast.com ([91.220.42.44]:44733 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935339Ab3DHMZF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 08:25:05 -0400
Message-ID: <5162B72A.4040009@arm.com>
Date: Mon, 08 Apr 2013 13:25:14 +0100
From: Serban Constantinescu <Serban.Constantinescu@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>,
        =?windows-1252?Q?Arve_Hj=F8nn?= =?windows-1252?Q?ev=E5g?= 
	<arve@android.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>
Subject: Re: [PATCH 1/8] staging: android: binder: replace explicit size types
References: <1365078758-28674-1-git-send-email-serban.constantinescu@arm.com> <1365078758-28674-2-git-send-email-serban.constantinescu@arm.com> <CAMP5Xgd=xT7jcjz4UJY=_V8ccGLJrr6LXpkQCiR8GQCZcDPEDQ@mail.gmail.com> <20130406060010.GA11127@kroah.com>
In-Reply-To: <20130406060010.GA11127@kroah.com>
X-OriginalArrivalTime: 08 Apr 2013 12:25:02.0846 (UTC) FILETIME=[1836B9E0:01CE3454]
X-MC-Unique: 113040813250302001
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/13 07:00, Greg KH wrote:
> On Fri, Apr 05, 2013 at 04:17:47PM -0700, Arve Hjønnevåg wrote:
>> On Thu, Apr 4, 2013 at 5:32 AM, Serban Constantinescu
>> <serban.constantinescu@arm.com> wrote:
>>>
>>> Since the binder driver uses both uint32_t and unsigned int any further
>>> kernel changes will be difficult to read. This patch fixes the inconsistent
>>> types usage.
>>>
>>
>> Would it make more sense to only change the types that need to be
>> larger on a 64 bit system?
>
> I agree.  You are also changing the type from explicit to "unexplicit",
> the exact opposite from what I would be expecting to see here.  Why?

I have changed the types used so that they seem consistent throughout 
the driver(uint32_t is used in some of the internal structures and some 
of the function prototypes). Changing these types to kernel explicit 
types would have meant that we would have the same inconsistency for u32 
types.

We can live without this patch and I can take a look at modifying the 
function prototypes, internal structures and kernel/userspace 
interaction to use explicit kernel types it that is preferred.

Thanks for your feedback,
Serban


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066AbaFSWkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 18:40:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35194 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757338AbaFSWkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 18:40:11 -0400
Message-ID: <53A366B3.8020808@zytor.com>
Date: Thu, 19 Jun 2014 15:39:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, Daniel Vetter <daniel@ffwll.ch>
CC: Rob Clark <robdclark@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-arch@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Colin Cross <ccross@google.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [REPOST PATCH 1/8] fence: dma-buf cross-device synchronization
 (v17)
References: <20140618102957.15728.43525.stgit@patser> <20140618103653.15728.4942.stgit@patser> <20140619011327.GC10921@kroah.com> <CAF6AEGv4Ms+zsrEtpA10bGq04LnRjzVb925co49eVxh4ugkd=A@mail.gmail.com> <20140619170059.GA1224@kroah.com> <CAKMK7uFa57YjeJCFQhWFr_5cRTTpWxBdJ1qtb5Ojnu-KZpe-Lw@mail.gmail.com> <20140619200159.GA27883@kroah.com>
In-Reply-To: <20140619200159.GA27883@kroah.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2014 01:01 PM, Greg KH wrote:
> On Thu, Jun 19, 2014 at 09:15:36PM +0200, Daniel Vetter wrote:
>> On Thu, Jun 19, 2014 at 7:00 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>>>>> +     BUG_ON(f1->context != f2->context);
>>>>>
>>>>> Nice, you just crashed the kernel, making it impossible to debug or
>>>>> recover :(
>>>>
>>>> agreed, that should probably be 'if (WARN_ON(...)) return NULL;'
>>>>
>>>> (but at least I wouldn't expect to hit that under console_lock so you
>>>> should at least see the last N lines of the backtrace on the screen
>>>> ;-))
>>>
>>> Lots of devices don't have console screens :)
>>
>> Aside: This is a pet peeve of mine and recently I've switched to
>> rejecting all patch that have a BUG_ON, period.
> 
> Please do, I have been for a few years now as well for the same reasons
> you cite.
> 

I'm actually concerned about this trend.  Downgrading things to WARN_ON
can allow a security bug in the kernel to continue to exist, for
example, or make the error message disappear.

I am wondering if the right thing here isn't to have a user (command
line?) settable policy as to how to proceed on an assert violation,
instead of hardcoding it at compile time.

	-hpa



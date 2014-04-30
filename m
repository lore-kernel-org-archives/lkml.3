Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759616AbaD3Vs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 17:48:27 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46539 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759440AbaD3VsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 17:48:25 -0400
Message-ID: <53616F92.4020709@oracle.com>
Date: Wed, 30 Apr 2014 17:48:02 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Glauber Costa <glommer@parallels.com>,
        Christoph Lameter <cl@linux.com>
Subject: Re: fs: dcookie: freeing active timer
References: <53594244.6070305@oracle.com> <20140424172708.GY18016@ZenIV.linux.org.uk> <53594B16.4000901@oracle.com> <20140424215558.GZ18016@ZenIV.linux.org.uk> <20140424234941.GA18016@ZenIV.linux.org.uk> <5359D70B.2070604@oracle.com>
In-Reply-To: <5359D70B.2070604@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 11:31 PM, Sasha Levin wrote:
> On 04/24/2014 07:49 PM, Al Viro wrote:
>> On Thu, Apr 24, 2014 at 10:55:58PM +0100, Al Viro wrote:
>>> On Thu, Apr 24, 2014 at 01:34:14PM -0400, Sasha Levin wrote:
>>>
>>>>> Why does that code bother with destroying/creating that sucker dynamically?
>>>>> Is there any point at all?
>>>>
>>>> I'm not sure about the dynamic allocation part, but I fear that if we just
>>>> switch to using static allocations it'll hide the underlying issue that
>>>> triggered this bug instead of fixing it.
>>>
>>> FWIW, slub.c variant of kmem_cache_destroy() is buggered - struct kobject
>>> embedded into struct kmem_cache, its ktype is slab_ktype, which has
>>> NULL ->release()...
>>
>> BTW, if your config has CONFIG_DEBUG_KOBJECT_RELEASE, that's exactly where
>> that warning comes from.  Got broken by commit b7454a,
>> Author: Glauber Costa <glommer@parallels.com>
>> Date:   Fri Oct 19 18:20:25 2012 +0400
>>
>>     mm/sl[au]b: Move slabinfo processing to slab_common.c
>>
>> We *do* need ->release().  Greg and guilty parties Cc'd...
> 
> We actually had that conversation a long time ago, and Christoph has
> sent out a patch to fix that (http://www.spinics.net/lists/netdev/msg259431.html).
> 
> I was assuming that it was merged upstream and went straight to blaming
> fs/ (and Greg's drivers/usb/ actually) without checking that first. Sorry!
> 
> Could someone pretty please merge that patch? Specially since Greg acked it?

Ping?


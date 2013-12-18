Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab3LRRvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 12:51:51 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:46401 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433Ab3LRRvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 12:51:48 -0500
Message-ID: <52B1E0A2.2030202@landley.net>
Date: Wed, 18 Dec 2013 11:51:30 -0600
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dave Young <dyoung@redhat.com>, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        sebastian.capella@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use initmpfs even if there's root= cmdline
References: <20131212092542.GA14218@dhcp-16-126.nay.redhat.com> <20131213023814.GA5519@dhcp-16-126.nay.redhat.com>
In-Reply-To: <20131213023814.GA5519@dhcp-16-126.nay.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/12/13 20:38, Dave Young wrote:
> On 12/12/13 at 05:25pm, Dave Young wrote:
>>
>> Current code use ramfs instead of tmpfs for stub when root= defined.
>>
>> But for real use case with initramfs, usually there's like cmdline like
>> root=UUID=$UUID the root dev is the real device. For that case we have
>> no way to use initmpfs, thus this patch removes the limitation so tmpfs
>> can benefit more people.

The reason I did that was if you specify a root= then you don't want to 
_stay_ on rootfs. You specify root= so either the kernel does 
switch_root for you, or so rootfs does a swich_root at the end.

The point of initmpfs is that when rootfs _is_ the "real" root device, 
it can benefit from being tmpfs. When you're just goign to switch to a 
different root device, tmpfs doesn't make much difference.

> Discussed with Vivek Goyal about the kdump use case, I missed one thing that
> tmpfs has default size limit though we can tune it.
>
> So I will think more about it, will address this later, please ignore this
> patch.

I have a vague todo item of feeding rootflags= through to initmpfs, but 
that's really intended to specify flags for root=. There isn't really an 
existing command line option to specify initramfs flags because ramfs 
doesn't care.

It was one of those "only parse rootflags= for initmpfs when there's no 
root=" vs "create a new rdrootflags= ala rdinit= even though that's a 
subtly wrong name these days..." and it went on the todo list because 
neither approach was obviously superior.

Happy to take suggestions and whip up a patch if this is inconveniencing 
somebody. :)

> Thanks
> Dave

Rob

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbaDNM4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 08:56:21 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:49243 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755097AbaDNM4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 08:56:19 -0400
Message-ID: <534BDAEF.6090601@vmware.com>
Date: Mon, 14 Apr 2014 14:56:15 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: DRM security flaws and security levels.
References: <5347E32B.1080002@vmware.com> <20140414134113.6c1a488d@alan.etchedpixels.co.uk>
In-Reply-To: <20140414134113.6c1a488d@alan.etchedpixels.co.uk>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2014 02:41 PM, One Thousand Gnomes wrote:
>> throw out all GPU memory on master drop and block ioctls requiring
>> authentication until master becomes active again.
> If you have a per driver method then the driver can implement whatever is
> optimal (possibly including throwing it all out). 
>
>> -1: The driver allows an authenticated client to craft command streams
>> that could access any part of system memory. These drivers should be
>> kept in staging until they are fixed.
> I am not sure they belong in staging even.
>
>> 0: Drivers that are vulnerable to any of the above scenarios.
>> 1: Drivers that are immune against all above scenarios but allows any
>> authenticated client with *active* master to access all GPU memory. Any
>> enabled render nodes will be insecure, while primary nodes are secure.
>> 2: Drivers that are immune against all above scenarios and can protect
>> clients from accessing eachother's gpu memory:
>> Render nodes will be secure.
>>
>> Thoughts?
> Another magic number to read, another case to get wrong where the OS
> isn't providing security by default.
>
> If the driver can be fixed to handle it by flushing out all GPU memory
> then the driver should be fixed to do so. Adding magic udev nodes is just
> adding complexity that ought to be made to go away before it even becomes
> an API.
>
> So I think there are three cases
>
> - insecure junk driver. Shouldn't even be in staging
> - hardware isn't as smart enough, or perhaps has a performance problem so
>   sometimes flushes all buffers away on a switch
> - drivers that behave well
>
> Do you then even need a sysfs node and udev hacks (remembering not
> everyone even deploys udev on their Linux based products)
>
> For the other cases
>
> - how prevalent are the problem older user space drivers nowdays ?
>
> - the fix for "won't fix" drivers is to move them to staging, and then
>   if they are not fixed or do not acquire a new maintainer who will,
>   delete them.
>
> - if we have 'can't fix drivers' then its a bit different and we need to
>   understand better *why*.
>
> Don't screw the kernel up because there are people who can't be bothered
> to fix bugs. Moving them out of the tree is a great incentive to find
> someone to fix it.
>

On second thought I'm dropping this whole issue.
I've brought this and other security issues up before but nobody really
seems to care.

/Thomas

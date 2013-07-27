Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab3G0RpJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 13:45:09 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:47576 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab3G0RpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 13:45:06 -0400
Message-ID: <51F40570.9050209@gmail.com>
Date: Sat, 27 Jul 2013 19:37:52 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Vladimir Davydov <vdavydov@parallels.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, criu@openvz.org, devel@openvz.org,
        xemul@parallels.com
Subject: Re: [PATCH RFC] pram: persistent over-kexec memory file system
References: <1374841763-11958-1-git-send-email-vdavydov@parallels.com> <51F3EA2A.3090905@gmail.com> <51F404D0.6070004@parallels.com>
In-Reply-To: <51F404D0.6070004@parallels.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 27/07/2013 19:35, Vladimir Davydov ha scritto:
> On 07/27/2013 07:41 PM, Marco Stornelli wrote:
>> Il 26/07/2013 14:29, Vladimir Davydov ha scritto:
>>> Hi,
>>>
>>> We want to propose a way to upgrade a kernel on a machine without
>>> restarting all the user-space services. This is to be done with CRIU
>>> project, but we need help from the kernel to preserve some data in
>>> memory while doing kexec.
>>>
>>> The key point of our implementation is leaving process memory in-place
>>> during reboot. This should eliminate most io operations the services
>>> would produce during initialization. To achieve this, we have
>>> implemented a pseudo file system that preserves its content during
>>> kexec. We propose saving CRIU dump files to this file system, kexec'ing
>>> and then restoring the processes in the newly booted kernel.
>>>
>>
>> http://pramfs.sourceforge.net/
>
> AFAIU it's a bit different thing: PRAMFS as well as pstore, which has
> already been merged, requires hardware support for over-reboot
> persistency, so called non-volatile RAM, i.e. RAM which is not directly
> accessible and so is not used by the kernel. On the contrary, what we'd
> like to have is preserving usual RAM on kexec. It is possible, because
> RAM is not reset during kexec. This would allow leaving applications
> working set as well as filesystem caches in place, speeding the reboot
> process as a whole and reducing the downtime significantly.
>
> Thanks.

Actually not. You can use normal system RAM reserved at boot with mem 
parameter without any kernel change. Until an hard reset happens, that 
area will be "persistent".

Regards,

Marco

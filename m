Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab3G0RfU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 13:35:20 -0400
Received: from relay.parallels.com ([195.214.232.42]:42468 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab3G0RfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 13:35:18 -0400
Message-ID: <51F404D0.6070004@parallels.com>
Date: Sat, 27 Jul 2013 21:35:12 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Marco Stornelli <marco.stornelli@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-mm@kvack.org>, <criu@openvz.org>, <devel@openvz.org>,
        <xemul@parallels.com>
Subject: Re: [PATCH RFC] pram: persistent over-kexec memory file system
References: <1374841763-11958-1-git-send-email-vdavydov@parallels.com> <51F3EA2A.3090905@gmail.com>
In-Reply-To: <51F3EA2A.3090905@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.5.110.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2013 07:41 PM, Marco Stornelli wrote:
> Il 26/07/2013 14:29, Vladimir Davydov ha scritto:
>> Hi,
>>
>> We want to propose a way to upgrade a kernel on a machine without
>> restarting all the user-space services. This is to be done with CRIU
>> project, but we need help from the kernel to preserve some data in
>> memory while doing kexec.
>>
>> The key point of our implementation is leaving process memory in-place
>> during reboot. This should eliminate most io operations the services
>> would produce during initialization. To achieve this, we have
>> implemented a pseudo file system that preserves its content during
>> kexec. We propose saving CRIU dump files to this file system, kexec'ing
>> and then restoring the processes in the newly booted kernel.
>>
>
> http://pramfs.sourceforge.net/

AFAIU it's a bit different thing: PRAMFS as well as pstore, which has 
already been merged, requires hardware support for over-reboot 
persistency, so called non-volatile RAM, i.e. RAM which is not directly 
accessible and so is not used by the kernel. On the contrary, what we'd 
like to have is preserving usual RAM on kexec. It is possible, because 
RAM is not reset during kexec. This would allow leaving applications 
working set as well as filesystem caches in place, speeding the reboot 
process as a whole and reducing the downtime significantly.

Thanks.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab3J1RW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 13:22:58 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:37469 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704Ab3J1RW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 13:22:57 -0400
Message-ID: <526E9D67.9090504@mentor.com>
Date: Mon, 28 Oct 2013 19:22:47 +0200
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: return correct error code on unimplemented mmap()
References: <1382977710-1966-1-git-send-email-vladimir_zapolskiy@mentor.com> <20131028163549.GC4797@kroah.com>
In-Reply-To: <20131028163549.GC4797@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [137.202.0.76]
X-OriginalArrivalTime: 28 Oct 2013 17:22:56.0468 (UTC) FILETIME=[57944140:01CED402]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/13 18:35, Greg Kroah-Hartman wrote:
> On Mon, Oct 28, 2013 at 06:28:30PM +0200, Vladimir Zapolskiy wrote:
>> Both POSIX.1-2008 and Linux Programmer's Manual have a dedicated return
>> error code for a case, when a file doesn't support mmap(), it's ENODEV.
>>
>> This change replaces overloaded EINVAL with ENODEV in a situation
>> described above for sysfs binary files.
>>
>> Signed-off-by: Vladimir Zapolskiy<vladimir_zapolskiy@mentor.com>
>> Cc: Greg Kroah-Hartman<gregkh@linuxfoundation.org>
>
> Is this a problem in linux-next or 3.12-rc7 and older kernels?  What
> userspace tool is breaking here?

The patch itself is against 3.12-rc7, but the same problem can be found
in older kernels as well.

I assume the bugfix is quite safe, because both EINVAL and ENODEV should
be handled by user space tools, however for developers it might be
beneficial to distinguish cases of completely not supported mmap() and
supported but misused mmap() applied to a binary sysfs file. At the
moment from the user space perspective there is no indication of
unsupported mmap() over a file in sysfs.

With best wishes,
Vladimir

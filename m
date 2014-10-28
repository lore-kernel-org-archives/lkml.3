Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbaJ1RYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:24:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53589 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbaJ1RYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:24:23 -0400
Message-ID: <544FD138.3030305@zytor.com>
Date: Tue, 28 Oct 2014 10:24:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Minfei Huang <mnfhuang@gmail.com>
CC: mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Avoid overlap the fixmap area on i386
References: <6B680A9E-6CE9-4C96-934B-CB01DCB58278@gmail.com> <alpine.DEB.2.11.1410281159590.5308@nanos>
In-Reply-To: <alpine.DEB.2.11.1410281159590.5308@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2014 04:06 AM, Thomas Gleixner wrote:
>>
>> The available address we can use is lower than FIXADDR_BOOT_START. So
>> We will set the kmap boundary below the FIXADDR_BOOT_START, if configure
>> the high memory.
>>
>> If we configure the high memory, the vmalloc reserve area should end
>> up to PKMAP_BASE, otherwise should end up to FIXADDR_BOOT_START.
> 
> Which is not really a problem, because the FIXADDR_BOOT area is only
> used during boot for early_ioremap() and it's unused when ioremap() is
> functional. vmalloc becomes available after early boot so the
> FIXADDR_BOOT area is available for reuse.
> 

Given the very limited address space available on i386, it would be
extremely undesirable to not reuse address space when possible.

	-hpa


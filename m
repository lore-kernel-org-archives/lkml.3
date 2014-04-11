Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945AbaDKNlI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 09:41:08 -0400
Received: from mail.cybernetics.com ([173.71.130.66]:52209 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256AbaDKNlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 09:41:06 -0400
Message-ID: <5347F188.10408@cybernetics.com>
Date: Fri, 11 Apr 2014 09:43:36 -0400
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: David Herrmann <dh.herrmann@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH 2/6] shm: add sealing API
References: <53470E26.2030306@cybernetics.com> <CANq1E4RWf_VbzF+dPYhzHKJvnrh86me5KajmaaB1u9f9FLzftA@mail.gmail.com> <5347451C.4060106@amacapital.net>
In-Reply-To: <5347451C.4060106@amacapital.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski wrote:
> On 04/10/2014 05:22 PM, David Herrmann wrote:
>   
>> Hi
>>
>> On Thu, Apr 10, 2014 at 11:33 PM, Tony Battersby <tonyb@cybernetics.com> wrote:
>>     
>>> For O_DIRECT the kernel pins the submitted pages in memory for DMA by
>>> incrementing the page reference counts when the I/O is submitted,
>>> allowing the pages to be modified by DMA even if they are no longer
>>> mapped in the address space of the process.  This is different from a
>>> regular read(), which uses the CPU to copy the data and will fail if the
>>> pages are not mapped.
>>>       
>> Can you please provide an example code-path? For instance,
>> file_read_actor() does not pin any pages but only keeps the user-space
>> address and resolves it once it has data to write.
>>     
>
> This may be an issue for anything in the kernel that calls
> get_user_pages and holds onto the result at any time that mmap_sem isn't
> held.
>
>   

Exactly.  For O_DIRECT, that would be the call to get_user_pages_fast()
from dio_refill_pages() in fs/direct-io.c, which is ultimately called
from blkdev_direct_IO().

>From the comment for get_user_pages_fast(): "Attempt to pin user pages
in memory..."

Tony

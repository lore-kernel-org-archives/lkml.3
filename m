Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbaDKB2B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 21:28:01 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:55802 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbaDKB17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 21:27:59 -0400
Message-ID: <5347451C.4060106@amacapital.net>
Date: Thu, 10 Apr 2014 18:27:56 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>,
        Tony Battersby <tonyb@cybernetics.com>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH 2/6] shm: add sealing API
References: <53470E26.2030306@cybernetics.com> <CANq1E4RWf_VbzF+dPYhzHKJvnrh86me5KajmaaB1u9f9FLzftA@mail.gmail.com>
In-Reply-To: <CANq1E4RWf_VbzF+dPYhzHKJvnrh86me5KajmaaB1u9f9FLzftA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2014 05:22 PM, David Herrmann wrote:
> Hi
> 
> On Thu, Apr 10, 2014 at 11:33 PM, Tony Battersby <tonyb@cybernetics.com> wrote:
>> For O_DIRECT the kernel pins the submitted pages in memory for DMA by
>> incrementing the page reference counts when the I/O is submitted,
>> allowing the pages to be modified by DMA even if they are no longer
>> mapped in the address space of the process.  This is different from a
>> regular read(), which uses the CPU to copy the data and will fail if the
>> pages are not mapped.
> 
> Can you please provide an example code-path? For instance,
> file_read_actor() does not pin any pages but only keeps the user-space
> address and resolves it once it has data to write.

This may be an issue for anything in the kernel that calls
get_user_pages and holds onto the result at any time that mmap_sem isn't
held.

I don't know exactly what does that, but RDMA comes to mind.  So does
(ugh!) vmsplice, although I suspect that vmsplice doesn't write.

--Andy

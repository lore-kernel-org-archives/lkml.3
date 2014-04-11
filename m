Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbaDKVgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 17:36:44 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:48796 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaDKVgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 17:36:41 -0400
Message-ID: <53486067.6090506@mit.edu>
Date: Fri, 11 Apr 2014 14:36:39 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>,
        Tony Battersby <tonyb@cybernetics.com>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 2/6] shm: add sealing API
References: <53470E26.2030306@cybernetics.com> <CANq1E4RWf_VbzF+dPYhzHKJvnrh86me5KajmaaB1u9f9FLzftA@mail.gmail.com> <5347451C.4060106@amacapital.net> <5347F188.10408@cybernetics.com> <CANq1E4T=38VLezGH2XUZ9kc=Vtp6Ca++-ATwmEfaXZS6UrTPig@mail.gmail.com>
In-Reply-To: <CANq1E4T=38VLezGH2XUZ9kc=Vtp6Ca++-ATwmEfaXZS6UrTPig@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 02:31 PM, David Herrmann wrote:
> Hi
> 
> On Fri, Apr 11, 2014 at 3:43 PM, Tony Battersby <tonyb@cybernetics.com> wrote:
>> Exactly.  For O_DIRECT, that would be the call to get_user_pages_fast()
>> from dio_refill_pages() in fs/direct-io.c, which is ultimately called
>> from blkdev_direct_IO().
> 
> If you drop mmap_sem after pinning a page without taking a write-ref,
> you break i_mmap_writable / VM_DENYWRITE. In memfd I rely on
> i_mmap_writable to work, same thing is done by exec() (and the old,
> now disabled, MAP_DENYWRITE).
> 
> I don't know whether I should care. I mean, everyone pinning pages and
> writing to it without holding the mmap_sem has to take a write-ref for
> each page or it breaks i_mmap_writable. So this seems to be a bug in
> direct-IO, not in anyone relying on it, right?

A quick grep of the kernel tree finds exactly zero code paths
incrementing i_mmap_writable outside of mmap and fork.

Or do you mean a different kind of write ref?  What am I missing here?

--Andy

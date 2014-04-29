Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304AbaD2IAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:00:43 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:39209 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbaD2IAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:00:41 -0400
Message-ID: <535F5BF1.6020405@linux.vnet.ibm.com>
Date: Tue, 29 Apr 2014 13:29:45 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>, Hugh Dickins <hughd@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [BUG] kernel BUG at mm/vmacache.c:85!
References: <535EA976.1080402@linux.vnet.ibm.com> <CA+55aFxgW0fS=6xJsKP-WiOUw=aiCEvydj+pc+zDF8Pvn4v+Jw@mail.gmail.com> <CA+55aFzXAnTzfNL-bfUFnu15=4Z9HNigoo-XyjmwRvAWX_xz0A@mail.gmail.com>
In-Reply-To: <CA+55aFzXAnTzfNL-bfUFnu15=4Z9HNigoo-XyjmwRvAWX_xz0A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042908-2674-0000-0000-00000E05FB2C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 03:25 AM, Linus Torvalds wrote:
> On Mon, Apr 28, 2014 at 2:20 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> That said, the bug does seem to be that some path doesn't invalidate
>> the vmacache sufficiently, or something inserts a vmacache entry into
>> the current process when looking up a remote process or whatever.
>> Davidlohr, ideas?
> 
> Maybe we missed some use_mm() call. That will change the current mm
> without flushing the vma cache. The code considers kernel threads to
> be bad targets for vma caching for this reason (and perhaps others),
> but maybe we missed something.
> 
> I wonder if we should just invalidate the vma cache in use_mm(), and
> remote the "kernel tasks are special" check.
> 
> Srivatsa, are you doing something peculiar on that system that would
> trigger this? I see some kdump failures in the log, anything else?
> 

No, it was just plain booting. The machine is simply configured with
kdump, that's all. I'm surprised that so many processes got segfaults
during boot. Looks like an mm bug in the kernel.

Regards,
Srivatsa S. Bhat


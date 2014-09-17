Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbaIQRAf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 13:00:35 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:50741 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740AbaIQRAd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 13:00:33 -0400
MIME-Version: 1.0
In-Reply-To: <20140917114214.GB30733@minantech.com>
References: <1410811885-17267-1-git-send-email-andreslc@google.com>
	<20140917102635.GA30733@minantech.com>
	<20140917112713.GB1273@potion.brq.redhat.com>
	<20140917114214.GB30733@minantech.com>
Date: Wed, 17 Sep 2014 10:00:32 -0700
Message-ID: <CAJu=L58O147YQJyODD8MFtdvQ6+TSG6gi6qGySgH3EigP32MrQ@mail.gmail.com>
Subject: Re: [PATCH] kvm: Faults which trigger IO release the mmap_sem
From: Andres Lagar-Cavilla <andreslc@google.com>
To: Gleb Natapov <gleb@kernel.org>
Cc: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>, Jianyu Zhan <nasa4836@gmail.com>,
        Paul Cassella <cassella@cray.com>, Hugh Dickins <hughd@google.com>,
        Peter Feiner <pfeiner@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 4:42 AM, Gleb Natapov <gleb@kernel.org> wrote:
> On Wed, Sep 17, 2014 at 01:27:14PM +0200, Radim Krčmář wrote:
>> 2014-09-17 13:26+0300, Gleb Natapov:
>> > For async_pf_execute() you do not need to even retry. Next guest's page fault
>> > will retry it for you.
>>
>> Wouldn't that be a waste of vmentries?
> This is how it will work with or without this second gup. Page is not
> mapped into a shadow page table on this path, it happens on a next fault.

The point is that the gup in the async pf completion from the work
queue will not relinquish the mmap semaphore. And it most definitely
should, given that we are likely looking at swap/filemap.

Andres

>
> --
>                         Gleb.



-- 
Andres Lagar-Cavilla | Google Kernel Team | andreslc@google.com

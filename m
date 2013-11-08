Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731Ab3KHTZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 14:25:18 -0500
Received: from mail-qe0-f41.google.com ([209.85.128.41]:51753 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031Ab3KHTZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 14:25:16 -0500
MIME-Version: 1.0
In-Reply-To: <32E1700B9017364D9B60AED9960492BC211C6448@FMSMSX107.amr.corp.intel.com>
References: <20131104155526.10e5aed0cd9512c47a82529f@canb.auug.org.au> <32E1700B9017364D9B60AED9960492BC211C6448@FMSMSX107.amr.corp.intel.com>
From: Roland Dreier <roland@kernel.org>
Date: Fri, 8 Nov 2013 11:24:53 -0800
X-Google-Sender-Auth: 0aUwZSsIFyJHXXMn5_cwjx12yp0
Message-ID: <CAG4TOxNvq0jxCJgLWZqdU39Bg968AUmBnd7nooJHy6ojw15=+Q@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the infiniband tree
To: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry about that, folded in the fix I missed and will push out the tree shortly.

On Mon, Nov 4, 2013 at 5:42 AM, Marciniszyn, Mike
<mike.marciniszyn@intel.com> wrote:
> This issue was caught by Tetsuo Handa and Acked on 10/30: http://marc.info/?t=138313364500008&r=1&w=2.
>
> Roland, I noticed that the Tetsuo's original message didn't cc the linux-rdma list?
>
> Mike
>
>> -----Original Message-----
>> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au]
>> Sent: Sunday, November 03, 2013 11:55 PM
>> To: Roland Dreier; linux-rdma@vger.kernel.org
>> Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Jan Kara;
>> Marciniszyn, Mike
>> Subject: linux-next: build warning after merge of the infiniband tree
>>
>> Hi all,
>>
>> After merging the infiniband tree, today's linux-next build (x86_64
>> allmodconfig) produced this warning:
>>
>> drivers/infiniband/hw/ipath/ipath_user_sdma.c: In function
>> 'ipath_user_sdma_pin_pages':
>> drivers/infiniband/hw/ipath/ipath_user_sdma.c:283:6: warning: 'j' is used
>> uninitialized in this function [-Wuninitialized]
>>   ret = get_user_pages_fast(addr, j, 0, pages);
>>       ^
>>
>> Introduced by commit 18fec3c6bdcb ("IB/ipath: Convert
>> ipath_user_sdma_pin_pages() to use get_user_pages_fast()").  How did that
>> pass review or testing?
>>
>> --
>> Cheers,
>> Stephen Rothwell                    sfr@canb.auug.org.au

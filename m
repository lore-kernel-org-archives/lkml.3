Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751292AbaIJMYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 08:24:51 -0400
Received: from relay.parallels.com ([195.214.232.42]:40000 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaIJMYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 08:24:50 -0400
Message-ID: <5410430E.5030804@parallels.com>
Date: Wed, 10 Sep 2014 16:24:46 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: <viro@zeniv.linux.org.uk>, <fuse-devel@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, <werner.baumann@onlinehome.de>
Subject: Re: [PATCH 0/2] fuse: fix regression in fuse_get_user_pages()
References: <20140903100826.23218.95122.stgit@localhost.localdomain> <20140910095115.GA7441@tucsk.piliscsaba.szeredi.hu>
In-Reply-To: <20140910095115.GA7441@tucsk.piliscsaba.szeredi.hu>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.22.200]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 01:51 PM, Miklos Szeredi wrote:
> On Wed, Sep 03, 2014 at 02:10:23PM +0400, Maxim Patlasov wrote:
>> Hi,
>>
>> The patchset fixes a regression introduced by the following commits:
>>
>> c7f3888ad7f0 ("switch iov_iter_get_pages() to passing maximal number of pages")
>> c9c37e2e6378 ("fuse: switch to iov_iter_get_pages()")
>>
> Hmm, instead of reverting to passing maxbytes *instead* of maxpages, I think the
> right fix is to *add* the maxbytes argument.
>
> Just maxbytes alone doesn't have enough information in it.  E.g. 4096 contiguous
> bytes could occupy 1 or 2 pages, depending on the starting offset.
Yes, you are right. I missed that c7f3888ad7f0 fixed a subtle bug in 
get_pages_iovec().

>
> So how about the following (untested) patch?
Your patch works fine in my tests.

Thanks,
Maxim

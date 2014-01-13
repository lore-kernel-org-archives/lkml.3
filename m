Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaAMP5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:57:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49583 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbaAMP5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:57:10 -0500
Date: Mon, 13 Jan 2014 07:57:46 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Li Zefan <lizefan@huawei.com>
Cc: stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [STABLE] find missing bug fixes in a stable kernel
Message-ID: <20140113155746.GA2432@kroah.com>
References: <52D3958B.1060902@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D3958B.1060902@huawei.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 03:28:11PM +0800, Li Zefan wrote:
> We have several long-term and extended stable kernels, and it's possible
> that a bug fix is in some stable versions but is missing in some other
> versions, so I've written a script to find out those fixes.
> 
> Take 3.4.xx and 3.2.xx for example. If a bug fix was merged into upstream
> kernel after 3.4, and then it was backported to 3.2.xx, then it probably
> needs to be backported to 3.4.xx.

I agree.

> The result is, there're ~430 bug fixes in 3.2.xx that probably need to be
> backported to 3.4.xx. Given there're about 4500 commits in 3.2.xx, that
> is ~10%, which is quite a big number for stable kernels.

That's a really big number, how am I missing so many patches for the 3.4
kernel?  Is it because people are doing backports to 3.2 for patches
that didn't apply to 3.4?  Or are these patches being applied that do
not have -stable markings on them?  Or something else?

> We (our team in Huawei) are going to go through the whole list to filter
> out fixes that're applicable for 3.4.xx.
> 
> I've attached the lists for 3.4 and 3.10.

The list format doesn't seem to make much sense, care to explain it a
bit better?

> 
> If a commit ID appears more than once in changelogs, it's possible that's
> because the commit was reverted later, so I tagged this kind of commits
> in the lists.

> [upstream commit]    [stable commit]    [occurrences]
> 8c4f3c3fa968 874d3954a35c 2 1

I'll use this as an example, this patch was not marked for -stable
backporting, yet it showed up in the 3.2-stable tree.  Why?

And what does the [occurrences] column mean?

confused,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbaDNVqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:46:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52119 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaDNVqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:46:17 -0400
Date: Mon, 14 Apr 2014 14:46:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-kernel@vger.kernel.org, Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [patch 2/2] lib/string.c: strlcpy() might read too far
Message-Id: <20140414144615.8fd678c78389c19df4343049@linux-foundation.org>
In-Reply-To: <20140402084731.GB6018@mwanda>
References: <20140401.161838.1562296825577866979.davem@davemloft.net>
	<20140402084731.GB6018@mwanda>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2014 11:47:31 +0300 Dan Carpenter <dan.carpenter@oracle.com> wrote:

> Imagine you have a user controlled variable at the end of a struct which
> is allocated at the end of a page.  The strlen() could read beyond the
> mapped memory and cause an oops.

Well, it's hard to conceive of a situation where anything like this
could happen.  Code which copies a string from userspace should
immediately ensure that the kernel copy is null-terminated.  But...  I
guess it's defense in depth.

> Probably there are two reasons why we have never hit this condition in
> real life.  First you would have to be really unlucky for all the
> variables to line up so the oops can happen.  Second we don't do a lot
> of fuzzing with invalid strings.
> 
> The strnlen() call is obviously a little bit slower than strlen() but I
> have tested it and I think it's probably ok.

If we cared about speed we wouldn't take two passes across the input
string ;)



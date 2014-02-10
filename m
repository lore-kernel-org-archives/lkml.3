Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbaBJUEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:04:46 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36786 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbaBJUEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 15:04:39 -0500
Date: Mon, 10 Feb 2014 20:04:36 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [process_vm_access] BUG: unable to handle kernel paging request
 at fffffff27b92dd20
Message-ID: <20140210200436.GE18016@ZenIV.linux.org.uk>
References: <20140210112231.GA11951@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210112231.GA11951@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 07:22:31PM +0800, Fengguang Wu wrote:
> Hi Al,
> 
> We noticed the below oops since commit 68a25f08c9bec07ad95e55a01b127168e43aed84
> ("process_vm_access: take get_user_pages/put_pages one level up")
> while running ltp tests inside kvm.

Actually, that's a combination of 3 bugs, only one of them being in this
commit.  See current #iov_iter; AFAICS, all process_vm stuff in LTP passes
with it.

BTW, what's the story with ioctl3?  What I'm getting from it is
"Must supply a file collection or a command", with no further
explanations.  Something it wants installed that just isn't there?

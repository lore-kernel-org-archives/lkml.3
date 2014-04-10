Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030544AbaDJTtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 15:49:49 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47793 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030242AbaDJTtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 15:49:47 -0400
X-Sasl-enc: ruUV+3cS+tHzyHi960O49uBGJtSFqgpiUa+1WjbE6pNb 1397159385
Date: Thu, 10 Apr 2014 19:45:38 +0000
From: Colin Walters <walters@verbum.org>
Subject: Re: [PATCH 0/6] File Sealing & memfd_create()
To: Andy Lutomirski <luto@amacapital.net>
Cc: tytso@mit.edu, David Herrmann <dh.herrmann@gmail.com>,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <matthew@wil.cx>,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Kay Sievers <kay@vrfy.org>, Daniel Mack <zonque@gmail.com>,
        Lennart Poettering <lennart@poettering.net>, Kristian@thunk.org,
        john.stultz@linaro.org, Greg Kroah-Hartman <greg@kroah.com>,
        Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ryan Lortie <desrt@desrt.ca>, mtk.manpages@gmail.com
Message-Id: <1397159378.4434.1@mail.messagingengine.com>
In-Reply-To: <5346EDE8.2060004@amacapital.net>
References: <1395256011-2423-1-git-send-email-dh.herrmann@gmail.com>
	<20140320153250.GC20618@thunk.org>
	<1397141388.16343.10@mail.messagingengine.com>
	<5346EDE8.2060004@amacapital.net>
X-Mailer: geary/0.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
X-OriginalDate: Thu, 10 Apr 2014 19:45:38 -0004
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 3:15 PM, Andy Lutomirski <luto@amacapital.net> 
wrote:
> 
> 
> COW links can do this already, I think.  Of course, you'll have to 
> use a
> filesystem that supports them.

COW is nice if the filesystem supports them, but my userspace code 
needs to be filesystem agnostic.  Because of that, the design for 
userspace simply doesn't allow arbitrary writes.

Instead, I have to painfully audit every rpm %post/dpkg postinst type 
script to ensure they break hardlinks, and furthermore only allow 
executing scripts that are known to do so.

But I think even in a btrfs world it'd still be useful to mark files as 
content-immutable.





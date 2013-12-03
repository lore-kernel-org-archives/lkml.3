Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab3LCVg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 16:36:56 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:53902 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098Ab3LCVgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 16:36:52 -0500
Date: Tue, 3 Dec 2013 16:36:49 -0500
From: Tejun Heo <tj@kernel.org>
To: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org
Subject: Re: sysfs: use a separate locking class for open files depending on
 mmap
Message-ID: <20131203213649.GO8277@htj.dyndns.org>
References: <20131128051223.45739660885@gitolite.kernel.org>
 <20131203184324.GA11320@redhat.com>
 <20131203211028.GN8277@htj.dyndns.org>
 <20131203211515.GA17951@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131203211515.GA17951@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Tue, Dec 03, 2013 at 04:15:15PM -0500, Dave Jones wrote:
>  > > Somehow I just triggered this trace again, even with this commit applied.
>  > > The trace is pretty much identical to the old one.
>  > 
>  > Hah, ain't that weird.  That's the trace you reported on the other
>  > mail, right?  I'll follow up on that one.
> 
> just so there's no doubt, here's a fresh one.

Argh, found the culprit.  The unified mmap path grabs of->mutex to
check whether the file implements mmap, which means that if you try to
mmap a file which doesn't implement mmap, you still add the locking
dependency.  I'm working on the fix.

Thanks.

-- 
tejun

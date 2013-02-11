Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760655Ab3BKX5E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 18:57:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42270 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760072Ab3BKX5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 18:57:03 -0500
Date: Mon, 11 Feb 2013 15:57:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Josh Boyer <jwboyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: Odd ENOMEM being returned in 3.8-rcX
Message-Id: <20130211155701.e7968e64.akpm@linux-foundation.org>
In-Reply-To: <87k3qiwomi.fsf@xmission.com>
References: <20130207215742.GB31684@hansolo.jdub.homelinux.org>
	<20130207141502.04625ea0.akpm@linux-foundation.org>
	<20130208003501.GC31684@hansolo.jdub.homelinux.org>
	<20130208181949.GD31684@hansolo.jdub.homelinux.org>
	<87k3qiwomi.fsf@xmission.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Feb 2013 12:13:09 -0800
ebiederm@xmission.com (Eric W. Biederman) wrote:

> If mock has called unshare(CLONE_NEWPID). And then forked a process and
> that process exited, and then forked anothe process that second and all
> subsequent fork calls will fail with -ENOMEM (because init has exited in
> the pid namespace).  -ENOMEM will be generated because of a failure of
> alloc_pid.

Can we please fix this?  The system is *not* out of memory and it's
wildly misleading to report this to userspace.

If alloc_pid() can fail for multiple reasons then it should be
returning an ERR_PTR on failure, not NULL.


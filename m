Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbaFZOEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 10:04:10 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:59035 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753AbaFZOEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 10:04:07 -0400
Message-ID: <1403791442.31994.2.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 1/1] ima: fix fallback to use new_sync_read()
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com
Date: Thu, 26 Jun 2014 10:04:02 -0400
In-Reply-To: <53AC1FE2.50705@samsung.com>
References: <ffb4808ed8ce0dddbc96c566ccca2c9b39005643.1403616439.git.d.kasatkin@samsung.com>
	 <1403786949.2017.66.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <53AC1E1E.8040903@samsung.com> <53AC1FE2.50705@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062614-8236-0000-0000-000003666867
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-26 at 16:28 +0300, Dmitry Kasatkin wrote: 
> On 26/06/14 16:20, Dmitry Kasatkin wrote:
> > On 26/06/14 15:49, Mimi Zohar wrote:
> >> On Tue, 2014-06-24 at 16:27 +0300, Dmitry Kasatkin wrote: 
> >>> 3.16 commit aad4f8bb42af06371aa0e85bf0cd9d52c0494985
> >>> 'switch simple generic_file_aio_read() users to ->read_iter()'
> >>> replaced ->aio_read with ->read_iter in most of the file systems
> >>> and introduced new_sync_read() as a replacement for do_sync_read().
> >>>
> >>> Most of file systems set '->read' and ima_kernel_read is not affected.
> >>> When ->read is not set, this patch adopts fallback call changes from the
> >>> vfs_read.
> >> So every time there are changes in vfs_read(), we're going to have to
> >> play catch up.  A better solution would be to refactor vfs_read() so
> >> that we could call it.
> >>
> >> Mimi
> > vfs_read was stable for decade.
> > And next will be the same.
> >
> > I followed the same approach we took to have an own version.
> >
> > Refactoring vfs_read is not the best approach as we have set_fs things
> > there.
> >
> > I would prefer to have "kernel_read_nosec" function along with
> > kernel_read/vfs_read, so changes could be
> > made noticeably together..
> 
> Another thing is that we do not increment system counters.
> That is may be not what public "__kernel_read" want to do...

As reference, look at fs/read_write.c: vfs_write() and __kernel_write().

thanks,

Mimi


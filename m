Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab3AQPPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 10:15:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42311 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593Ab3AQPPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 10:15:08 -0500
Date: Thu, 17 Jan 2013 13:14:59 -0200
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Chris Perl <chris.perl@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [ 18/71] SUNRPC: Ensure we release the socket write lock if the
 rpc_task exits early
Message-ID: <20130117151458.GA2872@herton-Z68MA-D2H-B3>
References: <20130115225340.367496998@linuxfoundation.org>
 <20130115225341.755424315@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130115225341.755424315@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 02:54:15PM -0800, Greg Kroah-Hartman wrote:
> 3.0-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Trond Myklebust <Trond.Myklebust@netapp.com>
> 
> commit 87ed50036b866db2ec2ba16b2a7aec4a2b0b7c39 upstream.
> 
> If the rpc_task exits while holding the socket write lock before it has
> allocated an rpc slot, then the usual mechanism for releasing the write
> lock in xprt_release() is defeated.
> 
> The problem occurs if the call to xprt_lock_write() initially fails, so
> that the rpc_task is put on the xprt->sending wait queue. If the task
> exits after being assigned the lock by __xprt_lock_write_func, but
> before it has retried the call to xprt_lock_and_alloc_slot(), then
> it calls xprt_release() while holding the write lock, but will
> immediately exit due to the test for task->tk_rqstp != NULL.
> 
> Reported-by: Chris Perl <chris.perl@gmail.com>
> Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This is marked only for kernel versions 3.1 and later, which looks
correct as it seems to address a problem starting with commit
43cedbf0e8dfb9c5610eb7985d5f21263e313802

-- 
[]'s
Herton

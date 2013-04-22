Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab3DVOn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:43:58 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:40119 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab3DVOnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:43:51 -0400
MIME-Version: 1.0
In-Reply-To: <20130422142218.GA26760@mwanda>
References: <CAJsYZ5kk=J_Sc7w5dbMbkWWv8dXEU0ojKjEKNqH=Q6Tf2f7mQg@mail.gmail.com>
	<20130422142218.GA26760@mwanda>
Date: Mon, 22 Apr 2013 10:43:50 -0400
Message-ID: <CAG6tG3xc3RHD7sZXaEbg1vLRhFj+6d1wY=us4BfxBfi5y0o4zg@mail.gmail.com>
Subject: Re: [BUG] staging: android: ashmem: Deadlock during ashmem_shrink
From: Robert Love <rlove@google.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Shankar Brahadeeswaran <shankoo77@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Bringert <bringert@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, devel@driverdev.osuosl.org,
        Hugh Dickins <hughd@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, anjanavk12@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 10:22 AM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> Read Al's email again:  https://lkml.org/lkml/2013/3/20/458
>
> I don't know much about VFS locking, but the ashmem locking seems
> pretty bogus to me.  Why can't multiple threads read() at the same
> time?

ashmem originally did not support read or write operations, just mmap,
which is all 99% of users want. The original concurrency model with
per-mapping ashmem_mutex's works fine there. It is only with the later
addition of read and write that locking becomes a cluster. If there
isn't an obvious way to refactor the locking, I'd suggest removing
read and write.

       Robert

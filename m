Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbaG0PNx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 11:13:53 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:46420 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbaG0PNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 11:13:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140727131917.GA32153@infradead.org>
References: <1406375881-18837-1-git-send-email-andrey.krieger.utkin@gmail.com>
	<20140727131917.GA32153@infradead.org>
Date: Sun, 27 Jul 2014 11:13:50 -0400
Message-ID: <CAHQdGtRzDzpOuwZYWaBake-bH0z0eyMd2g-RTVwO0d2f0Zmsow@mail.gmail.com>
Subject: Re: [PATCH] nfs3_list_one_acl(): check get_acl() result with IS_ERR_OR_NULL
From: Trond Myklebust <trond.myklebust@primarydata.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrey Utkin <andrey.krieger.utkin@gmail.com>,
        Linux Kernel mailing list <linux-kernel@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2014 at 9:19 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Sat, Jul 26, 2014 at 02:58:01PM +0300, Andrey Utkin wrote:
>> There was a check for result being not NULL. But get_acl() may return
>> NULL, or ERR_PTR, or actual pointer.
>> The purpose of the function where current change is done is to "list
>> ACLs only when they are available", so any error condition of get_acl()
>> mustn't be elevated, and returning 0 there is still valid.
>>
>> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=81111
>> Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
>
> Looks good, thanks!
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>
> should probably get a cc to stable as the original patch has one
> as well.

Why are we not passing the error code back to the caller here in the
case where we have one? One of the main purposes of returning an error
in get_acl() is to ensure that we pass -EOPNOTSUPP if the operation
fails due to lack of server support.

Cheers
  Trond

-- 
Trond Myklebust

Linux NFS client maintainer, PrimaryData

trond.myklebust@primarydata.com

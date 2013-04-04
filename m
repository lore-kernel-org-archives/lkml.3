Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760475Ab3DDNSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 09:18:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760435Ab3DDNSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 09:18:48 -0400
Date: Thu, 4 Apr 2013 15:18:32 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
X-X-Sender: lukas@localhost
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: "Theodore Ts'o" <tytso@mit.edu>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
Subject: Re: linux-next: build failure after merge of the ext4 tree
In-Reply-To: <20130404104319.42d97a8ad7badf00af7ef1e0@canb.auug.org.au>
Message-ID: <alpine.LFD.2.00.1304041516160.30499@localhost>
References: <20130404104319.42d97a8ad7badf00af7ef1e0@canb.auug.org.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Apr 2013, Stephen Rothwell wrote:

> Date: Thu, 4 Apr 2013 10:43:19 +1100
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> To: Theodore Ts'o <tytso@mit.edu>
> Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
>     Lukas Czerner <lczerner@redhat.com>
> Subject: linux-next: build failure after merge of the ext4 tree
> 
> Hi Ted,
> 
> After merging the ext4 tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> fs/ext4/resize.c: In function 'ext4_resize_fs':
> fs/ext4/ext4.h:1799:21: sorry, unimplemented: inlining failed in call to 'ext4_get_group_number': function body not available
> fs/ext4/resize.c:1882:10: sorry, unimplemented: called from here
> fs/ext4/ext4.h:1799:21: sorry, unimplemented: inlining failed in call to 'ext4_get_group_number': function body not available
> fs/ext4/resize.c:275:9: sorry, unimplemented: called from here
> fs/ext4/ext4.h:1799:21: sorry, unimplemented: inlining failed in call to 'ext4_get_group_number': function body not available
> fs/ext4/resize.c:287:9: sorry, unimplemented: called from here
> fs/ext4/ext4.h:1799:21: sorry, unimplemented: inlining failed in call to 'ext4_get_group_number': function body not available
> fs/ext4/resize.c:299:9: sorry, unimplemented: called from here
> fs/ext4/mballoc.c: In function 'ext4_mb_release_context':
> fs/ext4/ext4.h:1799:21: sorry, unimplemented: inlining failed in call to 'ext4_get_group_number': function body not available
> fs/ext4/mballoc.c:3347:6: sorry, unimplemented: called from here

I am afraid I do not understand why this is happening. The commit
simply replaces ext4_get_group_no_and_offset() with
ext4_get_group_number() which has the similar definition in the same
header file. Maybe someone knows what this is all about ?

> 
> Caused by commit dc351389caa5 ("ext4: introduce ext4_get_group_number()").
> 
> This build was done with gcc 4.6.3 if that matters.
> 
> I have used the ext4 tree from next-20130403 for today.
> 

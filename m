Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab3FGH1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 03:27:19 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:57219 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab3FGH1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 03:27:18 -0400
MIME-Version: 1.0
In-Reply-To: <20130607162830.9d7ce277a9eda2b54fe73e92@canb.auug.org.au>
References: <20130607162830.9d7ce277a9eda2b54fe73e92@canb.auug.org.au>
From: Peng Tao <bergwolf@gmail.com>
Date: Fri, 7 Jun 2013 15:26:56 +0800
Message-ID: <CA+a=Yy7BOcCXjZnbiZArWf=JCeSyp7k=J4DaBhQYQjy2ASgGkw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the akpm tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>, Glauber Costa <glommer@openvz.org>,
        Greg KH <greg@kroah.com>, "Dilger, Andreas" <andreas.dilger@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 7, 2013 at 2:28 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Andrew,
>
> After merging the akpm tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> In file included from drivers/staging/lustre/include/linux/libcfs/linux/libcfs.h:49:0,
>                  from drivers/staging/lustre/include/linux/libcfs/libcfs.h:44,
>                  from drivers/staging/lustre/include/linux/lnet/linux/lib-lnet.h:45,
>                  from drivers/staging/lustre/include/linux/lnet/lib-lnet.h:44,
>                  from drivers/staging/lustre/lnet/lnet/api-ni.c:38:
> drivers/staging/lustre/include/linux/libcfs/linux/linux-mem.h: In function 'set_shrinker':
> drivers/staging/lustre/include/linux/libcfs/linux/linux-mem.h:102:3: error: 'struct shrinker' has no member named 'shrink'
>   s->shrink = func;
>    ^
>
> Caused by commit a37f14f05f2f ("shrinker: Kill old ->shrink API") from
> the akpm tree interacting with the new Lustre client code from the
> staging tree.
>
> I have just disabled the Lustre client code again (by reverting commit
> ee04fd11f11f ("Revert "Revert "staging/lustre: drop CONFIG_BROKEN
> dependency""")) and maybe someone can tell me what I need to do to fix
> this when I get back in a week.
I have a patchset to fix this but haven't yet sent out because it will
break build in Greg's staging tree. I can send it now but please tell
me to whom I should send the patches? Greg's tree doesn't contain
shrinker change, and mm- tree doesn't have Lustre code.

--
Thanks,
Tao

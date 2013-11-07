Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262Ab3KGFWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 00:22:19 -0500
Received: from mail.atsec.com ([195.30.99.214]:35524 "EHLO mail.atsec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115Ab3KGFWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 00:22:16 -0500
X-Greylist: delayed 543 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Nov 2013 00:22:16 EST
From: Stephan Mueller <stephan.mueller@atsec.com>
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Andreas Dilger <aedilger@gmail.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>, "Ted Ts'o" <tytso@mit.edu>,
        jakub@redhat.com, drepper@redhat.com,
        James Morris <james.l.morris@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] binfmt_elf.c: use get_random_int() to fix entropy depleting
Date: Thu, 07 Nov 2013 06:13:08 +0100
Message-ID: <2161006.F8akiOkWYa@tauon>
Organization: atsec information security GmbH
User-Agent: KMail/4.11.2 (Linux/3.11.6-200.fc19.x86_64; KDE/4.11.2; x86_64; ; )
In-Reply-To: <527B1399.8090805@oracle.com>
References: <50A46BBD.3060701@oracle.com> <527B1399.8090805@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 7. November 2013, 12:14:17 schrieb Jeff Liu:

Hi Jeff,

>Hi Stephan,
>
>As per your previous comments for this fix, you have promised another
>approach which is promising to avoid entropy starvation, I got this
>info from the following thread: [PATCH] avoid entropy starvation due
>to stack protection
>https://lkml.org/lkml/2012/12/14/267

There are several solutions:

- Ted is trying to prevent a constant reseeding of the nonblocking_pool 
from the input_pool with a set of patches. I am unsure whether these 
patches find their way into the kernel. With those patches, we can 
happily keep get_random_bytes without too much strain on the input_pool 
entropy -- i.e. drop the conversion to get_random_int.

- The begin of the email thread contains a patch that adds a new pool 
which I called the kernel_pool that is just just for kernel internal 
purposes. With Teds proposed changes to nonblocking_pool, 
nonblocking_pool would behave almost like my kernel_pool and thus my 
kernel_pool patch would not be needed.

- Lastly I am trying to add a new seed source to random.c and kernel 
crypto API which could also be used as a stand-alone noise source. That 
proposed noise source would effectively alleviate a lot of entropy 
problems. The discussion for inclusion is raging at 
http://lkml.org/lkml/2013/10/11/582. Ted is having concerns and we are 
in a discussion to address those.
>
>My current fix has been merged into Andrew's tree(marked in "stuck"
>state) for a long time, and it also works well in our internal
>specific kernel, I'd like to know if there is any update from you, so
>that we can move it along for mainline. :)
>
>Thanks,
>-Jeff


Ciao
Stephan


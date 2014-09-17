Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbaIQPk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 11:40:26 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:59535 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626AbaIQPkY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 11:40:24 -0400
MIME-Version: 1.0
In-Reply-To: <5419AA71.4020506@osg.samsung.com>
References: <1410821984-11160-1-git-send-email-bobby.prani@gmail.com>
 <CANq1E4Q_KfDamkCMatGFYCQ0VPfc6tbd7sWT_z_qDeboiNzgNw@mail.gmail.com> <5419AA71.4020506@osg.samsung.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Wed, 17 Sep 2014 11:39:51 -0400
Message-ID: <CAJhHMCCUUe+e6j9A=44RwVx31zGEScLTz-ptQkCfF9=rjvdcYQ@mail.gmail.com>
Subject: Re: [PATCH] selftests/memfd: Run test on all architectures
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: David Herrmann <dh.herrmann@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Phong Tran <tranmanphong@gmail.com>,
        "open list:KERNEL SELFTEST F..." <linux-api@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 11:36 AM, Shuah Khan <shuahkh@osg.samsung.com> wrote:

> Hmm. I am seeing failures on x86_64 on top of Linus's tree
> (without this patch)
>
> make -C tools/testing/selftests/memfd/make: Entering directory
> `/lkml/linus_git_3.14/tools/testing/selftests/memfd'
> gcc -D_FILE_OFFSET_BITS=64
> -I../../../../arch/x86/include/generated/uapi/
> -I../../../../arch/x86/include/uapi/ -I../../../../include/uapi/
> -I../../../../include/ memfd_test.c -o memfd_test
> memfd_test.c: In function ‘sys_memfd_create’:
> memfd_test.c:26:17: error: ‘__NR_memfd_create’ undeclared (first use in
> this function)
>   return syscall(__NR_memfd_create, name, flags);
>                  ^
> memfd_test.c:26:17: note: each undeclared identifier is reported only
> once for each function it appears in
>
> Could you please look into this?? It appears __NR_memfd_create isn't
> defined on x86_64???
>

Hi Shuah,

Did you compile the tree before trying to compile this test? Compiling
the kernel will generate the required symbols which are used in this
test.

Thanks!
-- 
Pranith

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbaIQPj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 11:39:57 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:40034 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbaIQPjy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 11:39:54 -0400
MIME-Version: 1.0
In-Reply-To: <5419AA71.4020506@osg.samsung.com>
References: <1410821984-11160-1-git-send-email-bobby.prani@gmail.com>
	<CANq1E4Q_KfDamkCMatGFYCQ0VPfc6tbd7sWT_z_qDeboiNzgNw@mail.gmail.com>
	<5419AA71.4020506@osg.samsung.com>
Date: Wed, 17 Sep 2014 17:39:53 +0200
Message-ID: <CANq1E4QP_=tqGLo6cHp1O8w-gbbu0Gvn-7MuxV2Hq6YXCOzULQ@mail.gmail.com>
Subject: Re: [PATCH] selftests/memfd: Run test on all architectures
From: David Herrmann <dh.herrmann@gmail.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Pranith Kumar <bobby.prani@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Phong Tran <tranmanphong@gmail.com>,
        "open list:KERNEL SELFTEST F..." <linux-api@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, Sep 17, 2014 at 5:36 PM, Shuah Khan <shuahkh@osg.samsung.com> wrote:
> On 09/17/2014 06:28 AM, David Herrmann wrote:
>> Hi
>>
>> On Tue, Sep 16, 2014 at 12:59 AM, Pranith Kumar <bobby.prani@gmail.com> wrote:
>>> Remove the dependence on x86 to run the memfd test. Verfied on 32-bit powerpc.
>>>
>>> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>>
>> Now that most archs have __NR_memfd_create, this is:
>>
>> Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
>>
>
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

You need the headers installed in your system. By dropping the
arch-includes from the Makefile, we require 3.17 headers in
/usr/include.

Thanks
David

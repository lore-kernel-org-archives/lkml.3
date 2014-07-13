Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbaGMEJA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 00:09:00 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:38226 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaGMEIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 00:08:52 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDOMVgi8Cw8z_i7bTEXQSRWbOiu7kQSpAnnDkyWCkr=yf7xsQ@mail.gmail.com>
References: <20140711171844.39fcbb50@canb.auug.org.au>
	<CAPDOMVgi8Cw8z_i7bTEXQSRWbOiu7kQSpAnnDkyWCkr=yf7xsQ@mail.gmail.com>
Date: Sun, 13 Jul 2014 00:08:48 -0400
Message-ID: <CAPDOMVi1fb5Moj8QYLW4bk07KysBoObtW8Y+vxssuz9LR3Ef+Q@mail.gmail.com>
Subject: Re: linux-next: Tree for Jul 11
From: Nick Krause <xerofoify@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 6:26 PM, Nick Krause <xerofoify@gmail.com> wrote:
> On Fri, Jul 11, 2014 at 3:18 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi all,
>>
>> Changes since 20140710:
>>
>> My fixes tree contains:
>>         powerpc: Disable RELOCATABLE for COMPILE_TEST with PPC64
>>
>> The tty.current tree gained a build failure so I used the version from
>> next-20140710.
>>
>> The irqchip tree gained a conflict against the arm64 tree.
>>
>> The staging tree lost its build failure and gained a conflict against
>> the tty tree.
>>
>> Non-merge commits (relative to Linus' tree): 5114
>>  4474 files changed, 191199 insertions(+), 226003 deletions(-)
>>
>> ----------------------------------------------------------------------------
>>
>> I have created today's linux-next tree at
>> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
>> (patches at http://www.kernel.org/pub/linux/kernel/next/ ).  If you
>> are tracking the linux-next tree using git, you should not use "git pull"
>> to do so as that will try to merge the new linux-next release with the
>> old one.  You should use "git fetch" and checkout or reset to the new
>> master.
>>
>> You can see which trees have been included by looking in the Next/Trees
>> file in the source.  There are also quilt-import.log and merge.log files
>> in the Next directory.  Between each merge, the tree was built with
>> a ppc64_defconfig for powerpc and an allmodconfig for x86_64 and a
>> multi_v7_defconfig for arm. After the final fixups (if any), it is also
>> built with powerpc allnoconfig (32 and 64 bit), ppc44x_defconfig and
>> allyesconfig (this fails its final link) and i386, sparc, sparc64 and arm
>> defconfig.
>>
>> Below is a summary of the state of the merge.
>>
>> I am currently merging 222 trees (counting Linus' and 30 trees of patches
>> pending for Linus' tree).
>>
>> Stats about the size of the tree over time can be seen at
>> http://neuling.org/linux-next-size.html .
>>
>> Status of my local build tests will be at
>> http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
>> advice about cross compilers/configs that work, we are always open to add
>> more builds.
>>
>> Thanks to Randy Dunlap for doing many randconfig builds.  And to Paul
>> Gortmaker for triage and bug fixes.
>>
>> --
>> Cheers,
>> Stephen Rothwell                    sfr@canb.auug.org.au
>>

> I am been trying your tests for a while. Seems most of your failing
> tests work for me.
> Can you test a newer compiler in the 4.8 release series for gcc to see
> if this fixes your
> issues.
> Cheers Nick
I am also attaching logs of build I have that are succeeding to help
you.Furthermore I run the builds in two steps listed below using
compilers for
Ubuntu 14.04 and Fedora 20 turned into dpkgs to work with Debian
distros.Below are the steps.
1. make ARCH=x y_defconfig
2.ARCH= x CROSS_COMPILE=z make -j 8 2> error_file
x = cpu architecture  I am building
y=configuration I am building
z= gcc I am builds this architecture
error_file = file I am tracing errors and warnings to send if build
fails to maintainers of that architecture
If you have any other questions please ask me.
Cheers Nick

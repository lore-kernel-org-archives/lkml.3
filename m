Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab3HaOZn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 10:25:43 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50245 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab3HaOZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 10:25:42 -0400
Message-ID: <5221FCE0.7020606@gmail.com>
Date: Sat, 31 Aug 2013 23:25:36 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: dm-devel@redhat.com
CC: Valdis.Kletnieks@vt.edu, mpatocka@redhat.com, agk@redhat.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        kernelnewbies@kernelnewbies.org
Subject: Re: [dm-devel] [RFC] dm-writeboost: plan to go to staging
References: <521EA567.1070801@gmail.com> <20130829020555.GA26206@kroah.com> <20130829033023.GH4872@agk-dp.fab.redhat.com> <alpine.LRH.2.02.1308291043410.20142@file01.intranet.prod.int.rdu2.redhat.com>            <52209119.3070907@gmail.com> <50810.1377874041@turing-police.cc.vt.edu>
In-Reply-To: <50810.1377874041@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Progress report for staging dm-writeboost.

(1) Renaming to dm-writeboost
Thanks for comments on renaming.

By a simple democratic,
dm-lc will be renamed to dm-writeboost.
I am really happy with the new name.

(2) Idea for smelling limitation on the kind of backing store
Now I am tackling on the design issues.
As Alasdair pointed out
the statement below from my document really smells
and seems to be the first priority at this point.

  Be careful, you MUST create all the LVs as the destinations of
  the dirty blocks on the cache device before this operation.  Otherwise,
  the kernel may crash.

Aside from the two small requirements by Alasdair,
I may have to shoot out this problem before sending patch to staging tree.
> Two simple requirements before putting your proof-of-concept into staging
> if you want to work that way:
> 
> 1) Drop the major version number to 0.  Version 1 is reserved for
> supported modules.
> 
> 2) Agree a new and meaningful target name with us so you don't have to
> change it later.  "lc" means nothing, I'm afraid.

My investigation today revealed that this statement is too pessimistic.
The truth is only that
the backing store should not be some partition out of a disk,
say /dev/sdd1 out of /dev/sdd.

With the partition number,
my userland script works badly in attaching a device to a cache.
It failed to get the correct device name from sysfs.

I am thinking of addressing this problem by
adding new sysfs member to show device number(major:minor) of the backing store
which is likely to maintain backward-compatibility and
doing some modification on the Python scripts.

That's very easy.
I will do this before sending a patch for staging
aside said two requirements.

(3) Draft for TODO and MAINTAINERS files
These are the current drafts for TODO and MAINTAINERS files.
Please let me know if you find more to write or simple mistakes.

(3-1) TODO file
TODO:
    - Get feedback from 3rd party users.
    - Reviewed by Mike Snitzer.
    - Audit userspace interfaces to make sure they are sane.
      Should use the same approach that is proven successful.
    - Fix document.
      Should document the kernel interfaces
      rather than particular userspace tools.
    - Add more comments inline
      to explain what it does and how it works.

Please send patches to Greg Kroah-Hartman <gregkh@linuxfoundation.org> and Cc:
Akira Hayakawa <ruby.wktk@gmail.com>

(3-2) part of MAINTAINERS file
M:      Greg Kroah-Hartman <gregkh@linuxfoundation.org>
M:      Akira Hayakawa <ruby.wktk@gmail.com>
S:      Maintained
L:      dm-devel@redhat.com
W:      https://github.com/akiradeveloper/dm-writeboost.git
F:      drivers/staging/dm-writeboost.git

(4) Next steps
- Fixed all source codes and documents as they are of
  dm-writeboost but not dm-lc.
- Github repo will be renamed.
- Complete the task said at (2).
- Generating a patch against linux-next
  and send it to Greg.

Thanks for your reading,
Akira

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400AbaGSQc5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 12:32:57 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:52865 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087AbaGSQc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 12:32:56 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.11.1407160307460.1775@eggly.anvils>
References: <1402655819-14325-1-git-send-email-dh.herrmann@gmail.com>
	<1402655819-14325-6-git-send-email-dh.herrmann@gmail.com>
	<alpine.LSU.2.11.1407160307460.1775@eggly.anvils>
Date: Sat, 19 Jul 2014 18:32:55 +0200
Message-ID: <CANq1E4TDfQ3dXOgaaSD5dwVMk4seYzE0TW0_4smP2Aj0p0TrPQ@mail.gmail.com>
Subject: Re: [PATCH v3 5/7] selftests: add memfd/sealing page-pinning tests
From: David Herrmann <dh.herrmann@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>, Ryan Lortie <desrt@desrt.ca>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Greg Kroah-Hartman <greg@kroah.com>,
        John Stultz <john.stultz@linaro.org>,
        Lennart Poettering <lennart@poettering.net>,
        Daniel Mack <zonque@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Tony Battersby <tonyb@cybernetics.com>,
        Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, Jul 16, 2014 at 12:08 PM, Hugh Dickins <hughd@google.com> wrote:
> On Fri, 13 Jun 2014, David Herrmann wrote:
>
>> Setting SEAL_WRITE is not possible if there're pending GUP users. This
>> commit adds selftests for memfd+sealing that use FUSE to create pending
>> page-references. FUSE is very helpful here in that it allows us to delay
>> direct-IO operations for an arbitrary amount of time. This way, we can
>> force the kernel to pin pages and then run our normal selftests.
>>
>> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
>
> I had a number of problems in getting this working (on openSUSE 13.1):
> rpm told me I had fuse installed, yet I had to download and install
> the tarball to get header files needed; then "make fuse_mnt" told me
> to add -D_FILE_OFFSET_BITS=64 to the compile flags; after which I
> got "undefined reference to `fuse_main_real'"; but then I tried
> "make run_fuse" as root, and it seemed to sort these issues out
> for itself, aside from "./run_fuse_test.sh: Permission denied" -
> which was within my bounds of comprehension unlike the rest!
>
> No complaint, thanks for providing the test (though I didn't check
> the source to convince myself that "DONE" has done what's claimed):
> some rainy day someone can get the Makefile working more smoothly,
> no need to delay the patchset for this.

_FILE_OFFSET_BITS=64 makes sense. I added it. The "undefined ref"
thing doesn't make sense to me and I cannot reproduce it. I will see
what I can do.

The "Permission denied" obviously just requires access to /dev/fuse,
as you figured out yourself.

Thanks
David

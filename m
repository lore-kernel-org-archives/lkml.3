Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423Ab3BERQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 12:16:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:43787 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755978Ab3BERQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 12:16:42 -0500
MIME-Version: 1.0
In-Reply-To: <20130205164817.GD2335@fenchurch.internal.datastacks.com>
References: <cover.1360067333.git.dmitry.kasatkin@intel.com>
	<7fe9b3a51f3b7172fcb85721cea9162f840aaaa6.1360067333.git.dmitry.kasatkin@intel.com>
	<20130205164817.GD2335@fenchurch.internal.datastacks.com>
Date: Tue, 5 Feb 2013 19:16:40 +0200
Message-ID: <CALLzPKYLqR-rXyf4FFQpo31tTNsKm1=gyfeVi==LPqV6qX8jSw@mail.gmail.com>
Subject: Re: [RFC 1/2] export unpack_to_rootfs
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Peter Jones <pjones@redhat.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 5, 2013 at 6:48 PM, Peter Jones <pjones@redhat.com> wrote:
> On Tue, Feb 05, 2013 at 02:34:49PM +0200, Dmitry Kasatkin wrote:
>> Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
>> ---
>>  init/do_mounts.h |    2 ++
>>  init/initramfs.c |    2 +-
>>  2 files changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/init/do_mounts.h b/init/do_mounts.h
>> index f5b978a..11829eb 100644
>> --- a/init/do_mounts.h
>> +++ b/init/do_mounts.h
>> @@ -74,3 +74,5 @@ void md_run_setup(void);
>>  static inline void md_run_setup(void) {}
>>
>>  #endif
>> +
>> +char * __init unpack_to_rootfs(char *buf, unsigned len);
>> diff --git a/init/initramfs.c b/init/initramfs.c
>> index 84c6bf1..e32bc06 100644
>> --- a/init/initramfs.c
>> +++ b/init/initramfs.c
>> @@ -421,7 +421,7 @@ static unsigned my_inptr;   /* index of next byte to be processed in inbuf */
>>
>>  #include <linux/decompress/generic.h>
>>
>> -static char * __init unpack_to_rootfs(char *buf, unsigned len)
>> +char * __init unpack_to_rootfs(char *buf, unsigned len)
>>  {
>>       int written, res;
>>       decompress_fn decompress;
>
> Doing this unconditionally seems to be inviting rootkit authors to use a
> new and shiny tool.  I also don't think it's the best way to do this,
> but I'll comment on the other patch to explain why.
>

Sorry for re-post, but answering from mobile was in HTML and it was blocked.
Modifying an initramfs gives the same opportunity during boot only.
But agreed, it might be the part of the primary source code. It was
very to do it in this way to implement and test a solution.

Thanks.

> --
>         Peter

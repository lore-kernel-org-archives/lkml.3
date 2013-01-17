Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab3AQVrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 16:47:01 -0500
Received: from mga10.intel.com ([192.55.52.92]:1848 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753698Ab3AQVq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 16:46:59 -0500
MIME-Version: 1.0
In-Reply-To: <20130117205543.GA6133@redhat.com>
References: <20130116144836.GB29845@redhat.com>
	<1358350391.4593.112.camel@falcor1>
	<20130116163453.GD29845@redhat.com>
	<1358359715.4593.146.camel@falcor1>
	<20130116182804.GF29845@redhat.com>
	<1358364290.4593.178.camel@falcor1>
	<20130116215341.GA4222@redhat.com>
	<CALLzPKam_j==PXtNfQs93NbPTrYCjqM_0+XRfnvxrJBLdOJ-vQ@mail.gmail.com>
	<20130117151825.GA12165@redhat.com>
	<y0my5frsg5w.fsf@fche.csb>
	<20130117205543.GA6133@redhat.com>
Date: Thu, 17 Jan 2013 23:46:57 +0200
Message-ID: <CALLzPKaizfTZCh3A0w8-RyAy4qwgXSyckYpHttrUawLnmYjFGw@mail.gmail.com>
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, pjones@redhat.com, hpa@zytor.com,
        dhowells@redhat.com, jwboyer@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 10:55 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Jan 17, 2013 at 03:33:47PM -0500, Frank Ch. Eigler wrote:
>> Vivek Goyal <vgoyal@redhat.com> writes:
>>
>> > [...]
>> >> Can you please tell a bit more how this patch protect against direct
>> >> writing to the blocks?
>> >
>> > If you have loaded all the pages from disk and locked them in memory and
>> > verified the signature, then even if somebody modifies a block on disk
>> > it does not matter. We will not read pages from disk anymore for this
>> > exec(). We verified the signature of executable loaded in memory and
>> > in-memory copy is intact.
>>
>> Does this imply dramatically increasing physical RAM pressure and load
>> latency, because binaries (and presumably all their shared libraries)
>> have to be locked & loaded?  (Else if they are paged out to
>> encrypted-swap, is that sufficient protection against manipulation?)
>
> Even if you employ encrypted-swap, we still need to lock down any code
> and data which lives in executable file on disk to avoid the case of
> it being modified directly by writing to a block. Looks like IMA will not
> detect that case.
>

See my IMA patch I set today, which does locking the same way as you do.

- Dmitry

> May be we can only lock down any information which is loaded from
> executable file. Rest of the pages can be swapped to encrypted swap.
>
> As long as number of signed binaries are small, I think RAM pressure might
> not be a problem but yes, if we sign everything, it will become an issue.
>
> I am not sure how kernel can enforce the requirement of encrypted swap. If
> we leave it to user as a recommendation, then we have the potential that
> some hacker can bypass the whole thing. So it is not enforceable.
>
> May be there could be a config option if that's enabled swapping works only
> if it is encrypted.
>
> So locking few select statically compiled executables completely in memory
> I think should not be too much of trouble and solve the problem I have at
> hand.
>
> For the more generic case of completely locked system, we will have to
> conditionally modify the code to lock only any info loaded from executable
> and allow swapping other data to encrypted swap. This one we can look into
> once somebody really wants to use it.
>
> Thanks
> Vivek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

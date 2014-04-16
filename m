Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbaDPQyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:54:45 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:42670 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbaDPQyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:54:43 -0400
MIME-Version: 1.0
In-Reply-To: <534EB17D.6090307@linaro.org>
References: <1397658459-4357-1-git-send-email-waydi1@gmail.com>
	<1397659190.32088.4.camel@joe-AO722>
	<534EB17D.6090307@linaro.org>
Date: Wed, 16 Apr 2014 09:54:42 -0700
X-Google-Sender-Auth: 2xOhpQj-VBqKarzLOeb607CcbRw
Message-ID: <CAMbhsRQL6vT4TvWEB0qofPPScZkMDP+Ktkv2dvtP4c1Aa1DNuw@mail.gmail.com>
Subject: Re: [PATCH] staging : android : uapi : fix coding style
From: Colin Cross <ccross@android.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Joe Perches <joe@perches.com>, Seunghun Lee <waydi1@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Brian Swetland <swetland@google.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resending without the html)

On Wed, Apr 16, 2014 at 9:36 AM, John Stultz <john.stultz@linaro.org> wrote:
>
> On 04/16/2014 07:39 AM, Joe Perches wrote:
> > On Wed, 2014-04-16 at 23:27 +0900, Seunghun Lee wrote:
> >> This patch fix checkpatch.pl warnings and errors.
> > []
> >> diff --git a/drivers/staging/android/uapi/binder.h b/drivers/staging/android/uapi/binder.h
> > []
> >> @@ -169,7 +169,7 @@ struct binder_ptr_cookie {
> >>  struct binder_handle_cookie {
> >>      __u32 handle;
> >>      binder_uintptr_t cookie;
> >> -} __attribute__((packed));
> >> +} __packed;
> > If this .h file is meant to be a user-space #include,
> > then it should not use the kernel specific __packed
> > but keep the __attribute__((packed))
>
> Agreed.
>
> > It does use __u32 though and that's generally
> > kernel specific.
>
> Hmm. Theres a ton of __u32 usage in include/uapi/*  as well as typedefs
> for it too.
> include/uapi/asm-generic/int-l64.h:typedef unsigned int __u32;
> include/uapi/asm-generic/int-ll64.h:typedef unsigned int __u32;
>
> > John?  Does any of these binder uapi files need a
> > bit more sorting out?
> I suspect this is ok, but Cc'ing Colin to give him a heads up, as it
> would probably cause trouble w/ their libc headers first.

__u32 is explicitly for use in userspace headers so it doesn't
conflict with userspace definitions of u32, uint32_t, etc.  It gets
set through #include <linux/types.h> when a copy of include/uapi is in
the include path.

>From Documentation/CodingStyle:
 (e) Types safe for use in userspace.

     In certain structures which are visible to userspace, we cannot
     require C99 types and cannot use the 'u32' form above. Thus, we
     use __u32 and similar types in all structures which are shared
     with userspace.

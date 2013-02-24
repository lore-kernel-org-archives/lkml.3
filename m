Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab3BXJwI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 04:52:08 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:39364 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab3BXJwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 04:52:05 -0500
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKkaTStWRDQLOb6HxM7sGyj+1ekxxkGK8hw6rWkHRrVsQ@mail.gmail.com>
References: <20130223072959.GA4894@www.outflux.net> <CAE8XmWoX_TyHMTnGCMn6j_qiK0hptCgyrnVYpDJkfTAQfUNQPA@mail.gmail.com>
 <CAGXu5jKkaTStWRDQLOb6HxM7sGyj+1ekxxkGK8hw6rWkHRrVsQ@mail.gmail.com>
From: Dongsheng Song <dongsheng.song@gmail.com>
Date: Sun, 24 Feb 2013 17:51:44 +0800
Message-ID: <CAE8XmWq+dA5Pvhyoxm2Nqbt0psLpPxUdR7i5MKFhxVxubY0QtQ@mail.gmail.com>
Subject: Re: [PATCH] arch/x86/xen: remove depends on CONFIG_EXPERIMENTAL
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Mukesh Rathor <mukesh.rathor@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2013 at 1:03 AM, Kees Cook <keescook@chromium.org> wrote:
> On Sat, Feb 23, 2013 at 3:59 AM, Dongsheng Song
> <dongsheng.song@gmail.com> wrote:
>> On Sat, Feb 23, 2013 at 3:29 PM, Kees Cook <keescook@chromium.org> wrote:
>>>
>>> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
>>> while now and is almost always enabled by default. As agreed during the
>>> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
>>>
>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>> Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>>> Cc: Mukesh Rathor <mukesh.rathor@oracle.com>
>>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>>> ---
>>>  arch/x86/xen/Kconfig |    2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
>>> index 93ff4e1..8cada4c 100644
>>> --- a/arch/x86/xen/Kconfig
>>> +++ b/arch/x86/xen/Kconfig
>>> @@ -53,7 +53,7 @@ config XEN_DEBUG_FS
>>>
>>>  config XEN_X86_PVH
>>>         bool "Support for running as a PVH guest (EXPERIMENTAL)"
>>
>> Why not remove this 'EXPERIMENTAL' too ?
>
> It was unclear to me if the feature was actually considered unstable.
> I can resend with the text removed from the title too, if that's the
> correct action here?
>
> -Kees
>

If such a feature was considered unstable, it should depends on EXPERIMENTAL.
We should not surprised users.

>>
>>> -       depends on X86_64 && XEN && EXPERIMENTAL
>>> +       depends on X86_64 && XEN
>>>         default n
>>>         help
>>>            This option enables support for running as a PVH guest (PV guest
>>> --
>>> 1.7.9.5
>>>
>>>
>>> --
>>> Kees Cook
>>> Chrome OS Security
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
> --
> Kees Cook
> Chrome OS Security

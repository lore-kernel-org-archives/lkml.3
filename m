Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683Ab3ANS5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 13:57:11 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:58098 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756331Ab3ANS5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 13:57:10 -0500
MIME-Version: 1.0
In-Reply-To: <50F4452D.2060000@zytor.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-23-git-send-email-yinghai@kernel.org>
	<20130113214132.GB17200@liondog.tnic>
	<CAE9FiQVQRAOtw7kiPJO3xszJx9uPFjgK82PjbvTyqzJgujdicw@mail.gmail.com>
	<50F4452D.2060000@zytor.com>
Date: Mon, 14 Jan 2013 10:57:08 -0800
X-Google-Sender-Auth: zPLYhbSlqqgODCJxsn5OWpbbMKI
Message-ID: <CAE9FiQXkgoLKp3ZnOcM9gLDJNGNxUE8WSRXiQy1G_v5Os5_v2A@mail.gmail.com>
Subject: Re: [PATCH v7u1 22/31] x86, boot: add fields to support load bzImage
 and ramdisk above 4G
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Matt Fleming <matt.fleming@intel.com>,
        Gokul Caushik <caushik1@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 9:49 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 01/13/2013 09:37 PM, Yinghai Lu wrote:
>>>
>>>
>>> This is kinda missing from the mechanism of the sentinel and it should
>>> be documented too.
>>
>>
>> No, we should have too much duplicated info.
>>
>
> That is not duplicating info... that is basic documentation.  As you show in
> the post further on, it took a very simple description, and it *is* a very
> subtle thing that is inherently different from how the other fields operate.

please check if following is enough?

+       /*
+        * kernel have sentinel to set as 0xff in setup link scripts,
+        * so if bootloader just copy whole page from kernel image to
+        * get setup_header instead of clearing boot_param buffer and
+        * copying setup_header only, will leave sentinel as 0xff.
+        * With that, we can tell some fields in boot_param have
+        * invalid values, and we need to zero them in kernel.
+        */
+       __u8  sentinel;                                 /* 0x1ef */


>
> It doesn't help that you didn't, despite repeated requests, implement what I
> *asked for*, which is:
>
> If the sentinel is flagged, zero *all fields not explicitly set by the
> broken versions of kexec*, not just your new "ext" fields.

other fields are pad* fields, so do we zero out them
with memset with exact address?
so next times, when someone change pad fields to other ext_*,
they don't need to change code again here.


>
> Yinghai, I understand you're frustrated, but please understand that Borislav
> is not in any shape, way, or form "some guys that do not know the code well
> keep sending comments out to waste others time".  Rather, he has spent a
> huge amount of time giving you an awful lot of good feedback  A lot of them
> have centered on documentation and code maintainability, both of which are
> vitally important part of a long-lived codebase.
>
> Having someone doing line-by-line review of your code is enormously
> time-consuming and not something most people enjoy doing.  Borislav is doing
> you -- and me -- a huge favor here.

yes.

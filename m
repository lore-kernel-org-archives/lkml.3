Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670Ab3ANUOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 15:14:20 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:61372 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757741Ab3ANUOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 15:14:19 -0500
MIME-Version: 1.0
In-Reply-To: <20130114200505.GC2015@liondog.tnic>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-23-git-send-email-yinghai@kernel.org>
	<20130113214132.GB17200@liondog.tnic>
	<CAE9FiQVQRAOtw7kiPJO3xszJx9uPFjgK82PjbvTyqzJgujdicw@mail.gmail.com>
	<50F4452D.2060000@zytor.com>
	<CAE9FiQXkgoLKp3ZnOcM9gLDJNGNxUE8WSRXiQy1G_v5Os5_v2A@mail.gmail.com>
	<20130114200505.GC2015@liondog.tnic>
Date: Mon, 14 Jan 2013 12:14:18 -0800
X-Google-Sender-Auth: mqFrTFv7KCc1qB-EQUSGu-ikBSw
Message-ID: <CAE9FiQWXxmOnoc1wJzHUYCyO8hHvLOkNpGMwM8vVubjMAGJ5dA@mail.gmail.com>
Subject: Re: [PATCH v7u1 22/31] x86, boot: add fields to support load bzImage
 and ramdisk above 4G
From: Yinghai Lu <yinghai@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
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

On Mon, Jan 14, 2013 at 12:05 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Jan 14, 2013 at 10:57:08AM -0800, Yinghai Lu wrote:
>> please check if following is enough?
>>
>> +       /*
>> +        * kernel have sentinel to set as 0xff in setup link scripts,
>> +        * so if bootloader just copy whole page from kernel image to
>> +        * get setup_header instead of clearing boot_param buffer and
>> +        * copying setup_header only, will leave sentinel as 0xff.
>> +        * With that, we can tell some fields in boot_param have
>> +        * invalid values, and we need to zero them in kernel.
>> +        */
>> +       __u8  sentinel;                                 /* 0x1ef */
>
> "The sentinel variable is set by the linker script to 0xff. If a
> bootloader doesn't know about this variable and just copies the
> setup_header portion and doesn't clear the boot_params buffer as it is
> supposed to, it will leave the sentinel to its initial value of 0xff.

no, no, no.

bootloader does not need to know sentinel, and they only need to do:
    clearing boot_param buffer and copying setup_header only

even new bootloader is not supposed to know sentinel ...


>
> This tells the kernel that some fields in boot_params have invalid
> values and we have to zero them out in the kernel."

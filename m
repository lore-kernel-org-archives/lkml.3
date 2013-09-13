Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab3IMIis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 04:38:48 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:62149 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753Ab3IMIio convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 04:38:44 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYjzGwaV0Eg5KZ7W_9YYkyiAXDc-9oagU49XWJUooVKdQ@mail.gmail.com>
References: <cover.1376600922.git.yann.morin.1998@free.fr>
	<83e8b90e1d2cc5ff5d2443f2486c2d786a4997ce.1376600922.git.yann.morin.1998@free.fr>
	<CACRpkdYjzGwaV0Eg5KZ7W_9YYkyiAXDc-9oagU49XWJUooVKdQ@mail.gmail.com>
Date: Fri, 13 Sep 2013 10:38:43 +0200
Message-ID: <CACW0xKXOKJXW+5m7JirKbsj4Em4SbVV0NeyK2x88x46dfJ4akw@mail.gmail.com>
Subject: Re: [PATCH 2/4] scripts/config: use sed's POSIX interface
From: =?ISO-8859-1?Q?Cl=E9ment_Chauplannaz?= <chauplac@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>, linux-kbuild@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/9/12 Linus Walleij <linus.walleij@linaro.org>:
> On Thu, Aug 15, 2013 at 11:17 PM, Yann E. MORIN <yann.morin.1998@free.fr> wrote:
>
>> From: Clement Chauplannaz <chauplac@gmail.com>
>>
>> Script `config' relies on extensions of `GNU sed', and is thus not
>> working on all Unixes:
>>   - in-place edition of files (-i), which can be replaced with
>>     a temporary file;
>>   - extended-regexps (-r), which can be split into basic regexps;
>>   - single-line calls to `a' command, while some implementations
>>     require a leading newline before the parameter.
>>
>> Rewrite calls to `sed' to comply with POSIX interface, and move them
>> to helper functions.
>>
>> Signed-off-by: Clement Chauplannaz <chauplac@gmail.com>
>> Tested-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
>> Reviewed-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
>> Signed-off-by: Yann E. MORIN <yann.morin.1998@free.fr>
>
> This patch totally breaks my usage of the --set-str
> argument to "config".
>
> Reverting this patch solves the problem.
>
> Reproduce:
> make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi-
> KBUILD_OUTPUT=build-nomadik nhk8815_defconfig
> scripts/config --file build-nomadik/.config --set-str CMDLINE
> "root=/dev/ram0 console=ttyAMA1,115200n8 earlyprintk"
> sed: -e uttryck #1, tecken 44: flaggan okänd för "s"
> sed: -e uttryck #1, tecken 54: flaggan okänd för "s"
>
> Swedish messages meaning "unknown flag for "s""
>
> After reverting the patch these messages no longer appear.
>
> At failure my config file is scratched :-O
>
> Yours,
> Linus Walleij

Hello Linus,

Thank you for this report. I was able to reproduce this bug and fix it.

My previous commit changed the separator between sed's substitute
command and its parameters, from ':' to '/'. The latter conflicted
with the slashes found in the value of variable CMDLINE, as provided
in your email.

I'm sending a patch right now to revert to previous behavior.

Best regards,
Clement Chauplannaz

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab3ALNIR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 08:08:17 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:59993 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab3ALNIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 08:08:16 -0500
MIME-Version: 1.0
In-Reply-To: <50F10278.3050309@csamuel.org>
References: <50EEA4C4.4080103@csamuel.org>
	<50EFDE31.90709@csamuel.org>
	<CA+5PVA5hCuTar1F=g5vgT2Cj1ZbF7w+HcWzhATUx7wFs_kuSWw@mail.gmail.com>
	<50F10278.3050309@csamuel.org>
Date: Sat, 12 Jan 2013 08:08:15 -0500
Message-ID: <CA+5PVA7YmAM__aTN=FeGDL-V2njb1-LMbg5xE7FPPNkC2oApyQ@mail.gmail.com>
Subject: Re: MODSIGN: Modules fail signature verification with -ENOKEY
From: Josh Boyer <jwboyer@gmail.com>
To: Chris Samuel <chris@csamuel.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        dhowells@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2013 at 1:28 AM, Chris Samuel <chris@csamuel.org> wrote:
> /* Please CC, not on LKML */
>
> Hi Josh,
>
>
> On 12/01/13 00:44, Josh Boyer wrote:
>
>> Check the installed modules.  A simple:
>>
>>      hexdump -C <path to module> | tail -n 20
>>
>> should be enough to tell you if the installed modules at least look like
>> they're signed.  You should see the expected "~Module signature appended~"
>> string.  You could also check the modules in the kernel build tree for
>> the same thing. [...]
>
>
> Good call - neither the modules in the build tree, nor the installed ones
> are signed.   I did a "make mrproper", changed scripts/sign-file to be
> verbose by default and rebuilt.  That confirmed that the modules are getting
> signed, which left the possibility of make-kpkg stripping the modules after
> compiling as an option.

Having worked through 3 different versions of the module signing code, I
forgot that they aren't signed until you do modules_install now.  So the
modules in the build tree won't be signed.  I misspoke on that.  The
installed modules still should be.

> Google pointed me at the likely culprit, a patch from a certain Mr Ted Ts'o
> in 2009 to make-kpkg so that it would strip kernel modules by default.
>
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=517290
>
> I'll file a bug against it asking for the it to not strip if
> CONFIG_MODULE_SIG is set.
>
> Thanks for the pointer!

Great.  Glad you figured it out.

josh

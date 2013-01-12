Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab3ALG2d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 01:28:33 -0500
Received: from csamuel.org ([74.50.50.137]:41963 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab3ALG2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 01:28:32 -0500
Message-ID: <50F10278.3050309@csamuel.org>
Date: Sat, 12 Jan 2013 17:28:08 +1100
From: Chris Samuel <chris@csamuel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Josh Boyer <jwboyer@gmail.com>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        dhowells@redhat.com
Subject: Re: MODSIGN: Modules fail signature verification with -ENOKEY
References: <50EEA4C4.4080103@csamuel.org> <50EFDE31.90709@csamuel.org> <CA+5PVA5hCuTar1F=g5vgT2Cj1ZbF7w+HcWzhATUx7wFs_kuSWw@mail.gmail.com>
In-Reply-To: <CA+5PVA5hCuTar1F=g5vgT2Cj1ZbF7w+HcWzhATUx7wFs_kuSWw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/* Please CC, not on LKML */

Hi Josh,

On 12/01/13 00:44, Josh Boyer wrote:

> Check the installed modules.  A simple:
>
>      hexdump -C <path to module> | tail -n 20
>
> should be enough to tell you if the installed modules at least look like
> they're signed.  You should see the expected "~Module signature appended~"
> string.  You could also check the modules in the kernel build tree for
> the same thing. [...]

Good call - neither the modules in the build tree, nor the installed 
ones are signed.   I did a "make mrproper", changed scripts/sign-file to 
be verbose by default and rebuilt.  That confirmed that the modules are 
getting signed, which left the possibility of make-kpkg stripping the 
modules after compiling as an option.

Google pointed me at the likely culprit, a patch from a certain Mr Ted 
Ts'o in 2009 to make-kpkg so that it would strip kernel modules by default.

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=517290

I'll file a bug against it asking for the it to not strip if 
CONFIG_MODULE_SIG is set.

Thanks for the pointer!
Chris
-- 
  Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbbALViw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 16:38:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbbALViv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 16:38:51 -0500
Message-ID: <54B43EDA.2060607@redhat.com>
Date: Mon, 12 Jan 2015 16:38:34 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Borislav Petkov <bp@suse.de>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        matt.fleming@intel.com, oleg@redhat.com, pbonzini@redhat.com,
        tglx@linutronix.de, luto@amacapital.net
Subject: Re: [RFC PATCH 01/11] x86,fpu: document the data structures a little
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <1421012793-30106-2-git-send-email-riel@redhat.com> <20150112211802.GE5016@pd.tnic>
In-Reply-To: <20150112211802.GE5016@pd.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/12/2015 04:18 PM, Borislav Petkov wrote:
> On Sun, Jan 11, 2015 at 04:46:23PM -0500, riel@redhat.com wrote:

>> +++ b/arch/x86/include/asm/processor.h @@ -400,6 +400,11 @@
>> struct xsave_struct { /* new processor state extensions will go
>> here */ } __attribute__ ((packed, aligned (64)));
>> 
>> +/* + * The FPU state used depends on the capabilities of the
>> hardware; the + * registers used for vector instructions on newer
>> hardware are included + * in the FPU state. + */ union
>> thread_xstate { struct i387_fsave_struct	fsave; struct
>> i387_fxsave_struct	fxsave; @@ -408,8 +413,8 @@ union
>> thread_xstate { };
>> 
>> struct fpu { -	unsigned int last_cpu; -	unsigned int has_fpu; +
>> unsigned int last_cpu;		/* FPU state last loaded on this CPU */
> 
> Isn't that the last CPU which had the FPU?

Indeed it is. Good catch. I will fix it.

>> +	unsigned int has_fpu;		/* FPU state in current use on CPU */
> 
> I understand ->has_fpu as this thread has the FPU. See comment
> over user_has_fpu().

It does that currently, but the patch to __kernel_fpu_start() changes it
so it can point to a kernel FPU state as well.

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUtD7aAAoJEM553pKExN6D1TYH/34+5t9h+UxeVgqCxIAZuvAN
PY8r5PJMOdJb4hwbsbXfipA4oufRTXT3UrFYDUD2ASiJUv+P69FtXJgJRak0khJV
ZfOSXjnGA0WuTIWkTdXfl6H0RKxJd51Yc/EMgJL/kvnOucWBNjOPJnsWkQXrAan5
QJyM6WASFsUTjqAW3vzsKZwUmo/FnVh/FK/7pTVTqgZCI+j0WvitnGhD2J1A2Tvc
jlF2llmKQ/QxknW/HylurPAD4C68pw1AU08JcYtDmrRJGfweID/w5z+X3hd9xhjm
sEMjIKMTyrelj1K800uq0LXLw9gP7Vv7gNu6tMMWsle5wCTB0MrMH6/Qz3E/7Mk=
=5cE/
-----END PGP SIGNATURE-----

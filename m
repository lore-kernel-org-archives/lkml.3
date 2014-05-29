Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbaE2Tcv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 15:32:51 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:35979 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963AbaE2Tcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 15:32:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAP=VYLrzMP23B9NVnu4N3NYsoU+ai1K9HpAE_eXQzXESUUZ-Lg@mail.gmail.com>
References: <2c4fcf45524162a34d87fdda1eb046b2a5cecee7.1399317206.git.luto@amacapital.net>
 <tip-6f121e548f83674ab4920a4e60afb58d4f61b829@git.kernel.org> <CAP=VYLrzMP23B9NVnu4N3NYsoU+ai1K9HpAE_eXQzXESUUZ-Lg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 29 May 2014 12:32:26 -0700
Message-ID: <CALCETrWuHGnekoYZKJ6DAGtE8fQRMiPz590VQGctunvgee+uuA@mail.gmail.com>
Subject: Re: [tip:x86/vdso] x86, vdso: Reimplement vdso.so preparation in
 build-time C
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-tip-commits@vger.kernel.org,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 12:17 PM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> On Mon, May 5, 2014 at 6:25 PM, tip-bot for Andy Lutomirski
> <tipbot@zytor.com> wrote:
>> Commit-ID:  6f121e548f83674ab4920a4e60afb58d4f61b829
>> Gitweb:     http://git.kernel.org/tip/6f121e548f83674ab4920a4e60afb58d4f61b829
>> Author:     Andy Lutomirski <luto@amacapital.net>
>> AuthorDate: Mon, 5 May 2014 12:19:34 -0700
>> Committer:  H. Peter Anvin <hpa@linux.intel.com>
>> CommitDate: Mon, 5 May 2014 13:18:51 -0700
>>
>> x86, vdso: Reimplement vdso.so preparation in build-time C
>
> Just a heads up in case it hasn't been mentioned already;
> the x86 builds in linux-next which IIRC are done as cross
> compile on a powerpc box are failing as follows:
>
>   VDSO2C  arch/x86/vdso/vdso-image-64.c
> /bin/sh: line 1: 15995 Segmentation fault      arch/x86/vdso/vdso2c
> arch/x86/vdso/vdso64.so.dbg arch/x86/vdso/vdso-image-64.c
> make[3]: *** [arch/x86/vdso/vdso-image-64.c] Error 139
>
> http://kisskb.ellerman.id.au/kisskb/buildresult/11265454/
>

Egads.  This wouldn't be a big-endian host by any chance?

--Andy

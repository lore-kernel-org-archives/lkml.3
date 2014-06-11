Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617AbaFKRdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:33:13 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:42446 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932987AbaFKRdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:33:11 -0400
MIME-Version: 1.0
In-Reply-To: <53989190.9010806@zytor.com>
References: <5398749B.4090209@zytor.com>
	<cover.1402503408.git.luto@amacapital.net>
	<fe51e9f5c338d33b1a8b20813441538df5e17add.1402503408.git.luto@amacapital.net>
	<CA+5PVA5uPj0JiTLXJAtBt9b9e6aEcJh7ApFRbaCAP0=se89GKA@mail.gmail.com>
	<53989190.9010806@zytor.com>
Date: Wed, 11 Jun 2014 13:33:11 -0400
X-Google-Sender-Auth: vfdfQHjPNCjhWYmV8Ypjm7bEBLY
Message-ID: <CA+5PVA7_B20q6mzq9yrbcQZEw0Z785pOCFeuTjKo7_9tn4_EsA@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86,vdso: Fix vdso_install
From: Josh Boyer <jwboyer@fedoraproject.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 1:27 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/11/2014 10:23 AM, Josh Boyer wrote:
>>
>> So this does fix the invocation of 'make vdso_install' and the
>> resulting files look to be accurate to me, with the glaring exception
>> that now we get e.g. vdso64.so on x86_64 as the installed file instead
>> of vdso.so.  How much that actually matters, I have no idea.
>> Plausibly fixed with a symlink if we really need to perhaps.
>>
>
> You have that problem anyway, no?  After all, there are three different
> vdso images for 32 bits, and you can run 32-bit apps on 64-bit systems, too.

Yeah, true.

> Is there realistically any way for the debugger to pick up the correct one?

Probably not.  I'm planning on pushing out our first 3.16 build with
these two patches with no symlink.  I very much doubt anyone is going
to complain.  It was just something I noticed.

josh

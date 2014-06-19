Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966510AbaFTAAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 20:00:17 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:43428 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965771AbaFTAAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 20:00:15 -0400
MIME-Version: 1.0
In-Reply-To: <53A36831.8090901@zytor.com>
References: <cover.1403129369.git.luto@amacapital.net> <26fa44a597716445c134d21194170c292d46a421.1403129369.git.luto@amacapital.net>
 <53A36831.8090901@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 19 Jun 2014 16:59:53 -0700
Message-ID: <CALCETrVfo0YMosPLANDyfDcBdHWNCuMhYJu666LXLHDYrkD=cg@mail.gmail.com>
Subject: Re: [PATCH 5/5] x86,vdso: Create .build-id links for unstripped vdso files
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 3:46 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/18/2014 03:59 PM, Andy Lutomirski wrote:
>>
>> This may break make vdso_install with binutils before 2.17.50.0.17.
>> On the other hand, make vdso_install was probably never useful with
>> earlier binutils, since the installed files are AFAIK completely
>> useless without build-id.
>>
>
> How does it fail?

If --build-id=none on modern binutils accurately replicates old
binutils, it fails by silently creating a broken symlink called
.debug.  If you want this patch for 3.16, I can send a better version
that just doesn't create the links on old binutils.

>
>         -hpa
>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC

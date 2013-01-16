Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095Ab3APSU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 13:20:56 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:47427 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab3APSUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 13:20:55 -0500
MIME-Version: 1.0
In-Reply-To: <50F6E582.60905@zytor.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1301151214480.4978@kaball.uk.xensource.com>
	<CAE9FiQV1uxeHDVMcgNij7qAta+r2A52Jqwzb32Y1qgM13jUOeQ@mail.gmail.com>
	<CAE9FiQVhk4jc5WaOC5b+dn6Jo1w7s01MUBL16P43tNxav4kJzA@mail.gmail.com>
	<alpine.DEB.2.02.1301161048120.4978@kaball.uk.xensource.com>
	<CAE9FiQUYi_Bp2DW-G3Ht=Xz1rk+xks+NZe+-nAmvh4xR4dxVwA@mail.gmail.com>
	<50F6E582.60905@zytor.com>
Date: Wed, 16 Jan 2013 10:20:53 -0800
X-Google-Sender-Auth: mOyVRqKO46c_auj-AUSHAbRflCc
Message-ID: <CAE9FiQUGMTLDyTZTsaHFaVc0VF7JoNPkPAWQGXq3OUdn9jir6Q@mail.gmail.com>
Subject: Re: [PATCH v7u1 00/31] x86, boot, 64bit: Add support for loading
 ramdisk and bzImage above 4G
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 9:38 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 01/16/2013 09:31 AM, Yinghai Lu wrote:
>>
>>
>
> The first sentence here doesn't parse, and this description doesn't give any
> hint to anyone who is researching this code in say, five years, what
> problems this caused.
>
> I can't really figure it out, either; from looking at the thread and the
> patch I'm assuming the problem is somehow that the code failed to use the
> last page in the brk buffer, which somehow lead to a Xen boot failure... but
> the bits from here to there are totally unclear.

ok, let me try again.
tip:x86/mm2 does not fail on xen testing from Stefano and Konrad.

Stefano found booting failure with PV xen with for-x86-boot.

for-x86-boot has one patch that is trying to get back an wasted page
in pre-allocated BRK
and that cause xen pv fails with 2G setup.
that patch just uncover one bug in x86/mm2.

So questions:
1. do we need to rebase x86/mm2 to fold the two patches in. ?
2. or just put fixes at beginning for-x86-boot ?

Thanks

Yinghai

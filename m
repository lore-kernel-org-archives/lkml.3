Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569Ab3ETRVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 13:21:12 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:60354 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455Ab3ETRVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 13:21:10 -0400
MIME-Version: 1.0
In-Reply-To: <20130520164335.GA9441@dhcp22.suse.cz>
References: <20130514160108.GA5055@dhcp22.suse.cz>
	<1369062192-7066-1-git-send-email-mhocko@suse.cz>
	<519A483F.7070400@zytor.com>
	<20130520164335.GA9441@dhcp22.suse.cz>
Date: Mon, 20 May 2013 10:21:09 -0700
X-Google-Sender-Auth: 5OxpJ-Gcsx0BqIKv8SfOPCN3p0k
Message-ID: <CA+55aFzxdGOW=7-x+41U4SZB5par7jKU9vuuhFdsQfZOuLiLtw@mail.gmail.com>
Subject: Re: [PATCH] Revert "x86-64, init: Do not set NX bits on non-NX
 capable hardware"
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        =?UTF-8?Q?Fernando_Luis_V=C3=A1zquez_Cao?= <fernando@oss.ntt.co.jp>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 9:43 AM, Michal Hocko <mhocko@suse.cz> wrote:
>
> The configuration has been posted in the referenced thread:
> https://lkml.org/lkml/2013/5/14/398

Hmm. That's a regular intel i5 Sandybridge CPU. Which certainly has NX.

Hmm. secondary_startup_64 isn't __initcode, is it? I think it's used
for resuming the other CPU's too and for CPU hotplug. Yes/no?

If so early_pmd_flags shouldn't be __initdata, I think.

Michal, does it work if you don't do the revert, but just remove the
__initdata instead?

              Linus

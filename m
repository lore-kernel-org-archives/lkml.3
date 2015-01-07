Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971AbbAGVQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 16:16:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55112 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbbAGVQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 16:16:14 -0500
Message-ID: <54ADA21B.8010406@suse.cz>
Date: Wed, 07 Jan 2015 22:16:11 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: David Drysdale <drysdale@google.com>, torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, nab@linux-iscsi.org,
        linux-kernel@vger.kernel.org, jkosina@suse.cz
Subject: Re: Linux 3.19-rc1 - merge window closed
References: <CAHse=S-CGRrXPZXooHsnqO6BJytBKE4t=V_ESHL1m6Gjzeg9GQ@mail.gmail.com> <5498A6E8.8000600@lurklurk.org>
In-Reply-To: <5498A6E8.8000600@lurklurk.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 23.12.2014 v 00:19 David Drysdale napsal(a):
> On 22 Dec 2014 18:02, "Linus Torvalds" <torvalds@linux-foundation.org>
> wrote:
> When this occurred previously, I also failed to reproduce it.  However,
> it appeared (https://lkml.org/lkml/2014/11/25/542) to specifically
> involve a stale copy of arch/x86/include/generated/asm/unistd_32.h.

Thanks for this lead. I can reproduce this when I build v3.6 (before
UAPI) and afterward build the current tree without doing make clean. The
easiest solution would be to change the order of the include
directories, so that the newer uapi directories come first. I'll send a
patch tomorrow.

Michal

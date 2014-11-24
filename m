Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751201AbaKXXq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 18:46:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbaKXXq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 18:46:56 -0500
Message-ID: <5473C362.80308@redhat.com>
Date: Mon, 24 Nov 2014 15:46:42 -0800
From: Josh Stone <jistone@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
CC: "Frank Ch. Eigler" <fche@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        =?UTF-8?B?TWljaGVsIETDpG56?= =?UTF-8?B?ZXI=?= 
	<michel@daenzer.net>
Subject: Re: [PATCH RESEND] Kbuild: Add an option to enable GCC VTA
References: <1416595200-22359-1-git-send-email-jistone@redhat.com> <5473A74F.8000709@suse.cz>
In-Reply-To: <5473A74F.8000709@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2014 01:46 PM, Michal Marek wrote:
> Dne 21.11.2014 v 19:40 Josh Stone napsal(a):
>> Due to recent codegen issues, gcc -fvar-tracking-assignments was
>> unconditionally disabled in commit 2062afb4f804a ("Fix gcc-4.9.0
>> miscompilation of load_balance() in scheduler").  However, this reduces
> [...]
>> With gcc-4.9.2-1.fc22, I can now build v3.18-rc5 with Fedora's i686 and
>> x86_64 configs, and this is completely clean with GCC_COMPARE_DEBUG.
> 
> According to gcc's bug#61801, this is really fixed in 4.9.2 (commit
> 556537c4 in the git mirror). So how about checking for this minimal
> version instead of a new Kconfig option?

That's possible, if the new Kconfig option is really undesirable.  But
given that there's a similar DWARF4 option, which this pairs well with,
I thought a VTA option was a good choice.

Besides 4.9.2 though, this particular fix has also been backported to
4.8.4, and who knows what various distro maintainers may do.

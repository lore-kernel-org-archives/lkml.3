Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaFORGA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 13:06:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40737 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbaFORF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 13:05:59 -0400
Message-ID: <539DD26B.3060709@zytor.com>
Date: Sun, 15 Jun 2014 10:05:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rich Felker <dalias@libc.org>, Mikael Pettersson <mikpelinux@gmail.com>
CC: Andy Lutomirski <luto@amacapital.net>, Russ Cox <rsc@golang.org>,
        linux-api@vger.kernel.org, Ian Taylor <iant@golang.org>,
        linux-kernel@vger.kernel.org, X86 ML <x86@kernel.org>
Subject: Re: [RFC 0/2] __vdso_findsym
References: <cover.1402769596.git.luto@amacapital.net> <21405.44257.742122.786960@gargle.gargle.HOWL> <20140615143500.GP179@brightrain.aerifal.cx>
In-Reply-To: <20140615143500.GP179@brightrain.aerifal.cx>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2014 07:35 AM, Rich Felker wrote:
> 
> Arguably, it was a mistake for the kernel to expose a virtual ELF to
> begin with, and it should just have exposed a "lookup function by
> name" operation to begin with. Yes this can be done in userspace, but
> I see it more as a matter of "fixing a broken API design".
> 

What the fsck are you smoking?  There is immense value in providing a
stable and very well-defined data structure, which also happens to be
what dynamic linkers already want to consume.  Providing a helper for
crippled libc applications has potential value.  Shaving a few hundred
bytes off static applications is a very weak argument, simply because it
is such a small fraction of the enormous cost of a static application,
and static applications are problematic in a number of other ways,
especially the lack of ability to fix bugs.

Treating the kernel as an ersatz dynamic library for "static"
applications is kind of silly -- after all, why not provide an entire
libc in the vdso?  I have actually seen people advocate for doing that.

	-hpa



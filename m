Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbaGVG6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 02:58:04 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:33970 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbaGVG6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 02:58:03 -0400
Date: Tue, 22 Jul 2014 08:57:43 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: Andy Lutomirski <luto@amacapital.net>
cc: "H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
        X86 ML <x86@kernel.org>, Eric Paris <eparis@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Borislav Petkov <bp@alien8.de>,
        =?ISO-8859-15?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
        stable <stable@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
        Josh Boyer <jwboyer@fedoraproject.org>
Subject: Re: [PATCH] x86_32, entry: store badsys error code in %eax
In-Reply-To: <CALCETrU8xTGpOWONMnByAQo5TAqzutguw+L5_QW8K_iDe0EyeQ@mail.gmail.com>
Message-ID: <alpine.LNX.2.11.1407220739250.31021@titan.int.lan.stealer.net>
References: <alpine.LNX.2.11.1407202330420.31021@titan.int.lan.stealer.net> <CALCETrU8xTGpOWONMnByAQo5TAqzutguw+L5_QW8K_iDe0EyeQ@mail.gmail.com>
User-Agent: Alpine 2.11 (LNX 23 2013-08-11)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -0.1
X-Spam-Bar: /
X-Spam-Report: Scanned by SpamAssassin 3.3.2 2011-06-06 on smtp1.stealer.net at Tue, 22 Jul 2014 06:57:53 +0000
 Bayes: 0.0002 Tokens: new, 200; hammy, 7; neutral, 5; spammy, 0.
 AutoLearn: no
 * -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
 *      [score: 0.0002]
 *  1.0 URIBL_RHSMAILPOLICE Contains a URL listed in the
 *      block.rhs.mailpolice.com blocklist
 *      [URIs: stealer.net]
 *  0.8 RDNS_NONE Delivered to internal network by a host with no rDNS
X-Spam-Signature: 7c1d77b5ef2bc000a59060f3ef45198d38d668bd
X-DomainKey-Status: none
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2014, Andy Lutomirski wrote:

> On Sun, Jul 20, 2014 at 2:33 PM, Sven Wegener <sven.wegener@stealer.net> wrote:
> > Commit 554086d ("x86_32, entry: Do syscall exit work on badsys
> > (CVE-2014-4508)") introduced a subtle regression in the x86_32 syscall
> > entry code, resulting in syscall() not returning proper errors for
> > non-existing syscalls on CPUs not supporting the sysenter feature.
> 
> s/not supporting/supporting/

Looks like I mixed the sep vs. syscall CPU flag. Initially I encountered 
the issue on real hardware (Celeron) having the sep but not the syscall 
flag. During testing it worked on an emulated CPU missing the sep and 
having the syscall flag and broke on an emulated CPU having the sep and 
missing the syscall flag. I only looked at the syscall flag, which is 
completly invariant for this issue, and assumed it stands for sysenter 
support, completly ignoring the sep flag.

Sven

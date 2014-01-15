Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaAOOM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 09:12:27 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:59469 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751970AbaAOOMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 09:12:21 -0500
Message-ID: <1389795138.17407.13.camel@x220>
Subject: Re: [PATCH] kexec.h: stop exporting kexec_load() to userspace
From: Paul Bolle <pebolle@tiscali.nl>
To: Maximilian Attems <max@stro.at>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Eric Biederman <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 15 Jan 2014 15:12:18 +0100
In-Reply-To: <20140115133838.GD8101@stro.at>
References: <1389791824.17407.9.camel@x220> <20140115133838.GD8101@stro.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jan 2014 14:12:19.0190 (UTC) FILETIME=[CD106160:01CF11FB]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-15 at 14:38 +0100, Maximilian Attems wrote:
> On Wed, Jan 15, 2014 at 02:17:04PM +0100, Paul Bolle wrote:
> > Since v3.5 kexec.h is exported to userspace. That includes its
> > declaration of kexec_load():
> >     extern int kexec_load(void *, size_t, struct kexec_segment *,
> >                    unsigned long int);
> > 
> > This declaration isn't very useful to userspace programs on itself. They
> > still have to define a matching function (which basically wraps the
> > kexec_load syscall). I'm not aware of programs or libraries that actually
> > do that.
> > 
> > It can be removed. The programs that actually use it, if there
> > are any, should then provide their own declaration to keep compiling.
> > Already compiled binaries will not be affected.
> 
> nack, klibc uses the header and there was some discussion that glibc
> could/should use it too.

The versions of klibc I stumbled on (via codesearch.debian.net) didn't
use a kexec_load() that match that declaration. Has that changed? In
which version?

>  I didn't follow kexec git, but there is/was
> a version that just uses the kexec_load() if the c library provides it.
> Until Santa Claus materialises in form of a direct kernel user-space API,
> see follow ups on http://lwn.net/Articles/534682/ and proposal by hpa
>  
> > This gets rid of the headers_check warning that can be seen ever since
> > this header was exported:
> >     [...]/usr/include/linux/kexec.h:49: userspace cannot reference function or variable defined in the kernel
> > 
> 
> this is the wrong  way of fix.


Paul Bolle


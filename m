Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbaBLB7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 20:59:43 -0500
Received: from mail.windriver.com ([147.11.1.11]:53183 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaBLB7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 20:59:42 -0500
Date: Tue, 11 Feb 2014 21:00:10 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: David Rientjes <rientjes@google.com>
CC: <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        <x86@kernel.org>
Subject: Re: [PATCH] x86: fix two sparse warnings in early boot string
 handling
Message-ID: <20140212020010.GB21033@windriver.com>
References: <1392143619-11453-1-git-send-email-paul.gortmaker@windriver.com>
 <alpine.DEB.2.02.1402111425430.32020@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402111425430.32020@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [PATCH] x86: fix two sparse warnings in early boot string handling] On 11/02/2014 (Tue 14:26) David Rientjes wrote:

> On Tue, 11 Feb 2014, Paul Gortmaker wrote:
> 
> > Fixes:
> > 
> > arch/x86/boot/compressed/../string.c:60:14: warning: symbol 'atou' was not declared. Should it be static?
> > arch/x86/boot/string.c:133:6: warning: symbol 'strstr' was not declared. Should it be static?
> > 
> > The atou one could be considered a false positive; it seems somehow
> > caused by including ./string.c from within /compressed/string.c file.
> > However git grep shows only the atou prototype and declaration, so
> > it is completely unused and we can hence delete it.
> > 
> 
> Declaring a prototype in a header file would be pointless if there is no 
> current breakage; I don't see why you can't remove strstr() in 
> arch/x86/boot/string.c entirely.  What breaks?

Explicit breakage vs. sparse warnings are two different things.  It may
be that we can delete strstr() just like I did for atou() -- but in the
interest of doing the minimal change, I did just what was needed for
fixing the sparse warnings for strstr.  I can test if it can be removed,
but it has the smell of generic-libc usage all over it...

Paul.
--
`

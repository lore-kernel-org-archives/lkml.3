Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751071AbaERKBx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 06:01:53 -0400
Received: from mout.gmx.net ([212.227.15.18]:55969 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbaERKBv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 06:01:51 -0400
Message-ID: <1400407278.4698.5.camel@schoellingm.dzne.de>
Subject: Re: [PATCH] fs: Cleanup string initializations (char[] instead of
 char *)
From: Manuel Schoelling <manuel.schoelling@gmx.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anton Altaparmakov <anton@tuxera.com>
Date: Sun, 18 May 2014 12:01:18 +0200
In-Reply-To: <20140517165345.GG18016@ZenIV.linux.org.uk>
References: <1400338818-2853-1-git-send-email-manuel.schoelling@gmx.de>
	 <20140517165345.GG18016@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K0:3noA7RJmpA8jYRuVB1X51q7O7ux+ay05xspMlNBAFeWLVzmPv81
 kmmKnFYO2AWUgY1SmZ33rPrelNn/WxDM4j5UuF2/CmiSNR/sj36jO/KTJu9ttloXhpApE83
 xuQTopsocbmk8bCtFnYs+GjXl2H0kDazH2L21a+0IppZUxiiTV3UOl3XSC4DvTEut4yUQT9
 z1RSIoyGTac8alrYCnQIA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the detailed review of my patches, guys!

I had a look at the assembler code now, too and you are right about
this.
I was misguided by the KernelJanitor's TODO list [1]. If there is
consensus the corresponding paragraph from that list should be removed.

[1] http://kernelnewbies.org/KernelJanitors/Todo

On Sa, 2014-05-17 at 17:53 +0100, Al Viro wrote:
> On Sat, May 17, 2014 at 05:00:18PM +0200, Manuel Schölling wrote:
> > Initializations like 'char *foo = "bar"' will create two variables: a static
> > string and a pointer (foo) to that static string. Instead 'char foo[] = "bar"'
> > will declare a single variable and will end up in shorter
> > assembly (according to Jeff Garzik on the KernelJanitor's TODO list).
> 
> The hell it will.  Compare assembler generated e.g. for 32bit x86 before
> and after.
> 
> >  {
> >  	char *dp;
> >  	char *status = "disabled";
> > -	const char * flags = "flags: ";
> > +	const char flags[] = "flags: ";
> 
> The first variant puts address of constant array into local variable
> (on stack or in a register).  The second one fills local _array_ - the
> string itself goes on stack.



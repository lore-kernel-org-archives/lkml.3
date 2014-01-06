Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbaAFVmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 16:42:42 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:61119 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbaAFVmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 16:42:40 -0500
X-Nat-Received: from [202.181.97.72]:59933 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1389044509.30194
To: joe@perches.com
Cc: keescook@chromium.org, pavel@ucw.cz, akpm@linux-foundation.org,
        geert@linux-m68k.org, jkosina@suse.cz, viro@zeniv.linux.org.uk,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201401041126.BHJ81291.VOHLOtMFOJFQFS@I-love.SAKURA.ne.jp>
	<201401051215.ACJ30759.MJSHtFFFVOOOQL@I-love.SAKURA.ne.jp>
	<1388945392.5808.19.camel@joe-AO722>
	<201401062300.GFE12908.FOQLFFJOSOMVHt@I-love.SAKURA.ne.jp>
	<1389029698.2433.3.camel@joe-AO722>
In-Reply-To: <1389029698.2433.3.camel@joe-AO722>
Message-Id: <201401070641.HAC18733.VOFMFOLOJQSFHt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 7 Jan 2014 06:41:44 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 06012014 #7267303, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Mon, 2014-01-06 at 23:00 +0900, Tetsuo Handa wrote:
> > Joe Perches wrote:
> > > Is this really necessary?
> > No problem. %pT[012] are simply optimization (reducing number of function
> > arguments for saving text size) and therefore I can drop them.
> > What about below patch?
> 
> Hi Tetsuo.  Just a nit.
> 
> > diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> []
> > @@ -1232,7 +1248,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
> >  {
> >  	int default_width = 2 * sizeof(void *) + (spec.flags & SPECIAL ? 2 : 0);
> >  
> > -	if (!ptr && *fmt != 'K') {
> > +	if (!ptr && *fmt != 'K' && *fmt != 'T') {
> 
> I think this new 'T' comparison isn't necessary.

This is needed for allowing comm_name() to accept NULL instead of current.

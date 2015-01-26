Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbbAZPD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 10:03:27 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:42367 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbbAZPDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 10:03:24 -0500
Date: Mon, 26 Jan 2015 16:03:19 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <maasami.hiramatsu.pt@hitachi.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>,
        Andreas Krebbel <krebbel@linux.vnet.ibm.com>,
        Dominik Vogt <vogt@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 2/3] ftrace: introduce nohotpatch function attribute
Message-ID: <20150126150319.GF4968@osiris>
References: <1422276894-31302-1-git-send-email-heiko.carstens@de.ibm.com>
 <1422276894-31302-3-git-send-email-heiko.carstens@de.ibm.com>
 <20150126093701.699763dc@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150126093701.699763dc@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012615-0013-0000-0000-000002BFB41C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 09:37:01AM -0500, Steven Rostedt wrote:
> On Mon, 26 Jan 2015 13:54:53 +0100
> Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> 
> > gcc supports an s390 specific function attribute called "hotpatch".
> > It can be used to specify the number of halfwords that shall be added before
> > and after a function that shall be filled with nops for runtime patching.
> > 
> > s390 will use the hotpatch attribute for function tracing, therefore
> > introduce a nohotpatch define, depending on CC_USING_HOTPATCH, and add it
> > to the existing notrace define.
> 
> Are the two mutually exclusive? That is, can you have -pg and hotpatch
> together? Reason why I ask is, if you have either -pg or hotpatch, then
> we only need "no_instrument_function" or "hotpatch" in the notrace
> define, not both. But I could be wrong.

Actually they should be mutually exclusive. I just merged them "just in case".

So something like this

#ifdef CC_USING_HOTPATCH
#define notrace __attribute__((hotpatch(0,0)))
#else
#define notrace __attribute__((no_instrument_function))
#endif

will work as well (just tested).


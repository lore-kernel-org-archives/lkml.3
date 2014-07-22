Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbaGVGOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 02:14:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:59455 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbaGVGOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 02:14:19 -0400
Message-ID: <1406009637.22200.14.camel@pasglop>
Subject: Re: [PATCH] powerpc: Revert removing of _INIT_GLOBAL(), _STATIC()
 and _INIT_STATIC()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org,
        Anton Blanchard <anton@samba.org>, Olof Johansson <olof@lixom.net>
Date: Tue, 22 Jul 2014 16:13:57 +1000
In-Reply-To: <20140721145651.465db070@gandalf.local.home>
References: <20140714201204.7b6fcd8e@gandalf.local.home>
	 <1405389955.9343.48.camel@pasglop>
	 <20140721145651.465db070@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-21 at 14:56 -0400, Steven Rostedt wrote:
> > Weird ... what are your gcc and binutils versions ? Smells like a
> > toolchain issue to me but I need to dig a bit more. Doesn't hit any
> > of my test configs here.
> > 
> 
> Can you test the attached config with this toolchain and see if you get
> the same build bug.

Yeah ok, I hit it too, it's one of those issues with the bloody
alternate feature sections getting pushed too far away. Argh.

I'm trying to fix that trainwreck (similar issues also breaks our
allmodconfig), we have a whole mess of problems caused by our
hand crafted assembly growing beyond the reach of conditional
branches with the right set of options.

I'll see what I can do...

> https://www.kernel.org/pub/tools/crosstool/files/bin/x86_64/4.6.3/x86_64-gcc-4.6.3-nolibc_powerpc64-linux.tar.bz2



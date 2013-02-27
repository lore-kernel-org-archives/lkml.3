Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158Ab3B0BWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:22:12 -0500
Received: from ozlabs.org ([203.10.76.45]:38647 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759879Ab3B0BWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 20:22:09 -0500
Date: Wed, 27 Feb 2013 12:22:07 +1100
From: Michael Ellerman <michael@ellerman.id.au>
To: li guang <lig.fnst@cn.fujitsu.com>
Cc: Namhyung Kim <namhyung@kernel.org>, acme@infradead.org,
        linux-kernel@vger.kernel.org, feng.tang@intel.com,
        namhyung.kim@lge.com
Subject: Re: [PATCH 1/2] perf annotate: Fix build with NO_NEWT=1
Message-ID: <20130227012207.GC5819@concordia>
References: <1361854923-1814-1-git-send-email-michael@ellerman.id.au>
 <87y5ebsb0s.fsf@sejong.aot.lge.com>
 <1361927668.2262.36.camel@liguang.fnst.cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1361927668.2262.36.camel@liguang.fnst.cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 09:14:28AM +0800, li guang wrote:
> 在 2013-02-26二的 18:02 +0900，Namhyung Kim写道：
> > Hi Michael,
> > 
> > On Tue, 26 Feb 2013 16:02:02 +1100, Michael Ellerman wrote:
> > > Commit 18c9e5c "Make it to be able to skip unannotatable symbols" broke
> > > the build with NO_NEWT=1:
> > >
> > >    CC builtin-annotate.o
> > > builtin-annotate.c: In function 'hists__find_annotations':
> > > builtin-annotate.c:161:4: error: duplicate case value
> > > builtin-annotate.c:154:4: error: previously used here
> > > make: *** [builtin-annotate.o] Error 1
> > >
> > > This is because without NEWT support K_LEFT is #defined to -1 in
> > > utils/hist.h
> > >
> > > Fix it by shifting the K_LEFT/K_RIGHT #defines out of the likely range
> > > of error values.
> > 
> > Argh, didn't check NO_NEWT build on this, sorry.
> > 
> > The hist_entry__tui_annotate() - hence, symbol__tui_annotate() - returns
> > either key code or error code.  This is not good IMHO but not sure it's
> > worth refactoring.  Maybe we can move the error check to under default
> > case so that possible future error checks to be done?
> 
> or can we skip gui-code-snippet when there's no gui library?
> anyway, for present fix-up, we can just temporarily change K_LEFT value
> like Michael's or my patch, I think.

Sorry I didn't see your patch, but yes I agree, either is fine and fixes
the build for now.

cheers

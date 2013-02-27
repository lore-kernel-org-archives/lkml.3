Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367Ab3B0BaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:30:09 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:41241 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755486Ab3B0BaG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 20:30:06 -0500
X-IronPort-AV: E=Sophos;i="4.84,744,1355068800"; 
   d="scan'208";a="6774853"
Subject: Re: [PATCH 1/2] perf annotate: Fix build with NO_NEWT=1
From: li guang <lig.fnst@cn.fujitsu.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Namhyung Kim <namhyung@kernel.org>, acme@infradead.org,
        linux-kernel@vger.kernel.org, feng.tang@intel.com,
        namhyung.kim@lge.com
In-Reply-To: <20130227012207.GC5819@concordia>
References: <1361854923-1814-1-git-send-email-michael@ellerman.id.au>
	 <87y5ebsb0s.fsf@sejong.aot.lge.com>
	 <1361927668.2262.36.camel@liguang.fnst.cn.fujitsu.com>
	 <20130227012207.GC5819@concordia>
Date: Wed, 27 Feb 2013 09:29:52 +0800
Message-ID: <1361928592.2262.38.camel@liguang.fnst.cn.fujitsu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/27 09:29:11,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/27 09:29:11,
	Serialize complete at 2013/02/27 09:29:11
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2013-02-27三的 12:22 +1100，Michael Ellerman写道：
> On Wed, Feb 27, 2013 at 09:14:28AM +0800, li guang wrote:
> > 在 2013-02-26二的 18:02 +0900，Namhyung Kim写道：
> > > Hi Michael,
> > > 
> > > On Tue, 26 Feb 2013 16:02:02 +1100, Michael Ellerman wrote:
> > > > Commit 18c9e5c "Make it to be able to skip unannotatable symbols" broke
> > > > the build with NO_NEWT=1:
> > > >
> > > >    CC builtin-annotate.o
> > > > builtin-annotate.c: In function 'hists__find_annotations':
> > > > builtin-annotate.c:161:4: error: duplicate case value
> > > > builtin-annotate.c:154:4: error: previously used here
> > > > make: *** [builtin-annotate.o] Error 1
> > > >
> > > > This is because without NEWT support K_LEFT is #defined to -1 in
> > > > utils/hist.h
> > > >
> > > > Fix it by shifting the K_LEFT/K_RIGHT #defines out of the likely range
> > > > of error values.
> > > 
> > > Argh, didn't check NO_NEWT build on this, sorry.
> > > 
> > > The hist_entry__tui_annotate() - hence, symbol__tui_annotate() - returns
> > > either key code or error code.  This is not good IMHO but not sure it's
> > > worth refactoring.  Maybe we can move the error check to under default
> > > case so that possible future error checks to be done?
> > 
> > or can we skip gui-code-snippet when there's no gui library?
> > anyway, for present fix-up, we can just temporarily change K_LEFT value
> > like Michael's or my patch, I think.
> 
> Sorry I didn't see your patch, but yes I agree, either is fine and fixes
> the build for now.
> 
> cheers

https://lkml.org/lkml/2013/2/25/486


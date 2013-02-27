Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760005Ab3B0NDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 08:03:20 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:47021 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab3B0NDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 08:03:18 -0500
Date: Wed, 27 Feb 2013 14:03:16 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [perf patch] perf doesn't delete /tmp/perf-vdso.so.* file on exit
Message-ID: <20130227130316.GB225@x4>
References: <20130221094544.GA2919@x4>
 <20130221102748.GB2919@x4>
 <loom.20130221T191341-303@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <loom.20130221T191341-303@post.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013.02.21 at 18:19 +0000, Namhyung Kim wrote:
> Markus Trippelsdorf <markus <at> trippelsdorf.de> writes:
> > 
> > perf top doesn't unlink /tmp/perf-vdso.so.* on exit.
> > Fix this by calling vdso__exit() before exit(0).
> 
> > @@ -602,6 +603,7 @@ static void *display_thread_tui(void *arg)
> >  				      &top->session->header.env);
> > 
> >  	exit_browser(0);
> > +	vdso__exit();
> >  	exit(0);
> >  	return NULL;
> >  }
> 
> I don't think it's enough - it doesn't cover all exit paths.
> I'd suggest making it to use atexit/on_exit().

The issue is fixed by commit 11859e821761.

-- 
Markus

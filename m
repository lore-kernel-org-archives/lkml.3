Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab3A1IcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 03:32:06 -0500
Received: from re04.intra2net.com ([82.165.46.26]:39694 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251Ab3A1IcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 03:32:02 -0500
From: Thomas Jarosch <thomas.jarosch@intra2net.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [perf PATCH 3/3] Fix double fclose() on do_write(fd, xxx) failure
Date: Mon, 28 Jan 2013 09:31:58 +0100
Message-ID: <2218467.S7Jon2S4Bp@storm>
Organization: Intra2net AG
User-Agent: KMail/4.9.5 (Linux/3.6.11-5.fc17.x86_64; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130125160151.GA31242@ghostprotocols.net>
References: <2684910.12iLzy42t4@storm> <20130125160151.GA31242@ghostprotocols.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 25. January 2013 13:01:51 you wrote:
> Em Fri, Jan 25, 2013 at 11:22:17AM +0100, Thomas Jarosch escreveu:
> > cppcheck reported:
> > [util/header.c:983]: (error) Used file that is not opened.
> > 
> > Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
> > ---
> > 
> >  tools/perf/util/header.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> > index 7b24cf3..30745c2 100644
> > --- a/tools/perf/util/header.c
> > +++ b/tools/perf/util/header.c
> > @@ -955,6 +955,7 @@ static int write_topo_node(int fd, int node)
> > 
> >  	}
> >  	
> >  	fclose(fp);
> > 
> > +	fp = NULL;
> 
> Ok, but what is the behaviour of fclose(NULL)? Is it defined?
> 
> - Arnaldo

Grrr, this is undefined behavior. Sorry. I always thought this
is defined like free(NULL) but apparently it is not.

I'll send another version of the patch and also write to the
man page maintainer to add a small hint to the fclose() man page.

Thomas


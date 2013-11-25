Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab3KYJeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 04:34:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701Ab3KYJeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 04:34:20 -0500
Date: Mon, 25 Nov 2013 10:33:59 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 03/22] tools lib traceevent: Add
 traceevent_host_bigendian function
Message-ID: <20131125093359.GB3161@krava.brq.redhat.com>
References: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
 <1385031680-9014-4-git-send-email-jolsa@redhat.com>
 <1385130172.1747.28.camel@leonhard>
 <20131123032708.02a47303@gandalf.local.home>
 <87ob59rliz.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ob59rliz.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 04:24:52PM +0900, Namhyung Kim wrote:
> Hi Steve,
> 
> On Sat, 23 Nov 2013 03:27:08 -0500, Steven Rostedt wrote:
> > On Fri, 22 Nov 2013 23:22:52 +0900
> > Namhyung Kim <namhyung@kernel.org> wrote:
> >
> >> 2013-11-21 (목), 12:01 +0100, Jiri Olsa:
> >> > Adding traceevent_host_bigendian function to get host
> >> > endianity. It's used in following patches.
> >> 
> >> [SNIP]
> >> > +static inline int traceevent_host_bigendian(void)
> >> > +{
> >> > +	unsigned char str[] = { 0x1, 0x2, 0x3, 0x4 };
> >> > +	unsigned int *ptr;
> >> > +
> >> > +	ptr = (unsigned int *)str;
> >> > +	return *ptr == 0x01020304;
> >> 
> >> Is it safe for every architecture supported - especially ones that
> >> require stricter alignment?  I know many architectures/compilers align
> >> stack but not sure doing this is safe for all architecture.
> >
> > Would you prefer this (I tested it on both a big and little endian)
> >
> > {
> > 	unsigned char str[] = { 0x1, 0x2, 0x3, 0x4 };
> > 	unsigned int val;
> >
> > 	memcpy(&val, str, 4);
> > 	return val == 0x01020304;
> > }
> 
> Yeah, looks good to me.

ok, will change to this one

thanks,
jirka

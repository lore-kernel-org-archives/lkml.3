Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab3KWI1N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 03:27:13 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:21047 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750997Ab3KWI1M convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 03:27:12 -0500
Date: Sat, 23 Nov 2013 03:27:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 03/22] tools lib traceevent: Add
 traceevent_host_bigendian function
Message-ID: <20131123032708.02a47303@gandalf.local.home>
In-Reply-To: <1385130172.1747.28.camel@leonhard>
References: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
	<1385031680-9014-4-git-send-email-jolsa@redhat.com>
	<1385130172.1747.28.camel@leonhard>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Nov 2013 23:22:52 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> 2013-11-21 (목), 12:01 +0100, Jiri Olsa:
> > Adding traceevent_host_bigendian function to get host
> > endianity. It's used in following patches.
> 
> [SNIP]
> > +static inline int traceevent_host_bigendian(void)
> > +{
> > +	unsigned char str[] = { 0x1, 0x2, 0x3, 0x4 };
> > +	unsigned int *ptr;
> > +
> > +	ptr = (unsigned int *)str;
> > +	return *ptr == 0x01020304;
> 
> Is it safe for every architecture supported - especially ones that
> require stricter alignment?  I know many architectures/compilers align
> stack but not sure doing this is safe for all architecture.

Would you prefer this (I tested it on both a big and little endian)

{
	unsigned char str[] = { 0x1, 0x2, 0x3, 0x4 };
	unsigned int val;

	memcpy(&val, str, 4);
	return val == 0x01020304;
}

-- Steve


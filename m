Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab3KVOXB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 09:23:01 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:47726 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab3KVOXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 09:23:00 -0500
Subject: Re: [PATCH 03/22] tools lib traceevent: Add
 traceevent_host_bigendian function
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
In-Reply-To: <1385031680-9014-4-git-send-email-jolsa@redhat.com>
References: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
	 <1385031680-9014-4-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Nov 2013 23:22:52 +0900
Message-ID: <1385130172.1747.28.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-11-21 (목), 12:01 +0100, Jiri Olsa:
> Adding traceevent_host_bigendian function to get host
> endianity. It's used in following patches.

[SNIP]
> +static inline int traceevent_host_bigendian(void)
> +{
> +	unsigned char str[] = { 0x1, 0x2, 0x3, 0x4 };
> +	unsigned int *ptr;
> +
> +	ptr = (unsigned int *)str;
> +	return *ptr == 0x01020304;

Is it safe for every architecture supported - especially ones that
require stricter alignment?  I know many architectures/compilers align
stack but not sure doing this is safe for all architecture.

Thanks,
Namhyung



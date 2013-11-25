Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab3KYHY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 02:24:57 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:63586 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab3KYHYy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 02:24:54 -0500
X-AuditID: 9c930197-b7caaae000001cef-77-5292fb440cd1
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 03/22] tools lib traceevent: Add traceevent_host_bigendian function
References: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
	<1385031680-9014-4-git-send-email-jolsa@redhat.com>
	<1385130172.1747.28.camel@leonhard>
	<20131123032708.02a47303@gandalf.local.home>
Date: Mon, 25 Nov 2013 16:24:52 +0900
In-Reply-To: <20131123032708.02a47303@gandalf.local.home> (Steven Rostedt's
	message of "Sat, 23 Nov 2013 03:27:08 -0500")
Message-ID: <87ob59rliz.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Sat, 23 Nov 2013 03:27:08 -0500, Steven Rostedt wrote:
> On Fri, 22 Nov 2013 23:22:52 +0900
> Namhyung Kim <namhyung@kernel.org> wrote:
>
>> 2013-11-21 (목), 12:01 +0100, Jiri Olsa:
>> > Adding traceevent_host_bigendian function to get host
>> > endianity. It's used in following patches.
>> 
>> [SNIP]
>> > +static inline int traceevent_host_bigendian(void)
>> > +{
>> > +	unsigned char str[] = { 0x1, 0x2, 0x3, 0x4 };
>> > +	unsigned int *ptr;
>> > +
>> > +	ptr = (unsigned int *)str;
>> > +	return *ptr == 0x01020304;
>> 
>> Is it safe for every architecture supported - especially ones that
>> require stricter alignment?  I know many architectures/compilers align
>> stack but not sure doing this is safe for all architecture.
>
> Would you prefer this (I tested it on both a big and little endian)
>
> {
> 	unsigned char str[] = { 0x1, 0x2, 0x3, 0x4 };
> 	unsigned int val;
>
> 	memcpy(&val, str, 4);
> 	return val == 0x01020304;
> }

Yeah, looks good to me.

Thanks,
Namhyung

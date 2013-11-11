Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab3KKLvC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 06:51:02 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:49744 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab3KKLux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 06:50:53 -0500
Date: Mon, 11 Nov 2013 12:50:50 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf: Fix version when building out of tree
Message-ID: <20131111115050.GB19720@gmail.com>
References: <1383699213-23981-1-git-send-email-dsahern@gmail.com>
 <20131106053654.GA23746@gmail.com>
 <527A582D.4000301@gmail.com>
 <20131107083035.GB32542@gmail.com>
 <527BA420.6000403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527BA420.6000403@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 11/7/13, 1:30 AM, Ingo Molnar wrote:
> >
> >* David Ahern <dsahern@gmail.com> wrote:
> >
> >>On 11/5/13, 10:36 PM, Ingo Molnar wrote:
> >>>I think you could avoid the 'short' complication altogether by doing
> >>>something like this:
> >>>
> >>>>+elif test -f ../../PERF-VERSION-FILE
> >>>>+then
> >>>>+	TAG=$(cut -d' ' -f3 ../../PERF-VERSION-FILE)
> >>>
> >>>That extracts 'TAG' as a true sha1 and makes GVF correct on out of tree
> >>>builds as well.
> >>
> >>Certainly. I was trying to make PERF-VERSION-FILE readable as a
> >>standalone file -- a better version descriptor than HEAD file.
> >
> >Do you mean that instead of:
> >
> >   comet:~/tip/tools/perf> cat PERF-VERSION-FILE
> >   #define PERF_VERSION "3.12.g953bfb"
> 
> no. I was thinking instead of
> cat PERF-VERSION-FILE
> #define PERF_VERSION "3.12.g953bfb"
> 
> you have
> cat PERF-VERSION-FILE
> 3.12.g953bfb
> 
> But remember this is a new PERF-VERSION-FILE at the top of tree --
> just like the HEAD file that contains the top commit id. Both are
> generated as part of the make perf-tar-src-pkg to keep track of the
> origin of the source. The new file becomes the basis of
> $(OUTPUT)PERF-VERSION-FILE.

Hm, I think this is confusing.

I think this should be a special file name, only generated into the 
tarball, one which never shows up in a regular build.

It must be possible to build perf in a read-only source repository (with 
O= pointing elsewhere) for example.

Thanks,

	Ingo

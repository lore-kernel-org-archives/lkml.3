Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab3KGIa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 03:30:59 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:41468 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab3KGIav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 03:30:51 -0500
Date: Thu, 7 Nov 2013 09:30:35 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf: Fix version when building out of tree
Message-ID: <20131107083035.GB32542@gmail.com>
References: <1383699213-23981-1-git-send-email-dsahern@gmail.com>
 <20131106053654.GA23746@gmail.com>
 <527A582D.4000301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527A582D.4000301@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 11/5/13, 10:36 PM, Ingo Molnar wrote:
> >I think you could avoid the 'short' complication altogether by doing
> >something like this:
> >
> >>+elif test -f ../../PERF-VERSION-FILE
> >>+then
> >>+	TAG=$(cut -d' ' -f3 ../../PERF-VERSION-FILE)
> >
> >That extracts 'TAG' as a true sha1 and makes GVF correct on out of tree
> >builds as well.
> 
> Certainly. I was trying to make PERF-VERSION-FILE readable as a 
> standalone file -- a better version descriptor than HEAD file.

Do you mean that instead of:

  comet:~/tip/tools/perf> cat PERF-VERSION-FILE 
  #define PERF_VERSION "3.12.g953bfb"

we should put a plain version into it? (the 'short' form you introduced 
earlier)

And then this:

  Makefile.perf:  $(QUIET_CC)$(CC) -include $(OUTPUT)PERF-VERSION-FILE \

Could be replaced with:

  Makefile.perf:  $(QUIET_CC)$(CC) -D $(shell cat $(OUTPUT)PERF-VERSION-FILE) \

or so?

Thanks,

	Ingo

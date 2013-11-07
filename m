Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab3KGDEK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 22:04:10 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:36883 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab3KGDED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 22:04:03 -0500
MIME-Version: 1.0
In-Reply-To: <1383262255.2769.11.camel@joe-AO722>
References: <51F73A17.2090208@akamai.com>
	<1382974150-7392-1-git-send-email-changbin.du@gmail.com>
	<20131031155253.79a21d6a126be11a64153d8b@linux-foundation.org>
	<1383262255.2769.11.camel@joe-AO722>
Date: Thu, 7 Nov 2013 11:04:01 +0800
Message-ID: <CABgQ-Ti=EZRf8uQAVgiUroPUY0BpN3Cocym0QTjj9WGLJbL1XA@mail.gmail.com>
Subject: Re: [PATCH v2] dynamic_debug: add wildcard support to filter files/functions/modules
From: Changbin Du <changbin.du@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jason Baron <jbaron@akamai.com>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/1 Joe Perches <joe@perches.com>:
> On Thu, 2013-10-31 at 15:52 -0700, Andrew Morton wrote:
>> On Mon, 28 Oct 2013 23:29:10 +0800 "Du, Changbin" <changbin.du@gmail.com> wrote:
> []
>> > +/* check if the string matches given pattern which includes wildcards */
>> > +static int match_pattern(const char *pattern, const char *string)
> []
>> No, something like this should be in lib/ so that other callers can use
>> it.  We already have at least one copy handy in
>> drivers/ata/libata-core.c:glob_match().  A better approach would be to
>> move that glob_match() into lib/glob_match.c then teach dynamic_debug
>> to use it.
>>
>> There are probably other private globbing functions lying around the
>> kernel, but it's rather a hard thing to grep for...
>
> Maybe use lib/parser.c where the other match_<foo> functions
> are already.

match_<foo> functions in lib/parser.c just do simple match, they
doesn't support wildcards.
So it's not useful for us.

>
> match_glob has the disadvantage that it's recursive too.
>

As you mentioned before, we cannot use it since strings are given from
userspace. :)

> trace has:
>
> kernel/trace/trace_events_filter.c:static int regex_match_full(char *str, struct regex *r, int len)
> kernel/trace/trace_events_filter.c:static int regex_match_front(char *str, struct regex *r, int len)
> kernel/trace/trace_events_filter.c:static int regex_match_middle(char *str, struct regex *r, int len)
> kernel/trace/trace_events_filter.c:static int regex_match_end(char *str, struct regex *r, int len)
>
> but there probably aren't many more that could be converted.

Trace filter support wildcards, but it seems the match algorithm
couples with trace code. I'll try to see
if it can be split.

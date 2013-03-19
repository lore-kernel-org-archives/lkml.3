Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab3CSQoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 12:44:24 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:40034 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757097Ab3CSQoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 12:44:23 -0400
MIME-Version: 1.0
Reply-To: konrad@darnok.org
In-Reply-To: <6041f181-67b1-4f71-bd5c-cfb48f1ddfb0@default>
References: <1363255697-19674-1-git-send-email-liwanp@linux.vnet.ibm.com>
	<1363255697-19674-2-git-send-email-liwanp@linux.vnet.ibm.com>
	<20130316130302.GA5987@konrad-lan.dumpdata.com>
	<6041f181-67b1-4f71-bd5c-cfb48f1ddfb0@default>
Date: Tue, 19 Mar 2013 12:44:22 -0400
X-Google-Sender-Auth: _PZ5MIBa8xXSl6N9eXZVJ-5tlRc
Message-ID: <CAPbh3rvOW2hh0bMTY_FyYJPiyqS4a76pHgDYLGYvLKjEzfJoig@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] introduce zero filled pages handler
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 2:24 PM, Dan Magenheimer
<dan.magenheimer@oracle.com> wrote:
>> From: Konrad Rzeszutek Wilk [mailto:konrad@darnok.org]
>> Subject: Re: [PATCH v2 1/4] introduce zero filled pages handler
>>
>> > +
>> > +   for (pos = 0; pos < PAGE_SIZE / sizeof(*page); pos++) {
>> > +           if (page[pos])
>> > +                   return false;
>>
>> Perhaps allocate a static page filled with zeros and just do memcmp?
>
> That seems like a bad idea.  Why compare two different
> memory locations when comparing one memory location
> to a register will do?
>

Good point. I was hoping there was an fast memcmp that would
do fancy SSE registers. But it is memory against memory instead of
registers.

Perhaps a cunning trick would be to check (as a shortcircuit)
check against 'empty_zero_page' and if that check fails, then try
to do the check for each byte in the code?

>

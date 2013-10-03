Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab3JCR1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 13:27:41 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:49289 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab3JCR1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 13:27:39 -0400
Date: Thu, 3 Oct 2013 14:27:26 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] perf tool: more user-friendly errors from trace
Message-ID: <20131003172726.GD2436@ghostprotocols.net>
References: <1380788891-31908-1-git-send-email-artagnon@gmail.com>
 <20131003165832.GA2436@ghostprotocols.net>
 <524DA6F9.9000608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524DA6F9.9000608@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Oct 03, 2013 at 11:18:49AM -0600, David Ahern escreveu:
> On 10/3/13 10:58 AM, Arnaldo Carvalho de Melo wrote:
> >What about the one attached instead? It

> Isnt' strerror(errno) preferred over sys_errlist[errno]?

I found it much simpler to index the array, but can change to using
strerror_r (which I think is preferred over strerror, but one needs to
be careful as there are some subtleties there as well...).

Apart from that, do you think using errno for such simple functions is
ok? i.e. just use the mechanism in place, errno is _already_ set up and
reflects exactly what we need to get propagated to those functions
callers.

- ARnaldo

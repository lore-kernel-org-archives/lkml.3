Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755Ab3LIStI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 13:49:08 -0500
Received: from mail-qe0-f49.google.com ([209.85.128.49]:65321 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933Ab3LIStH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 13:49:07 -0500
Date: Mon, 9 Dec 2013 15:49:01 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix bug for perf kvm report without
 guestmount.
Message-ID: <20131209184901.GE8098@ghostprotocols.net>
References: <1386365588-13046-1-git-send-email-yangds.fnst@cn.fujitsu.com>
 <20131206115627.GA2279@ghostprotocols.net>
 <52A4AED8.3000506@gmail.com>
 <20131209180705.GB8098@ghostprotocols.net>
 <52A60705.5030303@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A60705.5030303@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 09, 2013 at 11:08:05AM -0700, David Ahern escreveu:
> On 12/9/13, 11:07 AM, Arnaldo Carvalho de Melo wrote:
> >Em Sun, Dec 08, 2013 at 10:39:36AM -0700, David Ahern escreveu:
> >>On 12/6/13, 4:56 AM, Arnaldo Carvalho de Melo wrote:
> >>>You get correct results because the modules/kallsyms info you provided
> >>>matches the VM you're testing, i.e. the pid test is not needed.
> >>>
> >>>I think we need to specify for which PID the --guestmodules and
> >>>--guestkallsyms is provided, so that it can refuse to use it for pids
> >>>where it is invalid.
> >>
> >>Those are arguments are shortcut defaults for guests. If the VMs are
> >>not running the same kernel use guestmount and pid specific
> >>directories. e.g.,
> >>
> >>/tmp/guestmount/<pid>/proc/kallsyms
> >
> >Does this already works like that? /me tries to figure that out...
> 
> yes.
> 

Yeah, I saw that:

        if ((pid != HOST_KERNEL_ID) &&
            (pid != DEFAULT_GUEST_KERNEL_ID) &&
            (symbol_conf.guestmount)) {
                sprintf(path, "%s/%d", symbol_conf.guestmount, pid);

So, in summary, ack/nack this patch?

- Arnaldo

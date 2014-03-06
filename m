Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbaCFXfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 18:35:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36520 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbaCFXfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 18:35:31 -0500
Date: Thu, 6 Mar 2014 15:35:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>, kys@microsoft.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, apw@canonical.com
Subject: Re: [PATCH] checkpatch: net and drivers/net: Warn on missing blank
 line after variable declaration
Message-Id: <20140306153530.bd61c160ba6f7872d6967b2e@linux-foundation.org>
In-Reply-To: <1394148520.16156.8.camel@joe-AO722>
References: <1394104358-23438-1-git-send-email-kys@microsoft.com>
	<1394104390-23477-1-git-send-email-kys@microsoft.com>
	<20140306.142919.763823800315842610.davem@davemloft.net>
	<1394148520.16156.8.camel@joe-AO722>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Mar 2014 15:28:40 -0800 Joe Perches <joe@perches.com> wrote:

> Networking prefers this style, so warn when it's not used.
> 
> Networking uses:
> 
> void foo(int bar)
> {
> 	int baz;
> 
> 	code...
> }
> 
> not
> 
> void foo(int bar)
> {
> 	int baz;
> 	code...
> }
> 
> There are a limited number of false positives when using
> macros to declare variables like:
> 
> WARNING: networking uses a blank line after declarations
> #330: FILE: net/ipv4/inet_hashtables.c:330:
> +	int dif = sk->sk_bound_dev_if;
> +	INET_ADDR_COOKIE(acookie, saddr, daddr)

um wait wut wot.

*All* kernel code uses blank line between end-of-locals and
start-of-code.  Or if it doesn't it should, thwap.

Why are we special-casing net/?

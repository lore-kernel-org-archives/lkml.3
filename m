Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbaBOTkX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 14:40:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53199 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732AbaBOTkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 14:40:22 -0500
Date: Sat, 15 Feb 2014 11:41:42 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] lib: Fix some sparse warnings in devres.c
Message-ID: <20140215194142.GA2395@kroah.com>
References: <20140206111346.712edc04@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140206111346.712edc04@gandalf.local.home>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 11:13:46AM -0500, Steven Rostedt wrote:
> Having a discussion about sparse warnings in the kernel, and that we
> should clean them up, I decided to pick a random file to do so. This
> happened to be devres.c which gives the following warnings:
> 
>   CHECK   lib/devres.c
> lib/devres.c:83:9: warning: cast removes address space of expression
> lib/devres.c:117:31: warning: incorrect type in return expression (different address spaces)
> lib/devres.c:117:31:    expected void [noderef] <asn:2>*
> lib/devres.c:117:31:    got void *
> lib/devres.c:125:31: warning: incorrect type in return expression (different address spaces)
> lib/devres.c:125:31:    expected void [noderef] <asn:2>*
> lib/devres.c:125:31:    got void *
> lib/devres.c:136:26: warning: incorrect type in assignment (different address spaces)
> lib/devres.c:136:26:    expected void [noderef] <asn:2>*[assigned] dest_ptr
> lib/devres.c:136:26:    got void *
> lib/devres.c:226:9: warning: cast removes address space of expression
> 
> Mostly it's just the use of typecasting to void * without adding
> __force, or returning ERR_PTR(-ESOMEERR) without typecasting to a
> __iomem type.
> 
> I added a helper macro IOMEM_ERR_PTR() that does the typecast to make
> the code a little nicer than adding ugly typecasts to the code.
> 
> This is applied against linux-next.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

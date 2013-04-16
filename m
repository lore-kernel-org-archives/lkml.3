Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab3DPPKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 11:10:31 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46794 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751841Ab3DPPKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 11:10:30 -0400
Message-ID: <1366125029.18313.5.camel@joe-AO722>
Subject: Re: [Patch -v3 3/4] checkpatch.pl the new kernel/reboot.c file.
From: Joe Perches <joe@perches.com>
To: Robin Holt <holt@sgi.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Date: Tue, 16 Apr 2013 08:10:29 -0700
In-Reply-To: <20130416094100.GK3658@sgi.com>
References: <20130415171225.GC3658@sgi.com> <20130415171603.GH3672@sgi.com>
	 <1366047938.31131.6.camel@joe-AO722> <20130416094100.GK3658@sgi.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(trimmed cc's)

On Tue, 2013-04-16 at 04:41 -0500, Robin Holt wrote:
> On Mon, Apr 15, 2013 at 10:45:38AM -0700, Joe Perches wrote:
> > trivia:
> > I'd make these changes on top of your patch:
> > o Additional OOM messages aren't necessary as a dump_stack is done
> I am not sure what I should be doing with this one.

It could be removed eventually.

> The only message
> that seems close is the pr_warn("%s failed to allocate memory for...
> but I don't see how dump_stack is getting invoked so I think either
> you did not mean this message or you intended me to replace that with a
> dump_stack, in which case, the error message would still be informative
> and the dump_stack would be relatively useless.

All failed mallocs without __GFP_NOWARN get a dump_stack via
mm/page_alloc:warn_alloc_failed() so that pr_warn isn't really
required.


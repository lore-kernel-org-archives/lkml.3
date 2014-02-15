Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbaBOWyr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 17:54:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbaBOWyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 17:54:46 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1392326938-14405-1-git-send-email-paul.gortmaker@windriver.com>
References: <1392326938-14405-1-git-send-email-paul.gortmaker@windriver.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH] kbuild: unconditionally clobber include/linux/version.h on distclean
Date: Sat, 15 Feb 2014 22:54:41 +0000
Message-ID: <16324.1392504881@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

> As of v3.7, the UAPI changes relocated headers around such that the
> kernel version header lived in a new place.
> 
> If a person is bisecting and if you go back to pre-UAPI days,
> you will create an include/linux/version.h  -- then if you checkout a
> post-UAPI kernel, and even run "make distclean" it still won't delete
> that old version file.  So you get a situation like this:
> 
> $ grep -R LINUX_VERSION_CODE include/
> include/generated/uapi/linux/version.h:#define LINUX_VERSION_CODE 200192
> include/linux/version.h:#define LINUX_VERSION_CODE 132646
> 
> The value in that second line is representative of a v2.6.38 version.
> And it will be sourced/used, hence leading to strange behaviours, such
> as drivers/staging content (which typically hasn't been purged of version
> ifdefs) failing to build.
> 
> Since it is a subtle mode of failure, lets always clobber the old
> file when doing a distclean.
> 
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Acked-by: David Howells <dhowells@redhat.com>

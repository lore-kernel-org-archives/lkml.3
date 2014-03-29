Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbaC2UBE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 16:01:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52162 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbaC2UAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 16:00:49 -0400
Message-ID: <5337266F.4030407@suse.cz>
Date: Sat, 29 Mar 2014 21:00:47 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] kbuild: unconditionally clobber include/linux/version.h
 on distclean
References: <1392326938-14405-1-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1392326938-14405-1-git-send-email-paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 13.2.2014 22:28, Paul Gortmaker napsal(a):
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

Applied to kbuild.git, sorry for the delay. I'm curious how long will it
take until somebody posts a cleanup patch removing the obsolete
include/linux/version.h reference...

Michal

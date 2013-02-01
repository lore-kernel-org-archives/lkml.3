Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab3BAJ5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 04:57:09 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46528 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259Ab3BAJ5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 04:57:07 -0500
Date: Fri, 1 Feb 2013 10:57:01 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: mingo@redhat.com, peterz@infradead.org, paulus@samba.org,
        acme@ghostprotocols.net, penberg@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] liblock: public headers for mutex implementation
Message-ID: <20130201095701.GA23061@gmail.com>
References: <1359694058-24452-1-git-send-email-sasha.levin@oracle.com>
 <1359694058-24452-3-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359694058-24452-3-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sasha Levin <sasha.levin@oracle.com> wrote:

> These headers provide the same API as their pthread mutex counterparts.
> 
> The design here is to allow to easily switch to liblock lock validation
> just by adding a "liblock_" to pthread_mutex_*() calls, which means that
> it's easy to integrate liblock into existing codebases.

I'd suggest to name the user-space counterpart 'liblockdep', to 
make it clear that this is user-space lockdep.

Regarding pthread_mutex_t checking, I think what we *really* 
want is a wrapper that can be activated via:

#define __USE_LIBLOCKDEP

And which then takes over the pthread primitives via:

  #define pthread_mutex_lock liblockdep_pthread_mutex_lock

or so.

That way the source code only needs a __USE_LIBLOCKDEP in one or 
two key places and checking is activated.

Thanks,

	Ingo

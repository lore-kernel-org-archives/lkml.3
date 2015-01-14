Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbbANOOD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:14:03 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:38540 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbbANOOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:14:01 -0500
Date: Wed, 14 Jan 2015 15:13:56 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
Subject: Re: [PATCH 6/8] locking/mcs: Better differentiate between mcs
 variants
Message-ID: <20150114141356.GA12084@gmail.com>
References: <1419757883-4423-1-git-send-email-dave@stgolabs.net>
 <1419757883-4423-7-git-send-email-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1419757883-4423-7-git-send-email-dave@stgolabs.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Davidlohr Bueso <dave@stgolabs.net> wrote:

> We have two flavors of the MCS spinlock: standard and cancelable (osq).
> While each one is independent of the other, we currently mix and match
> them. This patch:
> 
> o Moves osq code out of mcs_spinlock.h (which only deals with the traditional
> version) into include/linux/osq_lock.h. No unnecessary code is added to the
> more global header file, anything locks that make use of osq must include
> it anyway.
> 
> o Renames mcs_spinlock.c to osq_lock.c. This file only contains osq code.
> 
> o Introduces a CONFIG_LOCK_SPIN_ON_OWNER in order to only build osq_lock
> if there is support for it.
> 
> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
> ---
>  include/linux/osq_lock.h      |  12 ++-
>  kernel/Kconfig.locks          |   4 +
>  kernel/locking/Makefile       |   3 +-
>  kernel/locking/mcs_spinlock.c | 208 ------------------------------------------
>  kernel/locking/mcs_spinlock.h |  16 ----
>  kernel/locking/osq_lock.c     | 203 +++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 219 insertions(+), 227 deletions(-)
>  delete mode 100644 kernel/locking/mcs_spinlock.c
>  create mode 100644 kernel/locking/osq_lock.c

x86 defconfig produces:

  kernel/locking/mcs_spinlock.h:81:2: error: implicit declaration of function ‘ASSIGN_ONCE’ [-Werror=implicit-function-declaration]

Also, this patch should really be split into three separate (and 
tested) patches.

Thanks,

	Ingo

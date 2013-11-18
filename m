Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab3KRSU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:20:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628Ab3KRSUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:20:53 -0500
Date: Mon, 18 Nov 2013 19:22:07 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ian Kent <raven@themaw.net>
Cc: akpm@linux-foundation.org, sukadev@us.ibm.com, ebiederm@xmission.com,
        mszeredi@suse.cz, serge.hallyn@canonical.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] autofs4: allow autofs to work outside the initial
	PID namespace
Message-ID: <20131118182207.GA12569@redhat.com>
References: <20131115222222.6F70A1CA1A1@corp2gmr1-1.eem.corp.google.com> <20131116160334.GA19309@redhat.com> <1384743883.2380.23.camel@perseus.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384743883.2380.23.camel@perseus.fritz.box>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18, Ian Kent wrote:
>
> It might be sufficient to surround the contents of show_options() with a
> lock on wq_mutex and update the check at the top to
>
> "lock; if (!sbi || sbi->catatonic) {unlock, return 0; } ..."

Or perhaps you can add synchronize_rcu() after swap(oz_pgrp, new_pid),
then show_options() can use rcu_read_lock().

This makes me think that we want put_pid_rcu() but I do not see a
simple way to implement it without synchronize_rcu or kmalloc...

Oleg.


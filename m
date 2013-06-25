Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab3FYUCD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 16:02:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516Ab3FYUCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 16:02:01 -0400
Date: Tue, 25 Jun 2013 21:57:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Denys Vlasenko <dvlasenk@redhat.com>,
        Eric Wong <normalperson@yhbt.net>, Jason Baron <jbaron@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] signals: eventpoll: save/restore_sigmask cleanups
Message-ID: <20130625195738.GA15231@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Motivated by the recent patch from Denys. Lets cleanup this code
first, other set_restore_sigmask() users can be changed too.

Perhaps it also makes sense to add the new helper which does
copy_from_user + set saved_sigmask + set_current_blocked() ?

Oleg.

 fs/eventpoll.c |   38 +++++++++++++++++---------------------
 1 files changed, 17 insertions(+), 21 deletions(-)


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656AbaKTSeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 13:34:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664AbaKTSeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 13:34:01 -0500
Date: Thu, 20 Nov 2014 19:34:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Tomlin <atomlin@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] exit: avoid O(n ** 2) thread-list scan on group-exit
	if possible
Message-ID: <20141120183400.GA9622@redhat.com>
References: <20141107201424.GA22209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107201424.GA22209@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18, Oleg Nesterov wrote:
>
> but I found other bugs in this area. Fix them first. This is also
> preparation for the next changes in exit_notify() paths.

Finally the optimization I had in mind from the very beginning.

Probably this is not the last series... in particular it seems that we
have some problems with sys_setns() in this area, but I need to recheck.
Plus more cleanups/microoptimizations.

Oleg.

 kernel/exit.c |   50 +++++++++++++++++++++++++-------------------------
 1 files changed, 25 insertions(+), 25 deletions(-)



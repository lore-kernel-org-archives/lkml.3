Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100Ab3BFR6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:58:53 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:43451 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab3BFR6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:58:50 -0500
Date: Wed, 6 Feb 2013 09:58:48 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jan Kara <jack@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2] printk: Avoid softlockups in console_unlock()
In-Reply-To: <20130206142346.GF6330@quack.suse.cz>
Message-ID: <alpine.DEB.2.02.1302060958150.26828@chino.kir.corp.google.com>
References: <1360016230-26696-1-git-send-email-jack@suse.cz> <20130205123838.146a5371.akpm@linux-foundation.org> <20130206142346.GF6330@quack.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2013, Jan Kara wrote:

>   Yes, I noticed that thread just yesterday and also though that using
> similar trick might be viable. I'll experiment if we could use the same
> method for handling lockup problems I hit. Steven seems to have already
> tweaked PRINTK_PENDING stuff to be usable more easily...
> 

Are these new build failures in linux-next coming from this patch?

kernel/printk.c: In function 'console_unlock':
kernel/printk.c:2156:18: error: 'printk_work' undeclared (first use in this function)
kernel/printk.c:2156:18: note: each undeclared identifier is reported only once for each function it appears in
kernel/printk.c: At top level:
kernel/printk.c:2167:13: warning: 'printk_worker' defined but not used [-Wunused-function]

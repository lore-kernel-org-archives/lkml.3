Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662Ab3BZBqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 20:46:17 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:34668 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab3BZBqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 20:46:16 -0500
Message-ID: <1361843171.8053.1.camel@thor.lan>
Subject: Re: [PATCH] idr: Don't WARN in idr_find
From: Peter Hurley <peter@hurleysoftware.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Date: Mon, 25 Feb 2013 20:46:11 -0500
In-Reply-To: <20130226014027.GH2679@htj.dyndns.org>
References: <1361842632-29689-1-git-send-email-peter@hurleysoftware.com>
	 <20130226014027.GH2679@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-25 at 17:40 -0800, Tejun Heo wrote:
> On Mon, Feb 25, 2013 at 08:37:12PM -0500, Peter Hurley wrote:
> > Since idr is used for syscall apis (to associate 'handles' with
> > internal structures), don't WARN with invalid input.
> > 
> > For example, POSIX timers are identified by timer_t id. These
> > ids are idr values. If userspace passes a representable timer_t id
> > value (eg, id < 0) but which was not previous allocated (since the
> > current idr api does not return negative idr values), then the
> > syscall properly returns an error; a WARN is unnecessary and
> > undesirable.
> 
> WARN_ON() on negative was intentional.  Because the previous
> implmentation silently dropped the msb, we at least wanna know who has
> been passing in negative indices.  Patch for the lock_timer is already
> in -mm.

Thanks. Can you share the patch title? It's not in next-20130225.

Peter


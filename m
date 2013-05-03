Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762279Ab3ECAEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 20:04:08 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:37783 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760661Ab3ECAEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 20:04:04 -0400
Date: Thu, 2 May 2013 17:03:58 -0700
From: Tejun Heo <tj@kernel.org>
To: Colin Cross <ccross@android.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, arve@android.com,
        Oleg Nesterov <oleg@redhat.com>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH v2 03/10] freezer: add new freezable helpers using
 freezer_do_not_count()
Message-ID: <20130503000358.GX19814@mtj.dyndns.org>
References: <1367458508-9133-1-git-send-email-ccross@android.com>
 <1367458508-9133-4-git-send-email-ccross@android.com>
 <20130502235505.GW19814@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130502235505.GW19814@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 04:55:05PM -0700, Tejun Heo wrote:
> So, the freezable interface can't be something that people can use
> casually.  It is something which should be carefully and strategically
> deployed where we *know* that lock dependency risks don't exist or at
> least are acceptable.  I'm a bit weary that this patch is expanding
> the interface a lot that they now look like the equivalents of normal
> schedule calls.  Not exactly sure what to do here but can we please at
> least have RED BOLD BLINKING comments which scream to people not to
> use these unless they know what they're doing?

Maybe we should trigger WARN_ON_ONCE() if lockdep_depth() > 0 by
default and have ugly variants which can be used if the caller is sure
that it's okay possibly with list of locks which are held?

-- 
tejun

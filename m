Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab3ECEMP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 00:12:15 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:37005 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab3ECEMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 00:12:13 -0400
Date: Thu, 2 May 2013 21:12:08 -0700
From: Tejun Heo <tj@kernel.org>
To: Colin Cross <ccross@android.com>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Oleg Nesterov <oleg@redhat.com>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Jeff Layton <jlayton@redhat.com>,
        Mandeep Baines <msb@chromium.org>
Subject: Re: [PATCH v2 03/10] freezer: add new freezable helpers using
 freezer_do_not_count()
Message-ID: <20130503041208.GB16968@mtj.dyndns.org>
References: <1367458508-9133-1-git-send-email-ccross@android.com>
 <1367458508-9133-4-git-send-email-ccross@android.com>
 <20130502235505.GW19814@mtj.dyndns.org>
 <20130503000358.GX19814@mtj.dyndns.org>
 <CAMbhsRSFjUvkXq66pYs_nYN5At7yB4sFM+cpxLgUF_Yns54J5A@mail.gmail.com>
 <CAMbhsRTSCW3WOxTgw8btk2yWAucqNmyY-Sc+CHsHmZzf6ZsTNA@mail.gmail.com>
 <20130503040934.GA16968@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130503040934.GA16968@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 09:09:34PM -0700, Tejun Heo wrote:
> But that conflicts with what you're doing here which seems pretty
> useful, so, to satisfy both goals, when somebody needs to put a
> pseudo-frozen task into the actual frozen jobctl stop, those spots
> which are currently using try_to_stop() would have to return an error,
> most likely -EINTR with TIF_SIGPENDING set, and the control should

Let's make that -ERESTART*.

-- 
tejun

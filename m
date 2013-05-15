Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab3EOXFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 19:05:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34502 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab3EOXFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 19:05:34 -0400
Date: Wed, 15 May 2013 16:05:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oskar Andero <oskar.andero@sonymobile.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Hugh Dickins <hughd@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Radovan Lekanovic <radovan.lekanovic@sonymobile.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [RFC PATCH 0/2] return value from shrinkers
Message-Id: <20130515160532.c965e92707c354100e25f79b@linux-foundation.org>
In-Reply-To: <1368454595-5121-1-git-send-email-oskar.andero@sonymobile.com>
References: <1368454595-5121-1-git-send-email-oskar.andero@sonymobile.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 May 2013 16:16:33 +0200 Oskar Andero <oskar.andero@sonymobile.com> wrote:

> In a previous discussion on lkml it was noted that the shrinkers use the
> magic value "-1" to signal that something went wrong.
> 
> This patch-set implements the suggestion of instead using errno.h values
> to return something more meaningful.
> 
> The first patch simply changes the check from -1 to any negative value and
> updates the comment accordingly.
> 
> The second patch updates the shrinkers to return an errno.h value instead
> of -1. Since this one spans over many different areas I need input on what is
> a meaningful return value. Right now I used -EBUSY on everything for consitency.
> 
> What do you say? Is this a good idea or does it make no sense at all?

I don't see much point in it, really.  Returning an errno implies that
the errno will eventually be returned to userspace.  But that isn't the
case, so such a change is somewhat misleading.

If we want the capability to return more than a binary yes/no message
to callers then yes, we could/should enumerate the shrinker return
values.  But as that is a different concept from errnos, it should be
done with a different and shrinker-specific namespace.



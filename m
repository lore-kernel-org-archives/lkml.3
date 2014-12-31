Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbaLaPNq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 10:13:46 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:43407 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbaLaPNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 10:13:45 -0500
Date: Wed, 31 Dec 2014 07:13:41 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Jonas Lundqvist <jonas@gannon.se>
Cc: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm: Move two seq_printf's outside of locked mutex
Message-ID: <20141231151341.GA2162@newt.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Jonas Lundqvist <jonas@gannon.se>, airlied@linux.ie,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <1419976466-2113-1-git-send-email-jonas@gannon.se>
 <20141230225211.GB31616@hudson.localdomain>
 <54A3B9F7.4080808@gannon.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54A3B9F7.4080808@gannon.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonas,

On Wed, Dec 31, 2014 at 09:55:19AM +0100, Jonas Lundqvist wrote:
> Hi Jeremiah,
> 
> On 12/30/2014 11:52 PM, Jeremiah Mahler wrote:
> > You changed 'i' but you didn't explain in your log message why you did this.
> 
> I can change the commit message to something more generic. "Move code
> outside of locked mutex" or similar.
> 
That still doesn't explain why you changed the 'i' variable.

> > Does this change really improve anything?  It may work the same with the
> > locks moved around.  But if you look at the function as a whole, the
> > locks encapsulate the body of this function nicely.  I like the original
> > design better.
> 
> The locking was already done this way, ie after the seq_printf, in the
> functions drm_clients_info() and drm_gem_name_info() in thr same file.
> So this change is really more of an alignment.
> 
Your right, those two have have the lock after the seq_printf.
But the drm_bufs_info() function has its lock before the seq_printf.
So before your change about half are one way and half are the other.

I am still not convinced that either of these ways is better or makes
any difference whatsoever.

> Best regards
> Jonas
> 

-- 
- Jeremiah Mahler

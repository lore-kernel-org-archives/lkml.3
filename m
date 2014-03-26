Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbaCZTGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 15:06:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51572 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbaCZTGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 15:06:19 -0400
Date: Wed, 26 Mar 2014 20:06:15 +0100
From: Jan Kara <jack@suse.cz>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, pmladek@suse.cz,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 6/8] printk: Start printing handover kthreads on demand
Message-ID: <20140326190615.GB18118@quack.suse.cz>
References: <1395770101-24534-1-git-send-email-jack@suse.cz>
 <1395770101-24534-7-git-send-email-jack@suse.cz>
 <20140326171641.0e117018@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140326171641.0e117018@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 26-03-14 17:16:41, One Thousand Gnomes wrote:
> On Tue, 25 Mar 2014 18:54:59 +0100
> Jan Kara <jack@suse.cz> wrote:
> 
> > Start kthreads for handing over printing only when printk.offload_chars
> > is set to value > 0 (i.e., when print offloading gets enabled).
> 
> The original set it was suggested that having all these threads around
> that 99.99999% of users don't need was a waste and why not start them
> when needed. Also I asked why you couldn't just schedule_work the jobs
> onto CPUs instead.
> 
> I don't recall seeing a reply to that - and it doesn't appear fixed here ?
  I replied to you (https://lkml.org/lkml/2014/3/14/176) regarding why
people refused schedule_work() to be used.

  Regarding starting threads only when needed: Starting threads from
console_unlock() is IHMO a no-go because that can happen in a context in
which we cannot just call create_kthread(). So the solution I proposed -
and noone really objected - was what this patch does. Also note that we
agreed with Andrew that after this feature gets some testing, we will
change the default to disabled so that most people don't pay the
unnecessary overhead.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

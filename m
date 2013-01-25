Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab3AYXrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 18:47:20 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:60007 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab3AYXrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 18:47:19 -0500
Date: Fri, 25 Jan 2013 15:47:14 -0800
From: Tejun Heo <tj@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, pmatouse@redhat.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 06/13] sg_io: whitelist a few more commands for
 multimedia devices
Message-ID: <20130125234714.GR3081@htj.dyndns.org>
References: <20130125170434.GC3081@htj.dyndns.org>
 <5102BDD4.2020501@redhat.com>
 <20130125172805.GG3081@htj.dyndns.org>
 <5102C780.3090402@redhat.com>
 <20130125181326.GK3081@htj.dyndns.org>
 <5102D353.8010305@redhat.com>
 <20130125190154.GM3081@htj.dyndns.org>
 <5103080A.4090803@redhat.com>
 <20130125224159.GQ3081@htj.dyndns.org>
 <51031614.8000609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51031614.8000609@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Paolo.

On Sat, Jan 26, 2013 at 12:32:36AM +0100, Paolo Bonzini wrote:
> If I make a whitelist with all the commands that Linux sends, I'll have
> many new commands in the whitelist and no old commands.  The new
> commands didn't exist when old drives were sold, so they are "dangerous"
> in your opinion.  At that point I might as well keep the whitelist
> empty, no?

Let's not go to extremes.  It's not about theoretic correctness.  It's
about how to appraoch a possibly messy practical problem.  To me, it
seems natural to be conservative on this and add what's being acitvely
used, which as a bonus will also give us at least some chance of
evaluating what we have and why later on if it ever needs to be
changed.

I'm just not comfortable with adding a bunch of commands by simply
scanning the specs.  Let's at least have some backing data and
justification for exposing new ones.  I really don't think that's too
much to ask.  Start with minimal set.  Grow it as needed.  We can
always grow but the other direction is much harder.

Thanks.

-- 
tejun

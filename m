Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab3AYUZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 15:25:38 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:42559 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816Ab3AYUZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 15:25:36 -0500
Date: Fri, 25 Jan 2013 13:25:38 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Kent Yoder <shpedoikal@gmail.com>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [PATCH] TPM: Work around buggy TPMs that block
 during continue self test
Message-ID: <20130125202538.GA16038@obsidianresearch.com>
References: <20121121211529.GA27696@obsidianresearch.com>
 <CAM0nabE9qORsD1bMDm6EUZogPqb2m-X8rZ-xVqJecM7oJyaciw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0nabE9qORsD1bMDm6EUZogPqb2m-X8rZ-xVqJecM7oJyaciw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 05:29:23PM -0600, Kent Yoder wrote:
> Hi Jason,
> 
> On Wed, Nov 21, 2012 at 3:15 PM, Jason Gunthorpe
> <jgunthorpe@obsidianresearch.com> wrote:
> > We've been testing an alternative TPM for our embedded products and
> > found random kernel boot failures due to time outs after the continue
> > self test command.
> >
> > This was happening randomly, and has been *very* hard to track down, but it
> > looks like with this chip there is some kind of race with the tpm_tis_status()
> > check of TPM_STS_COMMAND_READY. If things get there 'too fast' then
> > it sees the chip is ready, or tpm_tis_ready() works. Otherwise it takes
> > somewhere over 400ms before the chip will return TPM_STS_COMMAND_READY.
> >
> > Adding some delay after tpm_continue_selftest() makes things reliably
> > hit the failure path, otherwise it is a crapshot.
> 
>   I've staged this patch here, please test:
> 
> https://github.com/shpedoikal/linux.git tpmdd-01-22-13

Thanks Kent, I will try to test your branch next week, if I am able.

Can you also grab

https://github.com/jgunthorpe/linux/commit/98b2a198b43b41b0535200bf475160786398f114

And did you have any comments on:

https://github.com/jgunthorpe/linux/commit/9981e3e622bf702394982117134bed731ffd6f7e

Both were posted to the list a bit ago.

Regards,
-- 
Jason Gunthorpe <jgunthorpe@obsidianresearch.com>        (780)4406067x832
Chief Technology Officer, Obsidian Research Corp         Edmonton, Canada

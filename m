Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaBZAf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 19:35:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbaBZAfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 19:35:55 -0500
Date: Tue, 25 Feb 2014 19:35:45 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Michael Mueller <malware@t-online.de>
Cc: linux-kernel@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>,
        Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>,
        Neil Brown <neilb@suse.de>
Subject: Re: 3.14-rc4 blocks on LVM init
Message-ID: <20140226003545.GA4167@redhat.com>
References: <530D3165.8070501@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530D3165.8070501@t-online.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25 2014 at  7:12pm -0500,
Michael Mueller <malware@t-online.de> wrote:

> Hi,
> 
> with 3.14-rc4 my box does not finish initializing the LVM array. It
> hangs within the call to rw_header() on line 632 of dm-log.c. See
> backtrace at end. Please excuse typos within - had to type it from a
> screen shot.
> 
> The problem seems to be introduced by the commit
> 003b5c5719f159f4f4bf97511c4702a0638313dd (block: Convert drivers to
> immutable biovecs).

You need these two 3.14-rc fixes that are staged in linux-next (via
linux-dm.git's 'for-next' branch):

https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=d73f9907294c670da14baea3fb31be27879e818e
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=f3a44fe0608eb628e1f8f6e3540462e6d171a745

I wanted to send these to Linus last week but I was waiting for some
dm-thin fixes that aren't quite ready.  I'll send whatever I have staged
to Linus by this Friday so that 3.14-rc5 will have these fixes no matter
what.

Sorry for the inconvenience.

Mike

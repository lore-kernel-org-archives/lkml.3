Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbaBKPl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:41:26 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:56891 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbaBKPlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:41:10 -0500
Date: Tue, 11 Feb 2014 08:41:07 -0700
From: Jens Axboe <axboe@kernel.dk>
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: Kent Overstreet <kmo@daterainc.com>, clm@fb.com,
        linux-fsdevel@vger.kernel.org, neilb@suse.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: Fix cloning of discard/write same bios
Message-ID: <20140211154107.GD19057@kernel.dk>
References: <1392083150-11670-1-git-send-email-kmo@daterainc.com>
 <20140211122216.GE1346@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211122216.GE1346@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11 2014, Richard W.M. Jones wrote:
> On Mon, Feb 10, 2014 at 05:45:50PM -0800, Kent Overstreet wrote:
> > Immutable biovecs changed the way bio segments are treated in such a way that
> > bio_for_each_segment() cannot now do what we want for discard/write same bios,
> > since bi_size means something completely different for them.
> > 
> > Fortunately discard and write same bios never have more than a single biovec, so
> > bio_for_each_segment() is unnecessary and not terribly meaningful for them, but
> > we still have to special case them in a few places.
> > 
> > Signed-off-by: Kent Overstreet <kmo@daterainc.com>
> 
> Tested-by: Richard W.M. Jones <rjones@redhat.com>
> 
> I have confirmed this fixes the bug described here:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=1061339

Thanks, I have applied it for immediate inclusion.

-- 
Jens Axboe


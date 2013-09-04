Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762389Ab3IDXos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 19:44:48 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:34757 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762153Ab3IDXop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 19:44:45 -0400
Date: Wed, 4 Sep 2013 16:45:04 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: kernel neophyte <neophyte.hacker001@gmail.com>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefan Priebe <s.priebe@profihost.ag>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] bcache: Fix a shrinker deadlock
Message-ID: <20130904234504.GA2635@kmo-pixel>
References: <CAFkUHxd6xN3On4DTC7VnUgVuy8M57k=8eKYr47bKKnpQWS+p8A@mail.gmail.com>
 <20130830211510.GA20307@kmo-pixel>
 <CAFkUHxfYeF8G+r3RYp3dTaOBzPqo_diVoF5g_7sAeW+wKprrjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFkUHxfYeF8G+r3RYp3dTaOBzPqo_diVoF5g_7sAeW+wKprrjA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 04:35:50PM -0700, kernel neophyte wrote:
> On Fri, Aug 30, 2013 at 2:15 PM, Kent Overstreet <kmo@daterainc.com> wrote:
> > GFP_NOIO means we could be getting called recursively - mca_alloc() ->
> > mca_data_alloc() - definitely can't use mutex_lock(bucket_lock) then.
> > Whoops.
> >
> > Signed-off-by: Kent Overstreet <kmo@daterainc.com>
> 
> Awesome! I tested the fix... no crashes/deadlock.
> But I see lower benchmark numbers for random write.. is this expected
> for this change ?

No... how much lower?

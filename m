Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbaE0R7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 13:59:21 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:51003 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbaE0R7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 13:59:20 -0400
MIME-Version: 1.0
In-Reply-To: <5384AA79.4010206@kernel.dk>
References: <alpine.LRH.2.02.1405271059190.27492@file01.intranet.prod.int.rdu2.redhat.com>
	<5384AA79.4010206@kernel.dk>
Date: Tue, 27 May 2014 10:59:19 -0700
Message-ID: <CALJ65znW7YK2moi6w6n-cm725c7Czci44EFzHDNv4y=sNcF66g@mail.gmail.com>
Subject: Re: [PATCH] block: flush queued bios when the process blocks
From: Kent Overstreet <kmo@daterainc.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        "Alasdair G. Kergon" <agk@redhat.com>,
        Mike Snitzer <msnitzer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 8:08 AM, Jens Axboe <axboe@kernel.dk> wrote:
> This really begs the question of why we just don't use the per-process plugs
> for this. We already have scheduler hooks in place to flush those at the
> appropriate time. Why are we reinventing something for essentially the same
> thing?

Yes! Unifying the two plugging mechanisms has been on my todo/wishlist for ages.

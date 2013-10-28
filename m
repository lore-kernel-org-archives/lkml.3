Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572Ab3J1VU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 17:20:58 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:57266 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab3J1VU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 17:20:57 -0400
Date: Mon, 28 Oct 2013 14:20:54 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] percpu_ida: Fix data race on cpus_have_tags cpumask
Message-ID: <20131028212054.GF8153@kmo>
References: <cover.1382950629.git.agordeev@redhat.com>
 <20131028100505.GB5744@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028100505.GB5744@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 11:05:06AM +0100, Alexander Gordeev wrote:
> Function steal_tags() might miss a bit in cpus_have_tags due to
> unsynchronized access from percpu_ida_free(). As result, function
> percpu_ida_alloc() might enter unwakable sleep. This update adds
> memory barriers to prevent the described scenario.
> 
> In fact, accesses to cpus_have_tags are fenced by prepare_to_wait()
> and wake_up() calls at the moment and the aforementioned sequence
> does not appear could hit. Nevertheless, explicit memory barriers
> still seem justifiable.

Good catch!

Acked-by: Kent Overstreet <kmo@daterainc.com>

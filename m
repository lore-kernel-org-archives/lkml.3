Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332Ab3E1Vxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:53:51 -0400
Received: from www.sr71.net ([198.145.64.142]:40221 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757303Ab3E1Vxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:53:50 -0400
Message-ID: <51A52768.3020106@sr71.net>
Date: Tue, 28 May 2013 14:53:44 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>
CC: LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Shaohua Li <shli@kernel.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: mmotm-2013-05-22: Bad page state
References: <51A526D9.3020803@sr71.net>
In-Reply-To: <51A526D9.3020803@sr71.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2013 02:51 PM, Dave Hansen wrote:
> I was rebasing my mapping->radix_tree lock batching patches on top of
> Mel's stuff.  It looks like something is jumping the gun and freeing a
> page before it has been written out.  Somebody probably did an extra
> put_page() or something.
> 
> I'm running 3.10.0-rc2-mm1-00322-g8d4c612 from
> 
> 	git://git.cmpxchg.org/linux-mmotm.git

This is the config, btw:

	http://sr71.net/~dave/linux/config-3.10-mmotmbad1

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab3F1A65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 20:58:57 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:57682 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab3F1A64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 20:58:56 -0400
Date: Thu, 27 Jun 2013 17:58:53 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Luiz Capitulino <lcapitulino@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, mhocko@suse.cz,
        kmpark@infradead.org, hyunhee.kim@samsung.com
Subject: Re: [PATCH v2] vmpressure: implement strict mode
Message-ID: <20130628005852.GA8093@teo>
References: <20130626231712.4a7392a7@redhat.com>
 <20130627150231.2bc00e3efcd426c4beef894c@linux-foundation.org>
 <20130628000201.GB15637@bbox>
 <20130627173433.d0fc6ecd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130627173433.d0fc6ecd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 05:34:33PM -0700, Andrew Morton wrote:
> > If so, userland daemon would receive lots of events which are no interest.
> 
> "lots"?  If vmpressure is generating events at such a high frequency that
> this matters then it's already busted?

Current frequency is 1/(2MB). Suppose we ended up scanning the whole
memory on a 2GB host, this will give us 1024 hits. Doesn't feel too much*
to me... But for what it worth, I am against adding read() to the
interface -- just because we can avoid the unnecessary switch into the
kernel.

* For bigger hosts we should increase the window, as we do for the vmstat. 

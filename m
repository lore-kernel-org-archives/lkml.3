Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262Ab3F1FHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 01:07:17 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:48404 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab3F1FHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 01:07:15 -0400
Date: Thu, 27 Jun 2013 22:07:12 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Luiz Capitulino <lcapitulino@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, mhocko@suse.cz,
        kmpark@infradead.org, hyunhee.kim@samsung.com
Subject: Re: [PATCH v2] vmpressure: implement strict mode
Message-ID: <20130628050712.GA10097@teo>
References: <20130626231712.4a7392a7@redhat.com>
 <20130627150231.2bc00e3efcd426c4beef894c@linux-foundation.org>
 <20130628000201.GB15637@bbox>
 <20130627173433.d0fc6ecd.akpm@linux-foundation.org>
 <20130628005852.GA8093@teo>
 <20130627181353.3d552e64.akpm@linux-foundation.org>
 <20130628043411.GA9100@teo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130628043411.GA9100@teo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 09:34:11PM -0700, Anton Vorontsov wrote:
> ... we can add the strict mode and deprecate the
> "filtering" -- basically we'll implement the idea of requiring that
> userspace registers a separate fd for each level.

Btw, assuming that more levels can be added, there will be a problem:
imagine that an app hooked up onto low, med, crit levels in "strict"
mode... then once we add a new level, the app will start missing the new
level events.

In the old scheme it is not a problem because of the >= condition.

With a proper versioning this won't be a problem for a new scheme too.

Anton

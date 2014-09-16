Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbaIPCk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 22:40:56 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:57612 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbaIPCkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 22:40:55 -0400
X-Original-SENDERIP: 10.177.220.156
X-Original-MAILFROM: minchan@kernel.org
Date: Tue, 16 Sep 2014 11:41:07 +0900
From: Minchan Kim <minchan@kernel.org>
To: Dan Streetman <ddstreet@ieee.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] zsmalloc: simplify init_zspage free obj linking
Message-ID: <20140916024107.GF10912@bbox>
References: <20140914232427.GD2160@bbox>
 <1410814730-5740-1-git-send-email-ddstreet@ieee.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1410814730-5740-1-git-send-email-ddstreet@ieee.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 04:58:50PM -0400, Dan Streetman wrote:
> Change zsmalloc init_zspage() logic to iterate through each object on
> each of its pages, checking the offset to verify the object is on the
> current page before linking it into the zspage.
> 
> The current zsmalloc init_zspage free object linking code has logic
> that relies on there only being one page per zspage when PAGE_SIZE
> is a multiple of class->size.  It calculates the number of objects
> for the current page, and iterates through all of them plus one,
> to account for the assumed partial object at the end of the page.
> While this currently works, the logic can be simplified to just
> link the object at each successive offset until the offset is larger
> than PAGE_SIZE, which does not rely on PAGE_SIZE being a multiple of
> class->size.
> 
> Signed-off-by: Dan Streetman <ddstreet@ieee.org>
> Cc: Minchan Kim <minchan@kernel.org>
Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim

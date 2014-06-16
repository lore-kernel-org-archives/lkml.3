Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbaFPXNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 19:13:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbaFPXNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 19:13:43 -0400
Date: Mon, 16 Jun 2014 16:13:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: page_alloc: simplify drain_zone_pages by using
 min()
Message-Id: <20140616161341.2f677b79afb4da9250fd4282@linux-foundation.org>
In-Reply-To: <1402952894-13200-1-git-send-email-mina86@mina86.com>
References: <1402952894-13200-1-git-send-email-mina86@mina86.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014 23:08:14 +0200 Michal Nazarewicz <mina86@mina86.com> wrote:

> Instead of open-coding getting minimal value of two, just use min macro.
> That is why it is there for.  While changing the function also change
> type of batch local variable to match type of per_cpu_pages::batch
> (which is int).
> 

I'm not sure why we made all the per_cpu_pages mambers `int'.  Unsigned
would make more sense.



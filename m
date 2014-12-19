Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbaLSXpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 18:45:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44124 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbaLSXpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 18:45:50 -0500
Date: Fri, 19 Dec 2014 15:45:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Ganesh Mahendran <opensource.ganesh@gmail.com>, ngupta@vflare.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/zsmalloc: add statistics support
Message-Id: <20141219154548.3aa4cc02b3322f926aa4c1d6@linux-foundation.org>
In-Reply-To: <20141219233937.GA11975@blaptop>
References: <1418993719-14291-1-git-send-email-opensource.ganesh@gmail.com>
	<20141219143244.1e5fabad8b6733204486f5bc@linux-foundation.org>
	<20141219233937.GA11975@blaptop>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Dec 2014 08:39:37 +0900 Minchan Kim <minchan@kernel.org> wrote:

> Then, we should fix debugfs_create_dir can return errno to propagate the error
> to end user who can know it was failed ENOMEM or EEXIST.

Impractical.  Every caller of every debugfs interface will need to be
changed!

It's really irritating and dumb.  What we're supposed to do is to
optionally report the failure, then ignore it.  This patch appears to
be OK in that respect.

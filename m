Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932863AbaKRXe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 18:34:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932494AbaKRXe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 18:34:26 -0500
Date: Tue, 18 Nov 2014 15:34:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Seth Jennings <sjennings@variantweb.net>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Dan Streetman <ddstreet@ieee.org>,
        Jerome Marchand <jmarchan@redhat.com>
Subject: Re: [PATCH] zsmalloc: correct fragile [kmap|kunmap]_atomic use
Message-Id: <20141118153424.70899732d4ed7933892b6055@linux-foundation.org>
In-Reply-To: <20141118232139.GA7393@bbox>
References: <1415927461-14220-1-git-send-email-minchan@kernel.org>
	<20141114150732.GA2402@cerebellum.variantweb.net>
	<20141118150138.668c81fda55c3ce39d7b2aac@linux-foundation.org>
	<20141118232139.GA7393@bbox>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2014 08:21:39 +0900 Minchan Kim <minchan@kernel.org> wrote:

> Main reason I sent the patch is I got a subtle bug when I implement
> new feature of zsmalloc(ie, compaction) due to link's mishandling
> (ie, link was over page boundary by my fault).
> Although it was totally my mistake, it took time for a while
> to find a root cause because unpredictable kmapped address should
> be unmapped so it's almost random crash.

Fair enough.

That's pretty rude behaviour from kunmap_atomic().  Unfortunately it
just doesn't have anything with which to check the address - we'd need
to create a special per-cpu array[KM_TYPE_NR] just for the purpose.

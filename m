Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751292Ab3FXUFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 16:05:24 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:48690 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab3FXUFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 16:05:22 -0400
Date: Mon, 24 Jun 2013 13:05:18 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-bcache@vger.kernel.org
Subject: Re: bcache: order 7 allocation
Message-ID: <20130624200518.GA2509@google.com>
References: <20130622114745.GB8075@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130622114745.GB8075@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 22, 2013 at 01:47:46PM +0200, Pavel Machek wrote:
> Hi!
> 
> I'm trying to play with bcache, but first surprise was oom in syslog:
> 
> Order 7 alocation is pretty big, no?

That's a btree node - and after it allocates the reserve at startup,
allocation failures don't matter.

I would just flip on CONFIG_COMPACTION - CONFIG_BCACHE used to select
that but someone complained (probably I just shouldn't have listened).

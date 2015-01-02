Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbbABRev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 12:34:51 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:33127 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbbABReu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 12:34:50 -0500
Date: Fri, 2 Jan 2015 17:34:47 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jens Axboe <axboe@fb.com>
Cc: Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: fix checking return value of blk_mq_init_queue
Message-ID: <20150102173447.GS22149@ZenIV.linux.org.uk>
References: <1420208727-9563-1-git-send-email-ming.lei@canonical.com>
 <54A6BEE7.3020601@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54A6BEE7.3020601@fb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2015 at 08:53:11AM -0700, Jens Axboe wrote:
> On 01/02/2015 07:25 AM, Ming Lei wrote:
> >Check IS_ERR_OR_NULL(return value) instead of just return value.
> 
> Thanks Ming, applied.

Umm...  Looking at the callers, I'd suggest making it _never_ return NULL -
it's always treates as ERR_PTR(-ENOMEM) anyway.  Then the checks would be
just IS_ERR(...).

IS_ERR_OR_NULL() is very often a sign of lousy calling conventions and
this case is no exception...

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab3JLBCw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 21:02:52 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:41540 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab3JLBCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 21:02:51 -0400
Date: Sat, 12 Oct 2013 09:02:39 +0800
From: Shaohua Li <shli@kernel.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [patch 3/4] percpu_ida: add an API to return free tags
Message-ID: <20131012010239.GC17666@kernel.org>
References: <20131011071802.148101321@kernel.org>
 <20131011072341.346343362@kernel.org>
 <20131011203536.GJ28572@kmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131011203536.GJ28572@kmo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 01:35:36PM -0700, Kent Overstreet wrote:
> On Fri, Oct 11, 2013 at 03:18:05PM +0800, Shaohua Li wrote:
> > add an API to return free tags, blk-mq-tag will use it
> 
> Can you explain how this is going to be used? Seems like something that
> could be prone to misuse, try and convince me there isn't a better way
> to do what it's for.

There are two usages. One is for sysfs info output, which can be used for
diagnosis. The other one is blk-mq wants to determine if it's possible a
request can be queued. Neither requires precise data. Yes, caller should be
aware returned data isn't very precise.

Thanks,
Shaohua

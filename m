Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab3CSR21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:28:27 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:50987 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757108Ab3CSR20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:28:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130319154600.GC5222@quack.suse.cz>
References: <1362692649-25570-1-git-send-email-tj@kernel.org>
	<1362692649-25570-4-git-send-email-tj@kernel.org>
	<20130312150510.GF13152@quack.suse.cz>
	<20130318223244.GA11188@quack.suse.cz>
	<20130318223526.GH3042@htj.dyndns.org>
	<20130319154600.GC5222@quack.suse.cz>
Date: Tue, 19 Mar 2013 10:28:24 -0700
X-Google-Sender-Auth: -epmqkaj3sV0lvXkLvGAbJ3HrK8
Message-ID: <CAOS58YMop8+TnCGK2+SH52WNyK011vP0BWu3XENjrGt9xks32w@mail.gmail.com>
Subject: Re: [PATCH 3/4] writeback: replace custom worker pool implementation
 with unbound workqueue
From: Tejun Heo <tj@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, laijs@cn.fujitsu.com, fengguang.wu@intel.com,
        linux-kernel@vger.kernel.org, jmoyer@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jan.

On Tue, Mar 19, 2013 at 8:46 AM, Jan Kara <jack@suse.cz> wrote:
>   Well, but what you often get is just output of sysrq-w, or sysrq-t, or
> splat from scheduler about stuck task. You often don't have the comfort of
> tracing... Can't we somehow change 'comm' of the task when it starts
> processing work of some bdi?

You sure can but I'd prefer not to do that. If you wanna do it
properly, you have to grab task lock every time a work item starts
execution. I'm not sure how beneficial having the block device
identifier would be. Backtrace would be there the same. Is identifying
the block device that important?

Thanks.

-- 
tejun

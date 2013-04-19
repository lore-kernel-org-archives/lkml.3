Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab3DSSMB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 14:12:01 -0400
Received: from mail-qe0-f41.google.com ([209.85.128.41]:35443 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab3DSSMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 14:12:00 -0400
Date: Fri, 19 Apr 2013 11:11:55 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 0/8] workqueue: advance concurrency management
Message-ID: <20130419181155.GA13811@mtj.dyndns.org>
References: <1365957716-7631-1-git-send-email-laijs@cn.fujitsu.com>
 <CACvQF509UnU5RLtoxhnwmfdkudAR+_oWDKLfpq28WeKcUst5qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACvQF509UnU5RLtoxhnwmfdkudAR+_oWDKLfpq28WeKcUst5qw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Fri, Apr 19, 2013 at 06:10:57AM +0800, Lai Jiangshan wrote:
> Ping.

Sorry, I've been at collab summit / lsf.  Plus, it's a bit too late
for for-3.10 anyway.  Anyways, after glancing over it, here are my
preliminary thoughts.  The first one looks good but I'm not sure about
dropping nr_running adjustment.  The only real benefit coming from
that is dropping a sched callback and if there's any performance /
overhead impact, I'm afraid it's gonna be negative.  There are actual
benefits in using as few tasks as possible - the cache footprint gets
smaller, so unless there's a clear indication that the suggested
behavior is better in some way, I'm not sure what we're buying with
the proposed changes.

Thanks.

-- 
tejun

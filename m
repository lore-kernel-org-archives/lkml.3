Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab3AaXxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 18:53:32 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:64689 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab3AaXxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 18:53:31 -0500
Date: Thu, 31 Jan 2013 15:53:20 -0800
From: Tejun Heo <tj@kernel.org>
To: David Teigland <teigland@redhat.com>
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org,
        Christine Caulfield <ccaulfie@redhat.com>, cluster-devel@redhat.com
Subject: Re: [PATCH 10/14] dlm: don't use idr_remove_all()
Message-ID: <20130131235320.GN6824@mtj.dyndns.org>
References: <1359163872-1949-1-git-send-email-tj@kernel.org>
 <1359163872-1949-11-git-send-email-tj@kernel.org>
 <20130128155723.GC16789@redhat.com>
 <20130129151317.GA11609@redhat.com>
 <20130130212417.GJ24014@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130130212417.GJ24014@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, David.

Sorry about the delay.

On Wed, Jan 30, 2013 at 04:24:18PM -0500, David Teigland wrote:
> > Unfortunately, the list_for_each_entry doesn't seem to be clearing
> > everything.  I've seen "warning: recover_list_count 39" at the end of that
> > function.
> 
> I don't want to pretend to understand the internals of this idr code, but
> it's not clear that idr_for_each is equivalent to idr_for_each_entry when
> iterating through all id values.  The "++id" in idr_for_each_entry looks
> like it could lead to some missed entries?  The comment about idr_get_next
> returning the "next number to given id" sounds like an entry with an id of
> "++id" would be missed.

The function description is misleading.  The function does search
inclusive range and needs explicit cursor increment to make progress.
Weird that it doesn't work.  Looking into it.  I'll write when I know
more.

Thanks!

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbaBTWqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 17:46:42 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:54992 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbaBTWql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 17:46:41 -0500
Date: Thu, 20 Feb 2014 17:46:36 -0500
From: Tejun Heo <tj@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        linux-afs@lists.infradead.org
Subject: Re: [PATCH 7/9] afs: don't use PREPARE_WORK
Message-ID: <20140220224636.GB6573@mtj.dyndns.org>
References: <1392929071-16555-8-git-send-email-tj@kernel.org>
 <1392929071-16555-1-git-send-email-tj@kernel.org>
 <32161.1392933605@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32161.1392933605@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 10:00:05PM +0000, David Howells wrote:
> Tejun Heo <tj@kernel.org> wrote:
> 
> > PREPARE_[DELAYED_]WORK() are being phased out.  They have few users
> > and a nasty surprise in terms of reentrancy guarantee as workqueue
> > considers work items to be different if they don't have the same work
> > function.
> 
> Why so?  Isn't the work item address sufficient to distinguish them?

Because we ended up introducing deadlocks through work items which are
freed and then recycled.

Thanks.

-- 
tejun

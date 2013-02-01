Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab3BASAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 13:00:38 -0500
Received: from mail-qe0-f44.google.com ([209.85.128.44]:44804 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab3BASAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 13:00:34 -0500
Date: Fri, 1 Feb 2013 10:00:28 -0800
From: Tejun Heo <tj@kernel.org>
To: David Teigland <teigland@redhat.com>
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org,
        Christine Caulfield <ccaulfie@redhat.com>, cluster-devel@redhat.com
Subject: Re: [PATCH 10/14] dlm: don't use idr_remove_all()
Message-ID: <20130201180028.GC31863@mtj.dyndns.org>
References: <1359163872-1949-1-git-send-email-tj@kernel.org>
 <1359163872-1949-11-git-send-email-tj@kernel.org>
 <20130128155723.GC16789@redhat.com>
 <20130129151317.GA11609@redhat.com>
 <20130130212417.GJ24014@redhat.com>
 <20130131235320.GN6824@mtj.dyndns.org>
 <20130201001841.GP6824@mtj.dyndns.org>
 <20130201174443.GC3812@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130201174443.GC3812@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, David.

On Fri, Feb 01, 2013 at 12:44:43PM -0500, David Teigland wrote:
> I already tried my own version of this, but used idr_for_each_entry a
> second time.  Unfortunately, the number it found and printed did not match
> recover_list_count.
> 
> warning: recover_list_count 566
> 
> It printed 304 ids:

Heh, that's really weird.  Maybe idr_get_next() is buggy above certain
number or at certain boundaries?  If you find something, please let me
know.  I'll see if I can reproduce it in some minimal way.

Thanks!

-- 
tejun

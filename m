Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576AbaDXR1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 13:27:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56423 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbaDXR1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 13:27:11 -0400
Date: Thu, 24 Apr 2014 18:27:08 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: fs: dcookie: freeing active timer
Message-ID: <20140424172708.GY18016@ZenIV.linux.org.uk>
References: <53594244.6070305@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53594244.6070305@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 12:56:36PM -0400, Sasha Levin wrote:
> Hi all,
> 
> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel I've stumbled on the following:

> [  191.871535] kmem_cache_destroy (mm/slab_common.c:363)
> [  191.871535] dcookie_unregister (fs/dcookies.c:302 fs/dcookies.c:343)

So it's dcookie_exit() doing kmem_cache_destroy(dcookie_cache) while
some timer is active?

Why does that code bother with destroying/creating that sucker dynamically?
Is there any point at all?

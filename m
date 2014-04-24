Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475AbaDXV4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 17:56:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56931 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbaDXV4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:56:01 -0400
Date: Thu, 24 Apr 2014 22:55:58 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: fs: dcookie: freeing active timer
Message-ID: <20140424215558.GZ18016@ZenIV.linux.org.uk>
References: <53594244.6070305@oracle.com>
 <20140424172708.GY18016@ZenIV.linux.org.uk>
 <53594B16.4000901@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53594B16.4000901@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 01:34:14PM -0400, Sasha Levin wrote:

> > Why does that code bother with destroying/creating that sucker dynamically?
> > Is there any point at all?
> 
> I'm not sure about the dynamic allocation part, but I fear that if we just
> switch to using static allocations it'll hide the underlying issue that
> triggered this bug instead of fixing it.

FWIW, slub.c variant of kmem_cache_destroy() is buggered - struct kobject
embedded into struct kmem_cache, its ktype is slab_ktype, which has
NULL ->release()...

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbaBSWHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 17:07:53 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:41588 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106AbaBSWHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 17:07:52 -0500
Date: Wed, 19 Feb 2014 14:07:50 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH] Set bounds on what /proc/self/make-it-fail accepts.
In-Reply-To: <20140219140021.f187b2cdc396dab44e680078@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1402191406140.31921@chino.kir.corp.google.com>
References: <20140218220606.GA9712@redhat.com> <20140219134025.fcd70941e1ec98723a1bd230@linux-foundation.org> <20140219215505.GA28876@redhat.com> <20140219140021.f187b2cdc396dab44e680078@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Feb 2014, Andrew Morton wrote:

> If we're touching the task_struct we could make it a bool.
> 
> Or just a single bit(field).  task_struct already has a bunch of
> bitfields in it (strangely, they aren't contiguous).  But some locking
> would be needed if tasks-other-than-current can modify the bit.
> 

Or store to any adjacent bit in the word.  I think the simplest solution 
is to use kstrtoint() and test for val == !!val since, as we all know, 
{simple,strict}_strto* is deprecated per checkpatch :)

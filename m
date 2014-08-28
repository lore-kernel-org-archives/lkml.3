Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607AbaH1Pbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 11:31:31 -0400
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:46505
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751090AbaH1Pb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 11:31:29 -0400
Date: Thu, 28 Aug 2014 10:31:26 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Sasha Levin <sasha.levin@oracle.com>
cc: Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "davej @gmail-imap.l.google.com>> Dave Jones" <davej@redhat.com>
Subject: Re: mm: slub: circular dependency between slab_mutex and
 cpu_hotplug
In-Reply-To: <53FF4280.1040402@oracle.com>
Message-ID: <alpine.DEB.2.11.1408281030510.6401@gentwo.org>
References: <53FF4280.1040402@oracle.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2014, Sasha Levin wrote:

> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel, I've stumbled on the following spew:

This looks to me more to be a cpu hotplug issue.
>
> [ 7841.323177]  Possible unsafe locking scenario:
> [ 7841.323177]
> [ 7841.323177]        CPU0                    CPU1
> [ 7841.323177]        ----                    ----
> [ 7841.323177]   lock(cpu_hotplug.lock#2);
> [ 7841.323177]                                lock((oom_notify_list).rwsem);
> [ 7841.323177]                                lock(cpu_hotplug.lock#2);
> [ 7841.323177]   lock(slab_mutex);

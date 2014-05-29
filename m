Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581AbaE2GAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 02:00:00 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:59032 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaE2F77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 01:59:59 -0400
Date: Thu, 29 May 2014 09:59:54 +0400
From: Vasily Kulikov <segoon@openwall.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        containers@lists.linux-foundation.org,
        Serge Hallyn <serge.hallyn@ubuntu.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2] /proc/pid/status: show all sets of pid according to ns
Message-ID: <20140529055954.GA10354@cachalot>
References: <1401272683-1659-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <5385DA19.2060008@parallels.com>
 <20140528182824.GA5057@cachalot>
 <53863889.9080509@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53863889.9080509@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 23:27 +0400, Pavel Emelyanov wrote:
> On 05/28/2014 10:28 PM, Vasily Kulikov wrote:
> > On Wed, May 28, 2014 at 16:44 +0400, Pavel Emelyanov wrote:
> > It will be simplier
> > to parse the file -- if 'ns_ids' file contains some ID then this ID for
> > every ns can be obtained regardless of the specific ID name (SID, PID,
> > PGID, etc.).
> 
> True, but given a task PID how to determine which pid namespaces it lives in
> to get the idea of how PIDs map to each other? Maybe we need some explicit
> API for converting (ID, NS1, NS2) into (ID)?

AFAIU the idea of the patch is to add a new debugging information which
can be trivially obtained via 'cat /proc/...':

] We need a direct method of getting the pid inside containers.
] If some issues occurred inside container guest, host user
] could not know which process is in trouble just by guest pid:
] the users of container guest only knew the pid inside containers.
] This will bring obstacle for trouble shooting.

A new syscall might complicate trouble shooting by admin.

-- 
Vasily Kulikov
http://www.openwall.com - bringing security into open computing environments

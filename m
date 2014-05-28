Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111AbaE1S2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 14:28:31 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:58949 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbaE1S2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 14:28:30 -0400
Date: Wed, 28 May 2014 22:28:24 +0400
From: Vasily Kulikov <segoon@openwall.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        containers@lists.linux-foundation.org,
        Serge Hallyn <serge.hallyn@ubuntu.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2] /proc/pid/status: show all sets of pid according to ns
Message-ID: <20140528182824.GA5057@cachalot>
References: <1401272683-1659-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <5385DA19.2060008@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5385DA19.2060008@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 16:44 +0400, Pavel Emelyanov wrote:
> On 05/28/2014 02:24 PM, Chen Hanxiao wrote:
> > We need a direct method of getting the pid inside containers.
> 
> But there's more generic issue -- some day we'll need to know not only
> PIDs as seen from different namespaces, but also SIDs and PGIDs.

Maybe include all per-ns ID in a separate file?  Then the old 'status'
file includes IDs from the current namespace only, the new file (e.g.
'ids' or 'ns_ids') contains only hierarchical IDs which differ from
namespace to namespace for all possible namespaces.  It will be simplier
to parse the file -- if 'ns_ids' file contains some ID then this ID for
every ns can be obtained regardless of the specific ID name (SID, PID,
PGID, etc.).

> 
> > If some issues occurred inside container guest, host user
> > could not know which process is in trouble just by guest pid:
> > the users of container guest only knew the pid inside containers.
> > This will bring obstacle for trouble shooting.
> > 
> > This patch adds two fields:
> > 
> > NStgid and NSpid.
> > 
> > a) In init_pid_ns, nothing changed;
> > 
> > b) In one pidns, will tell the pid inside containers:
> > NStgid:	1628 	9 	3
> > NSpid:	1628 	9 	3
> > ** Process id is 1628 in level 0, 9 in level 1, 3 in level 2.
> > 
> > c) If pidns is nested, it depends on which pidns are you in.
> > NStgid:	9 	3
> > NSpid:	9 	3
> > ** Views from level 1

Thanks,

-- 
Vasily Kulikov
http://www.openwall.com - bringing security into open computing environments

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbaE1T1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 15:27:31 -0400
Received: from relay.parallels.com ([195.214.232.42]:57636 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaE1T13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 15:27:29 -0400
Message-ID: <53863889.9080509@parallels.com>
Date: Wed, 28 May 2014 23:27:05 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Vasily Kulikov <segoon@openwall.com>
CC: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        <containers@lists.linux-foundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, <linux-kernel@vger.kernel.org>,
        "Oleg Nesterov" <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2] /proc/pid/status: show all sets of pid according to
 ns
References: <1401272683-1659-1-git-send-email-chenhanxiao@cn.fujitsu.com> <5385DA19.2060008@parallels.com> <20140528182824.GA5057@cachalot>
In-Reply-To: <20140528182824.GA5057@cachalot>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [89.169.95.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 10:28 PM, Vasily Kulikov wrote:
> On Wed, May 28, 2014 at 16:44 +0400, Pavel Emelyanov wrote:
>> On 05/28/2014 02:24 PM, Chen Hanxiao wrote:
>>> We need a direct method of getting the pid inside containers.
>>
>> But there's more generic issue -- some day we'll need to know not only
>> PIDs as seen from different namespaces, but also SIDs and PGIDs.
> 
> Maybe include all per-ns ID in a separate file?

This looks reasonable, but wouldn't this file be too big for a loaded system?

> Then the old 'status'
> file includes IDs from the current namespace only, the new file (e.g.
> 'ids' or 'ns_ids') contains only hierarchical IDs which differ from
> namespace to namespace for all possible namespaces.  

For all visible namespaces. I.e. -- if a task lives in a container and reads
its /proc/self/status it should _not_ see its host pid. Just like it is now
in the current patch. Otherwise it would bring blockers to live migration :(

> It will be simplier
> to parse the file -- if 'ns_ids' file contains some ID then this ID for
> every ns can be obtained regardless of the specific ID name (SID, PID,
> PGID, etc.).

True, but given a task PID how to determine which pid namespaces it lives in
to get the idea of how PIDs map to each other? Maybe we need some explicit
API for converting (ID, NS1, NS2) into (ID)?

Thanks,
Pavel

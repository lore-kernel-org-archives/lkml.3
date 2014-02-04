Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936314AbaBDWsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:48:39 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:37567 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576AbaBDWsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 17:48:32 -0500
Message-ID: <1391554110.10160.3.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] fdtable: Avoid triggering OOMs from alloc_fdmem
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, David Rientjes <rientjes@google.com>
Date: Tue, 04 Feb 2014 14:48:30 -0800
In-Reply-To: <87r47ik8ou.fsf@xmission.com>
References: <87r47jsb2p.fsf@xmission.com>
	 <1391530721.4301.8.camel@edumazet-glaptop2.roam.corp.google.com>
	 <871tzirdwf.fsf@xmission.com>
	 <1391539464.10160.1.camel@edumazet-glaptop2.roam.corp.google.com>
	 <87r47ik8ou.fsf@xmission.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-04 at 10:57 -0800, Eric W. Biederman wrote:

> As I have heard it described one tcp connection per small requestion,
> and someone goofed and started creating new connections when the server
> was bogged down.  But since all of the requests and replies were small I
> don't expect even TCP would allocate more than a 4KiB page in that
> worload.

Right, small writes uses regular skb (no page fragments).

> 
> I had oodles of 4KiB and 8KiB pages.  What size of memory allocation did
> you see failing?  

We got some reports of order-3 allocations failing.



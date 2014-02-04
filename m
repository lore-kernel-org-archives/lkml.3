Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213AbaBDSo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 13:44:28 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:40185 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbaBDSoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 13:44:25 -0500
Message-ID: <1391539464.10160.1.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] fdtable: Avoid triggering OOMs from alloc_fdmem
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, David Rientjes <rientjes@google.com>
Date: Tue, 04 Feb 2014 10:44:24 -0800
In-Reply-To: <871tzirdwf.fsf@xmission.com>
References: <87r47jsb2p.fsf@xmission.com>
	 <1391530721.4301.8.camel@edumazet-glaptop2.roam.corp.google.com>
	 <871tzirdwf.fsf@xmission.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-04 at 09:22 -0800, Eric W. Biederman wrote:

> The two code paths below certainly look good canidates for having
> __GFP_NORETRY added to them.  The same issues I ran into with
> alloc_fdmem are likely to show up there as well.

Yes, this is what I thought : a write into TCP socket should be more
frequent than the alloc_fdmem() case ;)

But then, maybe your workload was only using UDP ?



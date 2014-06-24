Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaFXXoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 19:44:05 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:38029 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbaFXXoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 19:44:03 -0400
Date: Tue, 24 Jun 2014 16:44:00 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Stefan Bader <stefan.bader@canonical.com>
cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: fs/stat: Reduce memory requirements for stat_open
In-Reply-To: <5399B301.9030108@canonical.com>
Message-ID: <alpine.DEB.2.02.1406241642280.22030@chino.kir.corp.google.com>
References: <1402578017-16637-1-git-send-email-stefan.bader@canonical.com> <20140612134149.GC4296@osiris> <5399B301.9030108@canonical.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2014, Stefan Bader wrote:

> doh, so you guys have been hit by that before. And I have missed the fact that
> single_open is special. Which makes the change for the upper limit do the wrong
> thing. While long-term it sounds like changing it to vmalloc or iterative reads
> sounds better, maybe the change from possible to online cpus might be something
> that is better acceptable as a quick fix... Not sure. At least this giving back
> a bit of attention to the matter and it is not only affecting zSeries. x86
> starts to see hw that requires a similar high possible cpus... :)
> 

Heiko's patches that should fix this problem are now in -mm, so it would 
be nice to know if there are any existing issues that haven't been 
addressed yet with your bug report.  See 
http://www.ozlabs.org/~akpm/mmotm/

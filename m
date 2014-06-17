Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967744AbaFQWhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:37:05 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:47867 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966209AbaFQWhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 18:37:02 -0400
Date: Tue, 17 Jun 2014 15:37:00 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: werner <w.landgraf@ru.ru>
cc: linux-kernel@vger.kernel.org
Subject: Re: 3.16-rc1 problems vdso_addr , _mb_cache_entry_ , rtl8723au
In-Reply-To: <web-91666686@zbackend1.aha.ru>
Message-ID: <alpine.DEB.2.02.1406171530420.517@chino.kir.corp.google.com>
References: <web-91666686@zbackend1.aha.ru>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2014, werner wrote:

> Different to 3.15 , now for 3.16-rc1 the compiling list have warnings of any
> incompatibility for all subroutines
> 
> and it don't build, because problems in vdso_addr  and _mb_cache_entry_    The
> last is a problem occuring already in 3.15
> 
> also subroutine  rtl8723au  don't compile
> 

It's probably not a good idea to just post a collection of build errors in 
one email that isn't cc'd to anyone in particular and expect the issues to 
be addressed.

 - The staging errors should be reported directly to the people 
   responsible for those drivers, check git-blame for who to email: not
   everything in staging is guaranteed to compile at any time, it's very
   fluid.

 - The __builtin_log2() problem should be fixed with "fs/mbcache.c: 
   replacing __builtin_log2() with ilog2()" that was written specifically
   due to your previous error report, see 
   http://marc.info/?t=140147146600003

 - I can't reproduce your align_vdso_addr() problem, please send your 
   .config

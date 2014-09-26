Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbaIZNYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 09:24:50 -0400
Received: from ozlabs.org ([103.22.144.67]:34758 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008AbaIZNYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 09:24:49 -0400
Date: Fri, 26 Sep 2014 23:24:47 +1000
From: Anton Blanchard <anton@samba.org>
To: Michael Neuling <mikey@neuling.org>
Cc: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, imunsie@au.ibm.com,
        cbe-oss-dev@lists.ozlabs.org
Subject: Re: [PATCH 10/15] powerpc/mm: Add hooks for cxl
Message-ID: <20140926232447.30bdcddb@kryten>
In-Reply-To: <1411731209.1733.51.camel@ale.ozlabs.ibm.com>
References: <1411028820-29933-1-git-send-email-mikey@neuling.org>
	<1411028820-29933-11-git-send-email-mikey@neuling.org>
	<20140926143309.33c0eeac@kryten>
	<1411731209.1733.51.camel@ale.ozlabs.ibm.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Mikey,

> We only map what a user processes maps and we tear it down when the
> process is teared down (on the file descriptor release).  So I think
> we are ok.  
> 
> Unless there's some lazy teardown you're alluding to that I'm missing?

I was trying to make sure things like the TLB batching code won't allow
a tlbie to be postponed until after a CAPI mapping is destroyed. It's
been ages since I looked at that part of the mm code.

Anton

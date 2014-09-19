Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbaISEp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 00:45:58 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:14742 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750739AbaISEp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 00:45:56 -0400
X-IronPort-AV: E=Sophos;i="5.04,552,1406584800"; 
   d="scan'208";a="96533581"
Date: Fri, 19 Sep 2014 06:45:51 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: "Drokin, Oleg" <oleg.drokin@intel.com>
cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "<devel@driverdev.osuosl.org>" <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "<kernel-janitors@vger.kernel.org>" <kernel-janitors@vger.kernel.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        "<HPDD-discuss@ml01.01.org>" <HPDD-discuss@ml01.01.org>
Subject: Re: [HPDD-discuss] [PATCH] staging: lustre: llite: Use kzalloc and
 rewrite null tests
In-Reply-To: <517B3353-BD3C-4326-A8F4-F1775B4865E5@intel.com>
Message-ID: <alpine.DEB.2.10.1409190637190.2507@hadrien>
References: <1411071842-24714-1-git-send-email-Julia.Lawall@lip6.fr> <1411071842-24714-2-git-send-email-Julia.Lawall@lip6.fr> <20140918234309.GP17875@mwanda> <E43F4FD2-3A79-485E-960B-A12960B3D2B7@intel.com> <517B3353-BD3C-4326-A8F4-F1775B4865E5@intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With respect to the upper case lower case issue, does the thing need to be
a macro?  I think that the lowercase is more or less fine, but only if
what is behind it is a function.

I say more or less fine, because normally in the kernel the special
allocators have special purposes, eg allocating and initializing the xyz
structure.  Here what is wanted is a general purpose allocator with lots
of special tracing features, so it is not quite the same thing.  And one
can wonder why all of these special tracing features are not relevant to
the kernel as a whole?

In reading through the description of the needed features, it seems like
only the _ptr extension requires being a macro.  Do we need that?  The
rest of the kernel manages to do x = kzalloc(sizeof(*x),...) ok.  It's
unpleasant to have an assignment hidden in this way.  And currently it is
not used consistently.  There are some OBD_ALLOCs that have the same form.

Sorry for overlooking the frees.  I was focusing on trying one thing at a
time...

julia

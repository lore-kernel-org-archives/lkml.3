Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaISJMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 05:12:23 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:45957 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaISJMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 05:12:22 -0400
Date: Fri, 19 Sep 2014 12:11:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Drokin, Oleg" <oleg.drokin@intel.com>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        "<devel@driverdev.osuosl.org>" <devel@driverdev.osuosl.org>,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "<kernel-janitors@vger.kernel.org>" <kernel-janitors@vger.kernel.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<HPDD-discuss@ml01.01.org>" <HPDD-discuss@ml01.01.org>
Subject: Re: [PATCH] staging: lustre: llite: Use kzalloc and rewrite null
 tests
Message-ID: <20140919091151.GQ17875@mwanda>
References: <1411071842-24714-1-git-send-email-Julia.Lawall@lip6.fr>
 <1411071842-24714-2-git-send-email-Julia.Lawall@lip6.fr>
 <20140918234309.GP17875@mwanda>
 <E43F4FD2-3A79-485E-960B-A12960B3D2B7@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E43F4FD2-3A79-485E-960B-A12960B3D2B7@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 02:57:03AM +0000, Drokin, Oleg wrote:
> 4. Sometimes we need large allocations. general kmalloc is less
> reliable as system lives on and memory fragmentation worsens. So we
> have this "allocations over 2-4 pages get switched to vmalloc" logic,
> if there's a way to do that automatically - that would be great.

Julia's patch only changes OBD_ALLOC() functions and those are always
kmalloc so that's not an issue here.

The OBD_ALLOC_LARGE() macro is vmalloc() or kmalloc() if the size is
small enough.  We don't really want to choose between kmalloc and
vmalloc automatically.  My instinct is that we should change all the
OBD_ALLOC_LARGE() to vmalloc() and trust it to allocate them in the most
sane way possible.  But I haven't really looked very closely.

regards,
dan carpenter


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab3JIQa6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 12:30:58 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:47483 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab3JIQa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 12:30:56 -0400
Date: Wed, 9 Oct 2013 12:30:53 -0400
From: Tejun Heo <tj@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>,
        Sangjung Woo <sangjung.woo@samsung.com>
Subject: Re: [RFC PATCH] device: Add kernel standard devm_k.alloc functions
Message-ID: <20131009163053.GF22495@htj.dyndns.org>
References: <1381296747.2040.17.camel@joe-AO722>
 <20131009054335.GA3525@kroah.com>
 <1381299404.2040.19.camel@joe-AO722>
 <20131009065404.GA7005@kroah.com>
 <1381302282.2050.1.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381302282.2050.1.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Oct 09, 2013 at 12:04:42AM -0700, Joe Perches wrote:
> > > > > 	devm_kzalloc
> > > > > 	devm_kcalloc
> > > > > 	devm_kmalloc_array
> > > > > 
> > > > > Add gfp.h to device.h for the newly added static inlines.
...
> Unless Tejun has an objection soon, yes.

Do we really need devm_kmalloc_array() for devm interface?  The
reasonsing behind only having kzalloc was that it's not worthwhile
skipping zeroing for stuff happening during driver init/exit paths.
The resource management overhead itself is already significant and
unscalable compared to the raw cost of alloc/free and the interface
isn't supposed to be used in super-hot paths.  Shouldn't
devm_kzalloc() and devm_kcalloc() be enough?

Thanks.

-- 
tejun

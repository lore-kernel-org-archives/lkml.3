Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbaCQWVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 18:21:14 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:43900 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbaCQWVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 18:21:12 -0400
Date: Mon, 17 Mar 2014 18:21:07 -0400
From: Tejun Heo <tj@kernel.org>
To: Greg KH <greg@kroah.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Mark Brown <broonie@kernel.org>,
        Stewart Smith <stewart@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-ID: <20140317222107.GH17373@mtj.dyndns.org>
References: <20140312005152.9ac4063f65dbd233f5d50b4d@kernel.org>
 <20140312015021.GC10106@kroah.com>
 <20140317101611.d043a90e1cb72dcfb8bc767a@canb.auug.org.au>
 <20140317183333.GE10565@kroah.com>
 <1395088410.15098.175.camel@pasglop>
 <20140317215619.GA25228@kroah.com>
 <20140317220554.GG17373@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140317220554.GG17373@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 06:05:54PM -0400, Tejun Heo wrote:
> I think this is being blown out of proportion.  It was a rarely used
> API and converting to the new one is mostly trivial which can be

So, looked at the failed code.  The only necessary change seems to be
calling device_remove_file_self() in dump_ack_store() and then doing
kobject_put() directly afterwards, which would have been completely
fine as a merge fix patch.

Just to be clear, I'm not necessarily against reverting the removal of
the API.  The removal was based on the speculation that this isn't
likely to cause trouble.  The speculation was perfectly reasonable but
being a speculation it failed, so we take actions to remedy that and
we *do* want to do things that way.  Reverting the removal can sure be
one choice but the way that choice is being made here seems completely
wrong to me.  There's no technical evaluation whatsoever.  I'd really
hate to work in an environment where taking active trade off is
discouraged replaced with blind policy enforcement.

Thanks.

-- 
tejun

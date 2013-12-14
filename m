Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab3LNUg4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 15:36:56 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:33672 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab3LNUgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 15:36:55 -0500
Date: Sat, 14 Dec 2013 15:36:52 -0500
From: Tejun Heo <tj@kernel.org>
To: Nigel Cunningham <nigel@nigelcunningham.com.au>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jens Axboe <axboe@kernel.dk>, tomaz.solc@tablix.org,
        aaron.lu@intel.com, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] libata, freezer: avoid block device removal while system
 is frozen
Message-ID: <20131214203652.GC4020@htj.dyndns.org>
References: <20131213174932.GA27070@htj.dyndns.org>
 <20131213185237.GD27070@htj.dyndns.org>
 <20131213204034.GE27070@htj.dyndns.org>
 <52AB8E27.90308@nigelcunningham.com.au>
 <20131213230744.GA17954@htj.dyndns.org>
 <52AB9509.1080004@nigelcunningham.com.au>
 <20131214203121.GB4020@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131214203121.GB4020@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 03:31:21PM -0500, Tejun Heo wrote:
> So, all this is about hibernation?  Does that mean that it's safe to
> unfreeze before invoking resume?  ie. we currently do,
> 
> 	freeze
> 	suspend devs
> 	resume devs
> 	unfreeze
> 
> If we can just do,
> 
> 	freeze
> 	suspend devs
> 	unfreeze
> 	resume devs

Ummm... even better, does that mean, in the long term, we can decouple
freezing and device pm operations?  If this is just about hibernation,
there's no reason to wrap device driver pm ops with freezer, right?

Thanks.

-- 
tejun

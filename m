Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab3LNUb0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 15:31:26 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:40438 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab3LNUbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 15:31:25 -0500
Date: Sat, 14 Dec 2013 15:31:21 -0500
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
Message-ID: <20131214203121.GB4020@htj.dyndns.org>
References: <20131213174932.GA27070@htj.dyndns.org>
 <20131213185237.GD27070@htj.dyndns.org>
 <20131213204034.GE27070@htj.dyndns.org>
 <52AB8E27.90308@nigelcunningham.com.au>
 <20131213230744.GA17954@htj.dyndns.org>
 <52AB9509.1080004@nigelcunningham.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52AB9509.1080004@nigelcunningham.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Nigel.

On Sat, Dec 14, 2013 at 10:15:21AM +1100, Nigel Cunningham wrote:
> My understanding is that the point is ensuring that - particularly
> in the case of hibernation - we don't cause filesystem corruption by
> writing one thing while writing the image and then doing something
> else (without knowledge of what happened while the image was being
> written) while reading the image or after restoring it.

So, all this is about hibernation?  Does that mean that it's safe to
unfreeze before invoking resume?  ie. we currently do,

	freeze
	suspend devs
	resume devs
	unfreeze

If we can just do,

	freeze
	suspend devs
	unfreeze
	resume devs

it should be a lot better and would remove all locking dependency
chains in the resume path.

Thanks.

-- 
tejun

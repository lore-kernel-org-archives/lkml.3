Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab3LMWxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:53:15 -0500
Received: from nigelcunningham.com.au ([178.79.133.97]:51928 "EHLO
	nigelcunningham.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab3LMWxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:53:14 -0500
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Dec 2013 17:53:14 EST
Message-ID: <52AB8E27.90308@nigelcunningham.com.au>
Date: Sat, 14 Dec 2013 09:45:59 +1100
From: Nigel Cunningham <nigel@nigelcunningham.com.au>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jens Axboe <axboe@kernel.dk>
CC: tomaz.solc@tablix.org, aaron.lu@intel.com, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] libata, freezer: avoid block device removal while system
 is frozen
References: <20131213174932.GA27070@htj.dyndns.org> <20131213185237.GD27070@htj.dyndns.org> <20131213204034.GE27070@htj.dyndns.org>
In-Reply-To: <20131213204034.GE27070@htj.dyndns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun.

Thanks for your work on this.

In your first email, in the first substantial paragraph (starting "Now, 
if the rest.."), you say "libata device removal waits for the scheduled 
writeback work item to finish". I wonder if that's the lynchpin. If we 
know the device is gone, why are we trying to write to it?

All pending I/O should have been flushed when suspend/hibernate started, 
and there's no point in trying to update metadata on a device we can't 
access, so there should be no writeback needed (and anything that does 
somehow get there should just be discarded since it will never succeed 
anyway).

Or am I missing something?

Having said the above, I agree that we shouldn't need to freeze kernel 
threads and workqueues themselves. I think we should be giving the 
producers of I/O the nous needed to avoid producing I/O during 
suspend/hibernate. But perhaps I'm missing something here, too.

Regards,

Nigel

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbaHHEnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 00:43:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50970 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbaHHEnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 00:43:18 -0400
Date: Thu, 7 Aug 2014 21:42:46 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: Evgeny Budilovsky <budevg@gmail.com>, devel@driverdev.osuosl.org,
        Andreas Dilger <andreas.dilger@intel.com>,
        Peng Tao <bergwolf@gmail.com>, linux-kernel@vger.kernel.org,
        Lai Siyao <lai.siyao@intel.com>
Subject: Re: [PATCH] staging/lustre: use rcu_dereference to access rcu
 protected current->real_parent field
Message-ID: <20140808044246.GA3084@kroah.com>
References: <87k36ltoob.fsf@gmail.com>
 <20140806214216.GA16530@kroah.com>
 <CAGDhxoe4+jU=vCDedMC4VXfuNMmqP3-E1Lu3LLStbFLbd=BRSA@mail.gmail.com>
 <20140808034951.GA6626@kroah.com>
 <DFF36154-06AC-4D7E-87F5-259B73CB059B@linuxhacker.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DFF36154-06AC-4D7E-87F5-259B73CB059B@linuxhacker.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 12:03:20AM -0400, Oleg Drokin wrote:
> Hello!
> 
> On Aug 7, 2014, at 11:49 PM, Greg Kroah-Hartman wrote:
> >> 
> >> This is not a critical bug and in the worst case the code here may
> >> cause miss of statistics counter increase.
> >> This is why I think it is not worth to backport the patch at all.
> > You are right, and if this is just for some random "statistics" file,
> > can we just delete the whole function?
> 
> I hope not!
> This is used all around the client to tally up various operations executed counts.

Why would you do that?  Why would they care?

> The statistic is then used by various userspace monitoring tools.

Why not use the in-kernel monitoring tools instead of creating your own?
What does userspace do with that information?

thanks,

greg k-h

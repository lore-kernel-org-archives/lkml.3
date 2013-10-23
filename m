Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab3JWM5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 08:57:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37641 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110Ab3JWM5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 08:57:31 -0400
Date: Wed, 23 Oct 2013 12:59:31 +0200
From: Jan Kara <jack@suse.cz>
To: =?utf-8?B?6Z+p56OK?= <bonben1989@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: A thought about IO scheduler in linux kernel for SSD
Message-ID: <20131023105931.GG1275@quack.suse.cz>
References: <CAK2Ky6xH9rvmpqQ31bi1QrC=dvt9T_8+ELHUZf_MFZccV6MiAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK2Ky6xH9rvmpqQ31bi1QrC=dvt9T_8+ELHUZf_MFZccV6MiAw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 23-10-13 08:47:44, 韩磊 wrote:
> Nowadays,the IO schedulers in linux kernel have four types:
> 
> deadline,noop,Anticiptory and CFQ.CFQ is the default scheduler.But CFQ is
> not a good scheduler for SSD,dealine may be a good choice.

> When deadline runs,it has a mount of computation about merging and
> sorting.Merge has three types: front_merge,no_merge and back_merge.
> Why don't have  another type: merge based same sector.For example,it have
> two bios in a request list,theyboth have the same bi->sector,the bi->size
> maybe not equal. Whether can we put the latter bio replace the former?What
> do you find that significant?Or the other levels in OS has finished this
> function?
  That doesn't make much sense to me. If there are two bios in flight for
some sector, results are undefined. Thus we usually avoid such situation
(usually we want to have defined contents of the disk :). The exclusion is
usually achieved at higher level using page locking etc. So adding code
speeding up such requests doesn't seem worth it.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

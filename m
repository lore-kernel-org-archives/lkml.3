Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab3KAO0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 10:26:07 -0400
Received: from relay.parallels.com ([195.214.232.42]:45718 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab3KAO0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 10:26:05 -0400
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
To: karl.kiniger@med.ge.com
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: jack@suse.cz, linux-kernel@vger.kernel.org, t.artem@lycos.com,
        mgorman@suse.de, tytso@mit.edu, akpm@linux-foundation.org,
        fengguang.wu@intel.com, torvalds@linux-foundation.org,
        mpatlasov@parallels.com
Date: Fri, 01 Nov 2013 18:25:56 +0400
Message-ID: <20131101142426.1065.25534.stgit@dhcp-10-30-17-2.sw.ru>
In-Reply-To: <20131031142612.GA28003@kipc2.localdomain>
References: <20131031142612.GA28003@kipc2.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 31-10-13 14:26:12, Karl Kiniger wrote:
> On Tue 131029, Jan Kara wrote:
> > On Fri 25-10-13 11:15:55, Karl Kiniger wrote:
> > > On Fri 131025, Linus Torvalds wrote:
> ....
> > > Is it currently possible to somehow set above values per block device?
> >   Yes, to some extent. You can set /sys/block/<device>/bdi/max_ratio to
> > the maximum proportion the device's dirty data can take from the total
> > amount. The caveat currently is that this setting only takes effect after
> > we have more than (dirty_background_ratio + dirty_ratio)/2 dirty data in
> > total because that is an amount of dirty data when we start to throttle
> > processes. So if the device you'd like to limit is the only one which is
> > currently written to, the limiting doesn't have a big effect.
>
> Thanks for the info - thats was I am looking for.
>
> You are right that the limiting doesn't have a big effect right now:
>
> on my  4x speed  DVD+RW on /dev/sr0, x86_64, 4GB,
> Fedora19:
>
> max_ratio set to 100  - about 500MB buffered, sync time 2:10 min.
> max_ratio set to 1    - about 330MB buffered, sync time 1:23 min.
>
> ... way too much buffering.

"strictlimit" feature must fit your and Artem's needs quite well. The feature
enforces per-BDI dirty limits even if the global dirty limit is not reached
yet. I'll send a patch adding knob to turn it on/off.

Thanks,
Maxim

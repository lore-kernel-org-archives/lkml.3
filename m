Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab3JaOZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 10:25:51 -0400
Received: from exprod5og118.obsmtp.com ([64.18.0.160]:58538 "EHLO
	exprod5og118.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961Ab3JaOZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 10:25:49 -0400
Date: Thu, 31 Oct 2013 15:26:12 +0100
From: Karl Kiniger <karl.kiniger@med.ge.com>
To: Jan Kara <jack@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Artem S. Tashkinov" <t.artem@lycos.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
Message-ID: <20131031142612.GA28003@kipc2.localdomain>
References: <160824051.3072.1382685914055.JavaMail.mail@webmail07>
 <CA+55aFxj81TRhe1+FJWqER7VVH_z_Sk0+hwtHvniA0ATsF_eKw@mail.gmail.com>
 <1814253454.3449.1382689853825.JavaMail.mail@webmail07>
 <CA+55aFxhJUrqdvw1To=9KLdxhYAOVwZLLeJT5yMRY5BT1weuHA@mail.gmail.com>
 <20131025091555.GA30895@kipc2.localdomain>
 <20131029203050.GE9568@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029203050.GE9568@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-GEHealthcare-MailScanner: Found to be clean
X-GEHealthcare-MailScanner-From: karl.kiniger@med.ge.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 131029, Jan Kara wrote:
> On Fri 25-10-13 11:15:55, Karl Kiniger wrote:
> > On Fri 131025, Linus Torvalds wrote:
.... 
> > Is it currently possible to somehow set above values per block device?
>   Yes, to some extent. You can set /sys/block/<device>/bdi/max_ratio to
> the maximum proportion the device's dirty data can take from the total
> amount. The caveat currently is that this setting only takes effect after
> we have more than (dirty_background_ratio + dirty_ratio)/2 dirty data in
> total because that is an amount of dirty data when we start to throttle
> processes. So if the device you'd like to limit is the only one which is
> currently written to, the limiting doesn't have a big effect.

Thanks for the info - thats was I am looking for.

You are right that the limiting doesn't have a big effect right now:

on my  4x speed  DVD+RW on /dev/sr0, x86_64, 4GB,
Fedora19:

max_ratio set to 100  - about 500MB buffered, sync time 2:10 min.
max_ratio set to 1    - about 330MB buffered, sync time 1:23 min.

... way too much buffering.

(measured with strace -tt -ewrite dd if=/dev/zero of=bigfile bs=1M count=1000
by looking at the timestamps).


Karl

....
								Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR


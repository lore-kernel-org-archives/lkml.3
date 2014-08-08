Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbaHHDu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 23:50:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50704 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330AbaHHDuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 23:50:23 -0400
Date: Thu, 7 Aug 2014 20:49:51 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Evgeny Budilovsky <budevg@gmail.com>
Cc: devel@driverdev.osuosl.org, Andreas Dilger <andreas.dilger@intel.com>,
        Peng Tao <bergwolf@gmail.com>, linux-kernel@vger.kernel.org,
        Oleg Drokin <green@linuxhacker.ru>, Lai Siyao <lai.siyao@intel.com>
Subject: Re: [PATCH] staging/lustre: use rcu_dereference to access rcu
 protected current->real_parent field
Message-ID: <20140808034951.GA6626@kroah.com>
References: <87k36ltoob.fsf@gmail.com>
 <20140806214216.GA16530@kroah.com>
 <CAGDhxoe4+jU=vCDedMC4VXfuNMmqP3-E1Lu3LLStbFLbd=BRSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGDhxoe4+jU=vCDedMC4VXfuNMmqP3-E1Lu3LLStbFLbd=BRSA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 02:13:50PM +0300, Evgeny Budilovsky wrote:
> On Thu, Aug 7, 2014 at 12:42 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Wed, Aug 06, 2014 at 09:22:43PM +0300, Evgeny Budilovsky wrote:
> >>
> >>
> >> Signed-off-by: Evgeny Budilovsky <budevg@gmail.com>
> >
> > Why is this needed?  Is the current code a bug?  Where was the reference
> > added?  Is this causing a problem without this patch applied?  How far
> > back should it be backported, if at all?
> >
> > I need lots more details here before I can take this patch, sorry.
> 
> Sorry for the little information in the previous mail.
> 
> The motivation for this patch was to clean some of the warnings that
> were generated
> on drivers/staging by the sparse utility.
> 
> For this particular case the warning was
> staging/lustre/lustre/llite/lproc_llite.c:913:51: warning: dereference
> of noderef expression
> 
> And this is since current->real_parent is accessed directly and not
> trough the rcu_dereference,
> which is the common way to access it throughout the kernel.
> 
> This is not a critical bug and in the worst case the code here may
> cause miss of statistics counter increase.
> This is why I think it is not worth to backport the patch at all.

You are right, and if this is just for some random "statistics" file,
can we just delete the whole function?

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab3HZSSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 14:18:07 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:54443 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab3HZSSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 14:18:04 -0400
Date: Mon, 26 Aug 2013 14:18:00 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, linux-arch@vger.kernel.org,
        Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [guv 00/16] [RFC] percpu: Replace __get_cpu_var uses throughout
 the kernel
Message-ID: <20130826181800.GA25997@mtj.dyndns.org>
References: <00000140ac8debd6-6f9e64f9-1107-4336-91ef-77cdf764b96a-000000@email.amazonses.com>
 <20130823200514.GA11391@mtj.dyndns.org>
 <00000140bb37931e-fbfdfad2-8241-40cc-b053-7c53d54a9728-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000140bb37931e-fbfdfad2-8241-40cc-b053-7c53d54a9728-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Christoph.

On Mon, Aug 26, 2013 at 03:21:56PM +0000, Christoph Lameter wrote:
> On Fri, 23 Aug 2013, Tejun Heo wrote:
> 
> > * It would be a lot easier to route the patches if each had cc's to
> >   the maintainers of the affected subsystems.
> 
> So the drivers patch needs to CC all driver maintainers?

There usually is a maintainer for a whole lot of similar drivers - one
for infiniband, one for v4l and so on, so the list usually isn't that
long.

> There must be some easier way to get this done.

It can be consolidated and pushed as a single series either through
the percpu tree or -mm but it still at least needs to inform the
people working on the affected code and get the confirmations where
possible.

> Not sure how to do this. Thats why its an RFC. I cced Andrew because he
> usually knows how to deal with massive patches like this.

It can go two ways.

* Split further so that the patches can be merged through separate
  branches so that they converge on the next merge window where the
  leftovers can be taken care of and further dependent changes merged.

* Get acks from most maintainers and push the changes as a single
  series through either percpu tree or -mm.  The benefits of going
  through -mm is that -mm floats on top of all changes scheduled for
  the next merge window, so if the changes in question are likely to
  conflict with other changes in various subsystems scheduled for the
  next merge window, -mm is easier.  Given the nature of the changes,
  I don't think going through percpu or -mm would make much
  difference.

Thanks.

-- 
tejun

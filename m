Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab3JYIUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 04:20:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35642 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab3JYIUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 04:20:47 -0400
Date: Fri, 25 Oct 2013 10:20:43 +0200
From: Jan Kara <jack@suse.cz>
To: =?utf-8?B?6Z+p56OK?= <bonben1989@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: A thought about IO scheduler in linux kernel for SSD
Message-ID: <20131025082043.GA1418@quack.suse.cz>
References: <CAK2Ky6xH9rvmpqQ31bi1QrC=dvt9T_8+ELHUZf_MFZccV6MiAw@mail.gmail.com>
 <20131023105931.GG1275@quack.suse.cz>
 <CAK2Ky6xjz5htYdYp9rpfWt1fyK+3oc+i1nR9GWh_hyULpZ=QMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK2Ky6xjz5htYdYp9rpfWt1fyK+3oc+i1nR9GWh_hyULpZ=QMg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 25-10-13 11:10:22, 韩磊 wrote:
> 2013/10/23 Jan Kara <jack@suse.cz>:
> > On Wed 23-10-13 08:47:44, 韩磊 wrote:
> >> Nowadays,the IO schedulers in linux kernel have four types:
> >>
> >> deadline,noop,Anticiptory and CFQ.CFQ is the default scheduler.But CFQ is
> >> not a good scheduler for SSD,dealine may be a good choice.
> >
> >   That doesn't make much sense to me. If there are two bios in flight for
> > some sector, results are undefined. Thus we usually avoid such situation
> > (usually we want to have defined contents of the disk :). The exclusion is
> > usually achieved at higher level using page locking etc. So adding code
> > speeding up such requests doesn't seem worth it.
> >
> >                                                                 Honza
> > --
> > Jan Kara <jack@suse.cz>
> > SUSE Labs, CR
> 
> Do you mean that the probability of two bios have the same start
> sector in request list at this level is very low?
  Yes, that's exactly what I mean. As Ming Lei notes, there are ways how it
could happen (most notably any direct IO user can generate arbitrary number
of bios with the same start sectors). But in none of these cases
performance matters, it is usually a bug in application if that happens.

							Bye
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

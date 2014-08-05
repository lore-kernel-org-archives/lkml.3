Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754AbaHEI7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 04:59:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44081 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932668AbaHEI7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 04:59:13 -0400
Subject: Re: [PATCH 3/4] Add the "verbose" module option.
From: Jean Delvare <jdelvare@suse.de>
To: kreijack@inwind.it
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, bryan@whatroute.net
In-Reply-To: <53DFBE8D.5050707@inwind.it>
References: <1406901650-20841-1-git-send-email-kreijack@inwind.it>
	 <1406901650-20841-4-git-send-email-kreijack@inwind.it>
	 <20140803161223.0b26e4bc@endymion.delvare>	<53DE5179.3080402@gmail.com>
	 <20140803175222.3433b646@endymion.delvare>  <53DE650E.4060909@gmail.com>
	 <1407141986.4302.10.camel@chaos.site>  <53DFBE8D.5050707@inwind.it>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Tue, 05 Aug 2014 10:59:07 +0200
Message-ID: <1407229147.4302.19.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Monday 04 August 2014 à 19:10 +0200, Goffredo Baroncelli a écrit :
> On 08/04/2014 10:46 AM, Jean Delvare wrote:
> > Le Sunday 03 August 2014 à 18:36 +0200, Goffredo Baroncelli a écrit :
> >> The printk without "(tuned %+d)" is never called because 
> >> LOG_TEMP was #define(d) equal to 0.
> > 
> > And this is what your second printk is replacing. So it should not have
> > the "(tuned *)" either.
> > 
> I removed the printk(s) from tune_fan(); the ones leaved replaced 
> both the ones inside tune_fan() and the ones outside.

I understand that. But you still had two final printks, one with "(tuned
%+d)" when level >= 0, which corresponds to what was printed in tune_fan
before, and another one when level < 0, which corresponds to what was
printed in poll_temp before, and that one did not have a "tuned +0" part
so I simply fail to see why its replacement should have it.

I admit I'm surprised we're arguing on that as it seems really obvious
to me, so I can only hope I'm not missing something even more obvious.

> Anyway, Benjamin which is your opinion ? 
> For me is equal to remove or to leave "(tune +0)" (when the tuning is equal to 0).
> Jean think it is better to remove "(tune +0)" (when the tuning is equal to 0).
> So if you haven't any objection I will remove it.

s/remove/not introduce/ is my actual point.

But I'm not going to argue more, I'm not even using that driver and it's
a debug message only anyway, so do as you wish.

Thanks,
-- 
Jean Delvare
SUSE L3 Support


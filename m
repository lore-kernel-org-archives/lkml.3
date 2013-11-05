Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab3KEWp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 17:45:28 -0500
Received: from top.free-electrons.com ([176.31.233.9]:42612 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755435Ab3KEWp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 17:45:27 -0500
Date: Tue, 5 Nov 2013 19:45:27 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Jingoo Han <jg1.han@samsung.com>, "Gupta, Pekon" <pekon@ti.com>,
        Wei Yongjun <weiyj.lk@gmail.com>,
        "tony@atomide.com" <tony@atomide.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Daniel Mack <zonque@gmail.com>, yongjun_wei@trendmicro.com.cn,
        avinashphilip@ti.com,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH -next] mtd: nand: omap: fix error return code in
 omap_nand_probe()
Message-ID: <20131105224526.GA11759@localhost>
References: <CAPgLHd8V06KzBcPmFywSfNxM0q6=s86xn-AdLKeY9h5JZ_nP7g@mail.gmail.com>
 <001101ced6a8$a18a2c80$e49e8580$%han@samsung.com>
 <CAN8TOE9Eac0LDA+Ke_OCPc_AQGnyYB806pO8JP-qOB1Dr8N2pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAN8TOE9Eac0LDA+Ke_OCPc_AQGnyYB806pO8JP-qOB1Dr8N2pg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 01:59:25PM -0800, Brian Norris wrote:
> On Thu, Oct 31, 2013 at 7:18 PM, Jingoo Han <jg1.han@samsung.com> wrote:
> > On Friday, November 01, 2013 9:16 AM, Wei Yongjun wrote:
> >>
> >> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> >>
> >> Fix to return a negative error code from the error handling
> >> case instead of 0, as done elsewhere in this function.
> >
> > Commit message is right? :-(
> 
> It sounds OK by my reading. Unless you're having trouble parsing what
> "as done elsewhere in this function" is being applied to. (IOW, is the
> rest of the function returning a negative error code on the error
> paths, or is it returning 0? Of course the answer is the former, but
> it's possible to misread it.) If it helps, I can try to tweak the
> wording a bit when applying this patch.
> 
> Pekon, can I get an Acked-by?
> 

I guess you'd prefer Pekon's ack than mine, but anyway:

Acked-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

I'd like to point out this driver has other "mis-behaviors" in returning codes
in some other places.

In particular, this pattern can be found repeatedly:

	if (do_something()) {
		err = -ENXIO;
		goto some_other_place;
	}

Which should probably be:

	err = do_something();
	if (err)
		goto some_other_place;

Wei: maybe you'd like to prepare some more patches?
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com

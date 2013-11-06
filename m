Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab3KFAEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 19:04:40 -0500
Received: from dkim2.fusionio.com ([66.114.96.54]:39549 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605Ab3KFAEi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 19:04:38 -0500
X-ASG-Debug-ID: 1383696277-03d6a54d1b1142e0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@wwwdotorg.org>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <CAOesGMiyp3VNUZf=A_MMVAKsdqtE8nJqNuNCmZh6PO2zkU-oTA@mail.gmail.com>
CC: Jens Axboe <axboe@kernel.dk>, Tushar Behera <tushar.behera@linaro.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Kent Overstreet <kmo@daterainc.com>
References: <CAHbNUh1Cw3bc4WR0VcD1H_eKYqGBtv_215_euh6mwTbZ41ejUw@mail.gmail.com>
 <52794823.7080503@kernel.dk>
 <CAOesGMj1xXXM-gNgWQwBKOczpJtM7CobYy4h7Fe=4W3U43EJGQ@mail.gmail.com>
 <20131105203308.3802.45122@localhost.localdomain>
 <CAOesGMirg=ex9hLCjGBpj0cMhLeQ5cJQoRv72tgg7PoSKWUDhA@mail.gmail.com>
 <20131105205623.3802.5166@localhost.localdomain>
 <52796BE1.5010306@wwwdotorg.org>
 <CAOesGMiyp3VNUZf=A_MMVAKsdqtE8nJqNuNCmZh6PO2zkU-oTA@mail.gmail.com>
Message-ID: <20131106000432.3802.22331@localhost.localdomain>
User-Agent: alot/0.3.4
Subject: Re: Boot failure on Arndale with next-20131105
Date: Tue, 5 Nov 2013 19:04:32 -0500
X-ASG-Orig-Subj: Re: Boot failure on Arndale with next-20131105
X-Originating-IP: [10.101.1.160]
X-Barracuda-Connect: cas1.int.fusionio.com[10.101.1.40]
X-Barracuda-Start-Time: 1383696277
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.142088
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Olof Johansson (2013-11-05 17:41:42)
> On Tue, Nov 5, 2013 at 2:06 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> > On 11/05/2013 01:56 PM, Chris Mason wrote:
> >> Quoting Olof Johansson (2013-11-05 15:38:33)
> >>> On Tue, Nov 5, 2013 at 12:33 PM, Chris Mason <chris.mason@fusionio.com> wrote:
> >>>> Quoting Olof Johansson (2013-11-05 15:23:51)
> >>>>> On Tue, Nov 5, 2013 at 11:33 AM, Jens Axboe <axboe@kernel.dk> wrote:
> >>>>
> >>>> [ horrible crashes fixed by removing my patch ]
> >>>>
> > ...
> >> Ok, I think I see it.  My guess is that you're hitting bounce buffers.
> >> __blk_queue_bounce is the only caller of the bio splitting code I can
> >> see that you might be hitting.
> >>
> >> My first patch exposed a lurking bug in bio_clone_biovec.  Basically
> >> bio->bi_vcnt is being doubled instead of initialized.
> >>
> >> This patch is only compile tested, but I think it'll fix it.
> >
> > Tested-by: Stephen Warren <swarren@nvidia.com>
> > (this fixes the issue on Tegra30/Beaver at least)
> 
> Tested-by: Olof Johansson <olof@lixom.net>
> 
> This resolves boot failures on:
> * Tegra30/beaver
> * OMAP4/panda
> * i.MX6/wandboard
> 
> Thanks Chris!

Perfect, thanks for bisecting and trying the patches.  Kent, if things
get rebased, could you please fold this patch and my bi_vcnt patch in?

-chris


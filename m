Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab3KKIBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 03:01:18 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44358 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab3KKIBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 03:01:12 -0500
Date: Mon, 11 Nov 2013 09:01:04 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Axel Lin <axel.lin@ingics.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Michal Marek <mmarek@suse.cz>,
        Ming Lei <tom.leiming@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: kernel BUG at kernel/kallsyms.c:222!
Message-ID: <20131111080104.GH14892@pengutronix.de>
References: <CACVXFVO=QA-R1+twCL9fc_3vASg6Ap-3ezi=tU1MV1pdPYrfWw@mail.gmail.com>
 <CAFRkauAdR3=ByE0_B3OsqOBjmbz2a02EXb+6g-vn=1TJ7AZc8Q@mail.gmail.com>
 <CACVXFVMaLOfDvzdn_1NryQY59cgtLdMMqHL-_ZAa95MPz4p56Q@mail.gmail.com>
 <CAFRkauDe7V3N0AbfvE_=GEXHZ_Fw62VsA8p50wSUYE1-TRqMfw@mail.gmail.com>
 <87zjpf4w0j.fsf@rustcorp.com.au>
 <CACVXFVNHryPXy2NQhPwXkoCeLUXQSgrWmgBkMNtGD_=X_62_5Q@mail.gmail.com>
 <CAFRkauDGiy3yZOwKFWMEJvYUe0OoXMEZHKaxogZHdgzMxexdHA@mail.gmail.com>
 <CACVXFVMAnewCkSNNke3kf1-yO+JCc_HBRp8iaLBPJ+14G79Haw@mail.gmail.com>
 <87y54vzszo.fsf@rustcorp.com.au>
 <CAFRkauBYUq3UAjqLvkuDVEz5BVyDpC0DuVRGTe4K+kcoCX17GA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFRkauBYUq3UAjqLvkuDVEz5BVyDpC0DuVRGTe4K+kcoCX17GA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Nov 11, 2013 at 02:43:28PM +0800, Axel Lin wrote:
> 2013/11/11 Rusty Russell <rusty@rustcorp.com.au>:
> > Ming Lei <tom.leiming@gmail.com> writes:
> I don't have other noMMU platform to test.
> But I think this issue impacts various !CONFIG_MMU platforms:
> We have CONFIG_PAGE_OFFSET=0xC0000000 in various default configs.
> For !CONFIG_MMU case, it just don't use the CONFIG_PAGE_OFFSET setting.
> So use CONFIG_PAGE_OFFSET to filter symbols looks wrong to me for all
> !CONFIG_MMU cases.
I don't know what the original problem is, but for my Cortex-M3 machine
(ie. !MMU) I also have CONFIG_PAGE_OFFSET=0xC0000000. Didn't see this
resulting in any problems although the value looks bogus. (The range
0x90000000-0xdfffffff is reserved on my SoC. Trying to read from there
with the debugger fails with a message "Could not read memory.")

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

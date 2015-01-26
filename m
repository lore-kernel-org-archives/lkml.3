Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbbAZGZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 01:25:24 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:13564 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751591AbbAZGZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 01:25:19 -0500
Date: Mon, 26 Jan 2015 14:22:10 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Doug Anderson <dianders@chromium.org>
CC: Guenter Roeck <linux@roeck-us.net>, Wim Van Sebroeck <wim@iguana.be>,
        Heiko Stuebner <heiko@sntech.de>,
        Lunxue Dai <lunxue.dai@rock-chips.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] watchdog: dw_wdt: pat the watchdog before enabling
 it
Message-ID: <20150126142210.4cd0b33f@xhacker>
In-Reply-To: <CAD=FV=UMmfNAEQVKCxTBapwO=pgno+cWUJNiMS7_uFK7NPevkw@mail.gmail.com>
References: <1421882243-3631-1-git-send-email-dianders@chromium.org>
	<20150122132200.4729d38b@xhacker>
	<CAD=FV=UMmfNAEQVKCxTBapwO=pgno+cWUJNiMS7_uFK7NPevkw@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-26_01:2015-01-24,2015-01-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1501260073
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Doug,

On Thu, 22 Jan 2015 09:09:28 -0800
Doug Anderson <dianders@chromium.org> wrote:

> Jisheng,
> 
> On Wed, Jan 21, 2015 at 9:22 PM, Jisheng Zhang <jszhang@marvell.com> wrote:
> > Dear Doug,
> >
> > On Wed, 21 Jan 2015 15:17:22 -0800
> > Doug Anderson <dianders@chromium.org> wrote:
> >
> >> On some dw_wdt implementations the "top" register may be initted to 0
> >> at bootup.  In such a case, each "pat" of the watchdog will reset the
> >> timer to 0xffff.  That's pretty short.
> >
> > + Guenter Roeck
> >
> > This should have been fixed by dfa07141e7a792("watchdog: dw_wdt:
> > initialise TOP_INIT in dw_wdt_set_top()")
> 
> I will admit that I'm testing on a tree that doesn't have your patch
> (I'm on a 3.14 kernel with lots of backports).  ...but I did try
> cherry-picking your patch before I wrote up mine and it didn't fix my
> problem.  I believe that the watchdog that's in Rockchip rk3288 must
> be a slightly different version of the IP block than you're working
> with.
> 
> Specifically I see the register WDT_TORR that has an offset of 0x4.
> That's the RANGE_REG in your code.  It shows bits 3:0 set the timeout
> period (0 = 0xffff and 15 = 0x7fffffff).  It shows bits 31:4 as
> "reserved".

Could you please dump registers' value at offset 0xf4 and 0xf8 if you don't mind?

Thanks,
Jisheng

> 
> 
> > In fact, my original fix is as similar as your patch
> >
> > http://www.spinics.net/lists/arm-kernel/msg363658.html
> 
> Yup, except that I pat the watchdog before enabling it and you pat it
> after...  It probably doesn't matter as long as the two instructions
> are within 2.5ms of each other, but it seems nice to be safer.
> 
> -Doug


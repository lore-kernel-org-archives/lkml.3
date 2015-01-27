Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbbA0EzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 23:55:08 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47975 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752438AbbA0EzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 23:55:05 -0500
Date: Tue, 27 Jan 2015 12:52:02 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: Doug Anderson <dianders@chromium.org>, Wim Van Sebroeck <wim@iguana.be>,
        Heiko Stuebner <heiko@sntech.de>,
        Lunxue Dai <lunxue.dai@rock-chips.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] watchdog: dw_wdt: pat the watchdog before
 enabling it
Message-ID: <20150127125202.59dbd37d@xhacker>
In-Reply-To: <54C70F24.5080100@roeck-us.net>
References: <1422314836-30516-1-git-send-email-dianders@chromium.org>
	<20150127114909.204eeee0@xhacker>
	<54C70F24.5080100@roeck-us.net>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-27_02:2015-01-27,2015-01-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1501270054
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Guenter,

On Mon, 26 Jan 2015 20:08:04 -0800
Guenter Roeck <linux@roeck-us.net> wrote:

> On 01/26/2015 07:49 PM, Jisheng Zhang wrote:
> > Dear Doug,
> >
> > On Mon, 26 Jan 2015 15:27:15 -0800
> > Doug Anderson <dianders@chromium.org> wrote:
> >
> >> On some dw_wdt implementations the "top" register may be initted to 0
> >> at bootup.  In such a case, each "pat" of the watchdog will reset the
> >> timer to 0xffff.  That's pretty short.
> >>
> >> The input clock of the wdt can be any of a wide range of values.  On
> >> an rk3288 system, I've seen the wdt clock be 24.75 MHz.  That means
> >> each tick is ~40ns and we'll count to 0xffff in ~2.6ms.
> >>
> >> Because of the above two facts, it's a really good idea to pat the
> >> watchdog after initting the "top" register properly and before
> >> enabling the watchdog.  If you don't then there's no way we'll get the
> >> next heartbeat in time.
> >>
> >> Jisheng Zhang fixed this problem on some dw_mmc versions by using the
> >
> > s/dw_mmc/dw_wdt
> >
> >> TOP_INIT feature.  However, the dw_wdt on rk3288 doesn't have TOP_INIT
> >> so it's a good idea to also pat the watchdog manually.
> >
> > Based on your register dumping, I see the following configurations on
> > rk3288:
> >
> > WDT_DUAL_TOP is configured as false, so there's no TOP_INIT
> >
> > WDT_DFLT_TOP is configured as 0, so it will timeout soon.
> >
> >
> > So an extra pat is a must on such platforms with similar configurations.
> > And it doesn't hurt anything if we have an extra pat before enabling the
> > WDT
> >
> > All in all, except the "dw_mmc" typo above, the patch looks good to me.
> >
> 
> Jisheng,
> 
> it would be great if you can provide configuration information shown in
> the (undocumented) registers.

The wdt in rk3288 is a bit old, so I'm not sure whether the meaning is the same
or not. The key related configuration here is the so called CP_WDT_DUAL_TOP, bit[2]
of WDT_COMP_PARAMS_1 (0xf4), which indicates whether the TOP_INIT bits exist or
fixed as zero.

Thanks,
Jisheng

> 
> Doug,
> 
> can you send another version with this information added as comment
> to the code ? This will help others to understand what is going on
> (and why) later on.
> 
> Thanks,
> Guenter
> 


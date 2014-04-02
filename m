Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335AbaDBPbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 11:31:15 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:39395 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932247AbaDBPbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 11:31:12 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19Ul5SwHrxKVs2hbiV06Edp
Date: Wed, 2 Apr 2014 08:31:04 -0700
From: Tony Lindgren <tony@atomide.com>
To: Taras Kondratiuk <taras.kondratiuk@linaro.org>
Cc: Patch Tracking <patches@linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Linaro Kernel <linaro-kernel@lists.linaro.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Victor Kamensky <victor.kamensky@linaro.org>
Subject: Re: [PATCH 0/4] ARM: OMAP: raw read and write endian fix
Message-ID: <20140402153104.GA12234@atomide.com>
References: <1387822234-11167-1-git-send-email-taras.kondratiuk@linaro.org>
 <CAArO44vC4WKGHSqHX3+Mo5+jcNuyJLkh94+SPd4H+aZYAroYzw@mail.gmail.com>
 <20140108003927.GJ5074@atomide.com>
 <5332AD89.8030802@linaro.org>
 <533BE311.7050900@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533BE311.7050900@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Taras Kondratiuk <taras.kondratiuk@linaro.org> [140402 03:18]:
> On 03/26/2014 12:35 PM, Taras Kondratiuk wrote:
> > On 01/08/2014 02:39 AM, Tony Lindgren wrote:
> >> * Taras Kondratiuk <taras.kondratiuk@linaro.org> [131223 10:20]:
> >>> On 23 December 2013 20:10, Taras Kondratiuk <taras.kondratiuk@linaro.org> wrote:
> >>>> This series does trivial replacement of __raw_xxx functions with xxx_relaxed
> >>>> endian-neutral variants in 'mach-omap2' and 'plat-omap' directories.
> >>>> Some code here most probably won't be used in BE mode (like debug-leds for
> >>>> OMAP1 boards), but changes are made anyway to remove __raw_xxx() functions
> >>>> completely and simplify future grep'ing for new __raw_xxx() entries.
> >>
> >> Sorry for the delay on these, applying into omap-for-v3.14/be.
> >> These are trivial, and it's actually nice that you left out the
> >> assembly related changes as those should be acked by the PM
> >> people in case there are some issues dealing with the ROM code
> >> etc.
> > 
> > Hi Tony,
> > 
> > It seems omap-for-v3.14/be didn't get into 3.14-rc8.
> > Is there any issue with them?
> 
> This series conflicts now with clock changes which got into 3.14.
> Resolution is trivial - just skip conflicting changes.
> omap2_clk_{real,writel} already uses {readl,writel}_relaxed inside.
> Do I need to push an updated series?

Sorry looks like I forgot to merge this branch. I think my plan
was to wait for the clock changes to get merged first..

So yeah, it's probably best that you repost the series after -rc1
is out so we have the conflicting parts cleared. That way the
changes are tested to work for your BE series :)

Regards,

Tony

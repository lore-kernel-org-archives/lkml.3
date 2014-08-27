Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936061AbaH0W5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 18:57:46 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:56142 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935948AbaH0W5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 18:57:45 -0400
Date: Wed, 27 Aug 2014 23:57:39 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: Dexuan Cui <decui@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PANIC, hyperv] BUG: unable to handle kernel paging request at
 ffff880077800004 (hv_ringbuffer_write)
Message-ID: <20140827225739.GA24590@sucs.org>
References: <20140820092630.GA1478@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C994F314@SINEX14MBXC417.southpacific.corp.microsoft.com>
 <20140825174132.GA17681@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C995E93E@SINEX14MBXC419.southpacific.corp.microsoft.com>
 <20140827104408.GC1827@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C996493E@SINEX14MBXC419.southpacific.corp.microsoft.com>
 <20140827121559.GA14286@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C9965238@SINEX14MBXC419.southpacific.corp.microsoft.com>
 <20140827161900.GA25326@sucs.org>
 <51ae44fcae424365a6d78f3597175d77@BY2PR0301MB0711.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51ae44fcae424365a6d78f3597175d77@BY2PR0301MB0711.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 06:45:55PM +0000, KY Srinivasan wrote:
> 
> > -----Original Message-----
> > From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> > Sent: Wednesday, August 27, 2014 9:19 AM
> > 
> > > BTW, with the patch below, hyperv_fb can work now, BUT,
> > > *occasionally*,
> > > storvsc_probe() -> ... -> vmbus_open() -> can fail due to
> > > HV_STATUS_INVALID_ALIGNMENT...
> > 
> > I applied your new patch on top of KY's pieces (it applied cleanly)
> > and while it doesn't blow up, one warning is printed out and the UP
> > boot seemed to stall after input: TPPS/2 message (but pressing
> > ctrl-alt-delete allows the system to reboot cleanly).
> 
> First let me thank you guys for looking into this issue. Looking at
> your dmesg, it looked like storvsc probe failed as Dexuan had seen.
> Since the failure appears to be alignment related, perhaps we could
> test with allocating a page all the time (and getting rid of the
> kmalloc). Sitsofe, here is a patch based on Dexuan's patch. If this
> works, I will probably minimize failure cases by pre-allocating
> per-cpu pages for this.:

After some modifications to apply on top of your previous patches
applying this latest patch has cured the issues surrounding hyperv_fb
issues on boot. The only issue seen on boot now is similar to
https://lkml.org/lkml/2014/8/19/227 ...

How come previous alignment efforts weren't working out?

-- 
Sitsofe | http://sucs.org/~sits/

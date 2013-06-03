Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751134Ab3FCELS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 00:11:18 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63825 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab3FCELK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 00:11:10 -0400
X-Originating-IP: 108.223.40.66
Date: Sun, 2 Jun 2013 21:11:42 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Chen Yuanquan-B41889 <B41889@freescale.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Yuanquan Chen <Yuanquan.Chen@freescale.com>,
        Hiroo Matsumoto <matsumoto.hiroo@jp.fujitsu.com>
Subject: Re: [PATCH] powerpc/pci: Improve device hotplug initialization
Message-ID: <20130603041142.GA11874@roeck-us.net>
References: <1369762514-27352-1-git-send-email-linux@roeck-us.net>
 <51A5CAC1.6030800@freescale.com>
 <20130531051423.GA15505@roeck-us.net>
 <1369979047.3928.112.camel@pasglop>
 <20130601135809.GA6395@roeck-us.net>
 <51ABFF5F.4020409@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51ABFF5F.4020409@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 10:28:47AM +0800, Chen Yuanquan-B41889 wrote:
> On 06/01/2013 09:58 PM, Guenter Roeck wrote:
> >On Fri, May 31, 2013 at 03:44:07PM +1000, Benjamin Herrenschmidt wrote:
> >>On Thu, 2013-05-30 at 22:14 -0700, Guenter Roeck wrote:
> >>>On Wed, May 29, 2013 at 05:30:41PM +0800, Chen Yuanquan-B41889 wrote:
> >>>>On 05/29/2013 01:35 AM, Guenter Roeck wrote:
> >>>>>bios_add_device(). Drop explicit calls to pcibios_setup_device();
> >>>>>this makes pcibios_setup_bus_devices() a noop function which could
> >>>>>eve
> >>>>Yeah, it's more reasonable to do the irq and DMA related initialization
> >>>>in one code path for all devices.
> >>>>
> >>>Any comments / feedback on the code itself ?
> >>Sorry, I haven't had a chance to review it yet, I'm fairly bogged down
> >>at the moment. I want to tread carefully because the previous iteration
> >>of changing that stuff did break a few platforms in the end.
> >>
> >Hi Ben,
> >
> >the comment was actuially directed towards Yuanquan.
> >
> >No problem, take your time. I did my best to test it, but I agree that this is a
> >critical area of the code, and it would be desirable to get additional scrutiny
> >and test feedback.
> >
> >The code has been running in our system (P2020 and P5040) for several months.
> >I was preparing a patch for upstream submission when I noticed commit 37f02195b.
> >After testing ithis commit, I noticed the problems with it and wrote this patch,
> >which aligns the code with our initial patch. I tested it as good as I could on
> >our systems as well as with a P5040 evaluation board and an Intel GE PCIe
> >card.
> >
> >Thanks,
> >Guenter
> >
> 
> Hi Guenter,
> 
> Your patch makes sure the initialization of DMA and irq in one code
> path and also
> avoids the initialization called two times(in pci bus scanning and
> pci_enable_device()
> in device driver) for no-hot-plugged pci device. It's much more reasonable!
> 
> I don't know why you also remove the function "set_dev_node()" ? As
> I know, the
> function just be called here. I think it should remain in your new function
> pcibios_add_device().
> 
pcibios_add_device() is (only) called from pci_device_add(),
which already calls set_dev_node().

Guenter

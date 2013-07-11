Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750914Ab3GKEVM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 00:21:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57791 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab3GKEVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 00:21:11 -0400
Date: Wed, 10 Jul 2013 21:22:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Akhil Goyal <akhil.goyal@freescale.com>
Cc: arnd@arndb.de, lars@metafoo.de, robin.getz@analog.com,
        Michael.Hennerich@analog.com, lars-peter.clausen@analog.com,
        linux-kernel@vger.kernel.org, pankaj.chauhan@freescale.com
Subject: Re: [PATCH v2 0/4] Radio device framework
Message-ID: <20130711042210.GA23660@kroah.com>
References: <1373277002-14009-1-git-send-email-akhil.goyal@freescale.com>
 <51DE2DB5.60608@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DE2DB5.60608@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 09:29:49AM +0530, Akhil Goyal wrote:
> On 7/8/2013 3:19 PM, akhil.goyal@freescale.com wrote:
> >From: Akhil Goyal<akhil.goyal@freescale.com>
> >
> >RF signal path is integral part of any system that transmits/receives RF
> >(radio frequency) signals. In these systems Data is processed/converted
> >to IQ samples (digital representation a RF signal) and passed to a RFIC
> >(RF PHY) which converts the digital RF signal (IQ samples) to analog and
> >transmits over antenna.
> >
> >Typically The signal path consists of multiple components:
> >
> >Antenna controller<->  vector signal processors<->  RFIC<->  Antenna
> >
> >Each of these components have specific functionalities:
> >
> >1. Antenna controller: Framing of digital IQ data into protocol specific frames.
> >2. vector signal processors: For conditioning of signal.
> >3. RFIC : converts digital IQ data to analog signal which is transmitted/received on/from Air.
> >
> >Also it is desirable to control the complete signal path, for example:
> >bringing the complete signal path up/down etc.
> >
> >The radio device framework introduces a way to accommodate the RF signal
> >paths.  One signal path is represented as a RF device (rf0, rf1 etc), and
> >it can contain multiple components which have their individual vendor
> >specific drivers. The framework provides mechanism by which individual
> >components can register with RF framework, and the framework will handle the binding
> >of individual component devices to a RF device. RF device exports the control
> >interfaces to user space, and this user space interface is independent of
> >component (vendor specific) drivers.
> >
> >This patch set include
> >1. RF Interface: Independent of phy or antenna controller.
> >2. AIC driver: Antenna interface Controller(AIC) of Hetrogenous SOC's
> >like BSC9131, BSC9132
> >4. Device tree bindings for AIC.
> >5. Device tree changes for BSC9131-AIC
> >
> >changes in v2:
> >1. incorporated comments for handling pointers in user space API structures.
> >2. Removed patches for AD9361 phy driver. It shall be sent once a proper
> >driver is in place for AD9361 chip
> >3. Removed Device tree nodes/bindings for AD9361
> >4. Incorporated comments for proper handling of wait_events
> >5. Added Documentation for IOCTL APIs and the structures used.
> >6. Inserted paddings in user space structures.
> >7. Reorganized code for rfdev.c to remove forward declaration and broke the
> >rf_ioctl() function to handle local structures correctly.
> >8. Corrected the error handling for mutex used.
> >
> 
> Hi Arnd/Greg,
> 
> It has been 3-4 days for this patch set and there are no review
> comments on these patches. Please suggest a way forward for the
> patch set. I have incorporated all the review comments for v1.

We are thick in the middle of the merge window for 3.11-rc1 and have
_no_ time for reviewing anything new, please give us a chance to catch
up with our existing work before asking about new stuff that is not
going to happen until 3.12 at the earliest.

In sort, patience please.

greg k-h

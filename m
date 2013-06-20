Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab3FTICq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:02:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55832 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab3FTICo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:02:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: [PATCH RFC 0/2] Extend multi_v7_defconfig
Date: Thu, 20 Jun 2013 10:02:01 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Tony Prisk <linux@prisktech.co.nz>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <1371664384-24974-1-git-send-email-soren.brinkmann@xilinx.com> <201306192046.41005.arnd@arndb.de> <51C291D0.6000401@monstr.eu>
In-Reply-To: <51C291D0.6000401@monstr.eu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306201002.01702.arnd@arndb.de>
X-Provags-ID: V02:K0:Q+j0Xnze8zA25DlUqTFXtwkxnldNJUmIhsz44/8eOVu
 VAD+kT/S4ppNGIxxDN/2MHmAsCJBqkcPArBQaYFhS0xnc42lpC
 sC/fHiHfN9AgaOfRv8xRhtqAdBXG9BTIGqRSF4Z46Vq63jJy/o
 G9VMHHlJHoApr0Dqm3TM4pik8Y/QhdvvM/xrIPb9uHAA6+i6Os
 iPBZzfyL2zreR+ik8gTNYBkXg8Vy4wfy76cDW1kBcuCXb/EBDy
 g2896uESe3gc4dLb6u+YQx9ffAKjzGtSstCjn1gonlkCw3L+uK
 Ili4G7OlaTlJvDNnR+V+FXmO+b1+zVTAdJRgKeLjO7OseW+/VG
 mbsvG1niXoUT9m98SD1s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 June 2013, Michal Simek wrote:
> On 06/19/2013 08:46 PM, Arnd Bergmann wrote:
> > On Wednesday 19 June 2013, Soren Brinkmann wrote:
> >> I don't know how much a defconfig is supposed to provide, hence as RFC.
> >> This patches are needed for booting Zynq into a minimum ramfs based
> >> system with a serial console.
> > 
> > In my opinion we should provide enable all the platform specific drivers
> > in the defconfigs, as well as everything needed to boot the system,
> > to get proper compile coverage as well as the ability to test changes
> > easily. Your patches look good. Michal, would you apply them and
> > send another pull request or should I just take them directly?
> 
> Soren asked me 2 days ago if make sense to create zynq defconfig or not.
> I just suggested him to better extend this multi_v7_defconfig.
> But still question is if we can/should create zynq specific defconfig?
> Or are you going to remove all of these platform specific defconfig?

We don't have a consistent policy across platforms at the moment.
Traditionally we had multiple defconfigs per platform, in some cases
one per board, but moving towards one defconfig per platform at
the moment.

I guess whether or not to have a separate defconfig for one platform
or to use only multi_*_defconfig is a question of how many people
would use a zynq_defconfig in practice.

> Definitely agree that multi_v7 defconfig should enable everything needed
> to boot the system.
> Does it also mean that we should also enable all zynq drivers
> to get better compile coverage?

I would say yes.

My feeling is that multi_v7_defconfig should enable all hardware
support for the platforms in it, and that users would take it
as a starting point if they want to have a configuration for
an embedded system, disabling everything they don't need.

	Arnd

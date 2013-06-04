Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339Ab3FDRkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:40:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57362 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab3FDRkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:40:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH, RFC 2/2] USB: host: make USB_ARCH_HAS_?HCI obsolete
Date: Tue, 4 Jun 2013 19:40:00 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-usb@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.1306041257250.1093-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1306041257250.1093-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306041940.00979.arnd@arndb.de>
X-Provags-ID: V02:K0:tSaYAUeAj4Jnu19bunF9UajSHeTfMxVlYW2Cgjs4j9N
 bcGIja5qY69x7goaVum7JvTI9QM/ZZ+aEW5X37JzX1MF6fylEz
 2P2VKg/HXpEmx5lwzuBLUdfBbvwzLkgct0Na+mRtZ+LZ3d4VmP
 iVL1ToTmIoJvH8/+PfuLgMROuDA/T2o6+TkdCs1Jv1N2iymC29
 h+bCuw4DaUpAuHWWS7eNtBrzmpjw+VLS6XZ3tqQmi8oh2M/+Fo
 rG6i5XYhZykHAG2Pw4IxAJHrqLF1N/XFcObVs9jRx/KDgKb0n+
 PpQSJLKZ/J+kXtE2TgcJStzajKAUZDj3NN+aD3+b76sdUonkeZ
 yNCSd/Cc9ixw0UahNIqw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 June 2013, Alan Stern wrote:
> On Tue, 4 Jun 2013, Arnd Bergmann wrote:
> > so that would create a circular dependency unless we change all of them
> > at once. I did that when creating this patch, but then decided to
> > revert it for now and do smaller steps.
> 
> Okay.  Changing those 24 should be the next step.

Yes, and we can remove the various 'select USB_ARCH_HAS_*' from arch
code at the same time. Since there is no hurry, I would suggest doing
that after 3.11-rc1 so we don't have to worry about dependencies.
 
> > We could do
> > 
> > config USB_ARCH_HAS_HCD
> > 	def_bool USB_SUPPORT
> > 
> > or
> > 
> > config USB_ARCH_HAS_HCD
> > 	def_bool y
> > 
> > which would both have the exact same behavior as 'def_bool HAS_IOMEM'.
> 
> I'm in favor of "def_bool y".

Ok. And I'll use 'bool' for the 'USB_ARCH_HAS_?HCI' symbols since we
don't care about the value any more.

	Arnd

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab3AXSRa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:17:30 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:61487 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab3AXSR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:17:28 -0500
Date: Thu, 24 Jan 2013 10:17:26 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Sven =?iso-8859-1?Q?K=F6hler?= <sven.koehler@gmail.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Linux 3.7.4
Message-ID: <20130124181726.GD12106@kroah.com>
References: <20130121195420.GA6534@kroah.com>
 <kdq4sd$g3c$1@ger.gmane.org>
 <20130124022425.GA5721@kroah.com>
 <51009E68.90407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51009E68.90407@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 03:37:28AM +0100, Sven Köhler wrote:
> Am 24.01.2013 03:24, schrieb Greg KH:
> > On Thu, Jan 24, 2013 at 03:06:29AM +0100, Sven Köhler wrote:
> >> Hi,
> >>
> >> I had to revert this, because it resulted in
> >>
> >>   LD      init/built-in.o
> >> arch/x86/built-in.o: In function `setup_arch':
> >> (.init.text+0x359e): undefined reference to `early_pci_allowed'
> >> arch/x86/built-in.o: In function `setup_arch':
> >> (.init.text+0x35b2): undefined reference to `read_pci_config_16'
> >> arch/x86/built-in.o: In function `setup_arch':
> >> (.init.text+0x35cb): undefined reference to `read_pci_config_16'
> >> make[1]: *** [vmlinux] Fehler 1
> >> make: *** [sub-make] Fehler 2
> >>
> >> I'm building a Xen domU kernel without modules (one big binary of
> >> everything).
> > 
> > 
> > You had to revert _what_?
> 
> The patch from 3.7.3 to 3.7.4.
> Sorry for the confusion.
> 
> The problem seems to be caused by this:
> > http://www.kernel.org/diff/diffview.cgi?file=%2Fpub%2Flinux%2Fkernel%2Fv3.0%2Fincr%2Fpatch-3.7.3-4.bz2;z=8

The whole patch?

Any chance you can use 'git bisect' on the 3.7.4 tree, marking 3.7.3
good, so we can find the patch that caused the problem and revert it?

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab3AXCle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 21:41:34 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:62096 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab3AXClZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 21:41:25 -0500
Message-ID: <51009E68.90407@gmail.com>
Date: Thu, 24 Jan 2013 03:37:28 +0100
From: =?ISO-8859-1?Q?Sven_K=F6hler?= <sven.koehler@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130112 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Linux 3.7.4
References: <20130121195420.GA6534@kroah.com> <kdq4sd$g3c$1@ger.gmane.org> <20130124022425.GA5721@kroah.com>
In-Reply-To: <20130124022425.GA5721@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 24.01.2013 03:24, schrieb Greg KH:
> On Thu, Jan 24, 2013 at 03:06:29AM +0100, Sven Köhler wrote:
>> Hi,
>>
>> I had to revert this, because it resulted in
>>
>>   LD      init/built-in.o
>> arch/x86/built-in.o: In function `setup_arch':
>> (.init.text+0x359e): undefined reference to `early_pci_allowed'
>> arch/x86/built-in.o: In function `setup_arch':
>> (.init.text+0x35b2): undefined reference to `read_pci_config_16'
>> arch/x86/built-in.o: In function `setup_arch':
>> (.init.text+0x35cb): undefined reference to `read_pci_config_16'
>> make[1]: *** [vmlinux] Fehler 1
>> make: *** [sub-make] Fehler 2
>>
>> I'm building a Xen domU kernel without modules (one big binary of
>> everything).
> 
> 
> You had to revert _what_?

The patch from 3.7.3 to 3.7.4.
Sorry for the confusion.

The problem seems to be caused by this:
> http://www.kernel.org/diff/diffview.cgi?file=%2Fpub%2Flinux%2Fkernel%2Fv3.0%2Fincr%2Fpatch-3.7.3-4.bz2;z=8

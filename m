Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab3GICTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 22:19:40 -0400
Received: from mail-ye0-f173.google.com ([209.85.213.173]:51495 "EHLO
	mail-ye0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab3GICTj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 22:19:39 -0400
X-Greylist: delayed 115178 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Jul 2013 22:19:39 EDT
Date: Mon, 08 Jul 2013 21:19:36 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: Bluez with uclibc
To: lkml@serverphorums.com
Cc: linux-kernel@vger.kernel.org
References: <6e9104c416ff417b9c63f47891f947ea.LinuxKernel@www.serverphorums.com>
In-Reply-To: <6e9104c416ff417b9c63f47891f947ea.LinuxKernel@www.serverphorums.com>
	(from lkml@serverphorums.com on Mon Jul  8 03:06:15 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1373336376.27613.23@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2013 03:06:15 AM, lkml@serverphorums.com wrote:
> Hi,
> 
> Today, I need to cross compile Bluez for arm with uclibc library into  
> Buildroot environment.
> However, I meet some dependencies between bluez-utils package and MMU  
> deactivation due to dBus.
> 
> Do you know a way to use Bluez with uclibc library?

Dunno about buildroot, but if you just want to statically link  
something against uClibc on arm, you could grab either the cross or  
native "armv5l" compiler from

   http://landley.net/aboriginal/bin

and add its "bin" subdirectory to your $PATH. I just updated that  
toolchain so it's using the 3.10 headers (yes, with the patch for  
http://lkml.indiana.edu/hypermail/linux/kernel/1305.2/01452.html the  
kernel developers never did fix), and it's the last release version of  
uClibc (from a year and change ago, but that's uClibc for you).

As for fixing dependencies beyond "building against uClibc", that's a  
buildroot question. They have their own mailing list...

Rob
Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab3IXBiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 21:38:12 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:33015 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab3IXBiL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 21:38:11 -0400
Date: Mon, 23 Sep 2013 20:38:07 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH 1/2] Fix NULL pointer dereference while loading
 initramfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: P J P <ppandit@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20130923124110.9b8aebd78c2b602255f1dc1f@linux-foundation.org>
	(from akpm@linux-foundation.org on Mon Sep 23 14:41:10 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1379986687.1974.63@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 02:41:10 PM, Andrew Morton wrote:
> On Sun, 15 Sep 2013 14:33:53 +0530 (IST) P J P <ppandit@redhat.com>  
> wrote:
> 
> > Make menuconfig allows one to choose compression format of an
> > initial ramdisk image. But this choice does not result in duly
> > compressed initial ramdisk image. Because - $ make install - does
> > not pass on the selected compression choice to the dracut(8) tool,
> > which creates the initramfs file. dracut(8) generates the image
> > with the default compression, ie. gzip(1).

I've been building kernels, including with initramfs, and I don't have  
dracut(8) installed? In today's git:

$ find . -type f | xargs grep -i dracut
./tools/testing/ktest/sample.conf:#POST_INSTALL = ssh user@target  
/sbin/dracut -f /boot/initramfs-test.img $KERNEL_VERSION
./tools/testing/ktest/examples/kvm.conf:# that uses dracut for its  
initfs. The POST_INSTALL will be executed
./tools/testing/ktest/examples/kvm.conf:POST_INSTALL = ${SSH}  
/sbin/dracut -f /boot/initramfs-test.img $KERNEL_VERSION
./Documentation/ABI/testing/evm:		 
Documentation/keys-trusted-encrypted.txt.  (A sample dracut

> - Is anyone working on fixing up Kconfig/dracut(8) so the correct
>   decompression method is used?

I've been messing with this area and maight be interested if I had any  
idea what this guy was talking about?

Rob
Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764Ab3IYQ4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 12:56:45 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:35089 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3IYQ4o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 12:56:44 -0400
Date: Wed, 25 Sep 2013 11:56:39 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH 2/2] Export initial ramdisk compression config
To: P J P <ppandit@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.03.1309250035480.5312@erqung.pbz> (from
	ppandit@redhat.com on Tue Sep 24 14:41:54 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1380128199.1974.89@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 02:41:54 PM, P J P wrote:
>    Hello Andrew,
> 
> Thank you so much for reviewing these patches.
> 
> +-- On Mon, 23 Sep 2013, Andrew Morton wrote --+
> | It's a bit confusing whether all this appiles to initrd, to  
> initramfs
> | or to both.  Can you please clarify all this and be sure that it's  
> all
> | consistent?
> 
>   IIUC, we no longer use initrd block device images. Instead we use  
> initramfs
> which is a cpio(1) archive image. Both mkinitrd(8) & dracut(8) are  
> invoked
> from /sbin/new-kernel-pkg tool. And mkinitrd(8) is nothing but a  
> wrapper
> around dracut(8) these days.

$ find . -name "Makefile*" | xargs grep new-kernel-pkg
$ grep -r new-kernel-pkg scripts
$

Ah, so it's an out of tree bespoke Red Hat tool. No wonder I couldn't  
find it.

> Looking at the dracut(8) tool, it seems it can easily support any  
> number of
> compression tools, for it already has options --gzip, --bzip2, --xz &  
> --lzma.
> Adding --lzo, --lz4 etc won't be much difficult.

You're reimplemented the posix "pax" command?

> | - Can we avoid having to update dracut each time a new compression
> |   scheme is added?  I assume your dracut changes will just exec
> |   "$INITRD_COMPRESS -d", so as long as any new decompression
> |   application uses the expected -d argument in the expected way, it
> |   should work seamlessly?
> 
>   Yes, dracut(8) has | --compress=$INITRD_COMPRESS | option which  
> could be
> used to pass compression program to dracut(8).

$ grep -r INITRD_COMPRESS linux
$

Is this what you're currently doing, or the change you're requesting in  
the kernel?

> Not sure if dracut(8) expects
> an absolute path or just the program name. But to use this option,  
> we'll need
> to patch /sbin/new-kernel-pkg tool.
> 
> Alternatively, dracut(8) could be patched to recognise and read
> $INITRD_COMPRESS variable and internally it can define precedence  
> order
> between environment variable, command-line options and default  
> fall-back
> option.

How does your code get called?

Rob
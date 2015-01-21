Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbbAUUik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 15:38:40 -0500
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:56084 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbbAUUie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 15:38:34 -0500
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Wed, 21 Jan 2015 15:38:32 -0500
To: Tobias Powalowski <tobias.powalowski@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Possible bug in initramfs RAM handling
Message-ID: <20150121203832.GB30247@csclub.uwaterloo.ca>
References: <54B3F44F.2010408@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B3F44F.2010408@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 05:20:31PM +0100, Tobias Powalowski wrote:
> I have a weird bug here with initramfs,
> I have big initramfs files around 150MB zipped, 400MB extracted.
> I suppose the needed RAM to boot this setup should be around:
> 150MB zipped initramfs+ 400MB extracted initramfs + 5MB kernel image.
> Our distro kernel has tmpfs support, booting this setup without kernel
> parameter needs around 1000MB RAM to boot.
> Using rootfstype=ramfs makes it work with around 600MB RAM.
> 
> Is this a bug in kernel code?
> Shouldn't both types not use the same amount of RAM?
> I used kernel 3.18.2 at the moment but issue is reproducable with 3.15 too.

tmpfs defaults to size=50%, meaning it can not use more than half the
ram in the system.  Could that be your problem?

After all if the extracted size is 400MB, and tmpfs limit is 50% of ram,
that alone means it must have at least 800MB of ram to allow extracting
to tmpfs.  Add in the 150MB compressed size and you are close to your
1000MB value.  ramfs probably has no such limit and hence you can get
by with 600MB.

Maybe 'rootflags=size=90%' or something like that would help.
Not entirely sure if that is the correct syntax.

-- 
Len Sorensen

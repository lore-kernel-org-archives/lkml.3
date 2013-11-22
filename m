Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab3KVBzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 20:55:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021Ab3KVBzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 20:55:47 -0500
Date: Thu, 21 Nov 2013 20:55:18 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, hpa@zytor.com,
        mjg59@srcf.ucam.org, greg@kroah.com
Subject: Re: [PATCH 0/6] kexec: A new system call to allow in kernel loading
Message-ID: <20131122015518.GA31921@redhat.com>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
 <8761rl73s7.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8761rl73s7.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 03:07:04PM -0800, Eric W. Biederman wrote:

[..]
> 
> Before you are done we need an ELF loader.  bzImage really is very
> uninteresting.  To the point I am not at all convinced that an in kernel
> loader should support it.

Hi Eric,

Why ELF case is so interesting. I have not use kexec to boot ELF
images in years and have not seen others using it too. In fact bzImage
seems to be the most common kernel image format for x86, most of the distros
ship and use.

So first I did the loader for the common use case. There is no reason 
that one can't write another loader for ELF images. It just bloats
the code. Hence I thought that other image loaders can follow slowly. I am
not sure why do you say that bzImage is uninteresting. 

> 
> There is also a huge missing piece of this in that your purgatory is not
> checking a hash of the loaded image before jumping too it.  Without that
> this is a huge regression at least for the kexec on panic case.  We
> absolutely need to check that the kernel sitting around in memory has
> not been corrupted before we let it run very far.

Agreed. This should not be hard. It is just a matter of calcualting
digest of segments. I will store it in kimge and verify digest again
before passing control to control page. Will fix it in next version.

Thanks
Vivek

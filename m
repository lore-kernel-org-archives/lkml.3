Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab3EUQdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 12:33:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52215 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab3EUQdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 12:33:13 -0400
Date: Tue, 21 May 2013 09:33:12 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/base: Use attribute groups to create sysfs
 memory files
Message-ID: <20130521163312.GA27705@kroah.com>
References: <518A78CC.2000501@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518A78CC.2000501@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 11:09:48AM -0500, Nathan Fontenot wrote:
> Update the sysfs memory code to create/delete files at the time of device
> and subsystem registration.
> 
> The current code creates files in the root memory directory explicitly through
> the use of init_* routines. The files for each memory block are created and
> deleted explicitly using the mem_[create|delete]_simple_file macros.
> 
> This patch creates attribute groups for the memory root files and files in
> each memory block directory so that they are created and deleted implicitly
> at subsys and device register and unregister time.
>  
> This did necessitate moving the register_memory() and unregister_memory()
> routines in the file. There are no changes to unregister_memory, the
> register_memory routine is only updated to set the dev.groups field.
> 
> Signed-off-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>
> 
> Please cc me on responses/comments.
> ---
>  drivers/base/memory.c |  163 ++++++++++++++++++++++----------------------------
>  1 file changed, 72 insertions(+), 91 deletions(-)

This doesn't seem to apply to 3.10-rc2, can you refresh it and resend it
so that I can apply it?

thanks,

greg k-h

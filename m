Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933899Ab3E3PgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 11:36:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933196Ab3E3PgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 11:36:06 -0400
Date: Thu, 30 May 2013 11:35:51 -0400
From: Kyle McMartin <kmcmarti@redhat.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, udknight@gmail.com,
        Greg KH <gregkh@linuxfoundation.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] arch: parisc: kernel: using strlcpy() instead of strcpy()
Message-ID: <20130530153551.GN19205@redacted.bos.redhat.com>
References: <51A6A8F3.2030200@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A6A8F3.2030200@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 09:18:43AM +0800, Chen Gang wrote:
> 
> 'boot_args' is an input args, and 'boot_command_line' has a fix length.
> 
> So need use strlcpy() instead of strcpy() to avoid memory overflow.
> 

This is basically impossible, since boot_args is fixed in size by palo,
initialized to zero, and length checked in the bootloader. It's also
only 256+4 bytes compared to the 1024 bytes set aside for
boot_command_line.

That said, it's harmless to use strlcpy here, and obviously (more)
correct. Thanks!

Acked-by: Kyle McMartin <kyle@mcmartin.ca>

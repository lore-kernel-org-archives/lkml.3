Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359Ab3B0LPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 06:15:09 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:58268 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521Ab3B0LPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 06:15:07 -0500
Date: Wed, 27 Feb 2013 12:15:02 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: bug in generic strncpy_from_user
Message-ID: <20130227111502.GE4832@osiris>
References: <20130226045424.GA3576@osiris>
 <CA+55aFx8pUSHPhC_-ob2i5BbvBkEC4BVYtAbNkf3+FE+=3AmgA@mail.gmail.com>
 <20130226125739.GA3924@osiris>
 <CA+55aFycXwZi-U2uJWWusLGeaV3=BMEBdgcxGN9Lo0QcHHUrDA@mail.gmail.com>
 <CA+55aFzCU3jKDssYj9sDJU-VkugCfy_Cv5+VhMv9renZ94jRdQ@mail.gmail.com>
 <CA+55aFzckUoJGEywgentKT-vQieiuLu-mQtELiA6UotWqBWH7A@mail.gmail.com>
 <CA+55aFz3JW6HnTC-4xqOBsgQNboLbjvZnQ0h7KfaZjQVinAt2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz3JW6HnTC-4xqOBsgQNboLbjvZnQ0h7KfaZjQVinAt2g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022711-3548-0000-0000-000004A92CAE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 04:30:50PM -0800, Linus Torvalds wrote:
> On Tue, Feb 26, 2013 at 3:43 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > So I'll need to extend on that logic a bit more.
> 
> Ok, here's the fleshed-out patch. Also fixed to use "expand_stack()",
> which is what the page fault handling actually uses. And it has the
> GROWSUP case as well as a comment about this all.
> 
> So it all looks good. But it's still totally and entirely untested.

Tested with 64 bit kernel with 64 bit and 31 bit mode user space as well as
with 31 bit kernel and 31 bit user space. Each with legacy and flexible
mmap layout.
The bug is fixed and everything else still seems to work. Thanks!

Tested-By: Heiko Carstens <heiko.carstens@de.ibm.com>


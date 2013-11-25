Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194Ab3KYRZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 12:25:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47029 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab3KYRZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 12:25:09 -0500
Date: Mon, 25 Nov 2013 09:25:08 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCHv2] staging: go7007: fix use of uninitialised pointer
Message-ID: <20131125172508.GA3874@kroah.com>
References: <1384108677-23476-1-git-send-email-mpn@google.com>
 <20131110185210.GA9633@kroah.com>
 <87fvr480o9.fsf@mina86.com>
 <20131110210647.GA5302@mwanda>
 <xa1tzjpbxisv.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <xa1tzjpbxisv.fsf@mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 12:46:24PM +0100, Michal Nazarewicz wrote:
> go variable is initialised only after the switch case so it cannot be
> dereferenced prior to that happening.
> 
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> ---
>  drivers/staging/media/go7007/go7007-usb.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> On Sun, Nov 10 2013, Dan Carpenter wrote:
> > There are 3 other uses before "go" gets initialized.
> 
> Argh...  Other occurrences of the letters “GO” deceived my eyes.  Sorry
> about that and thanks.

This is no longer needed, as I revertd the patch that caused the
original problems, sorry.

greg k-h

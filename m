Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771Ab3KRXD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 18:03:56 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34251 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab3KRXDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 18:03:54 -0500
Date: Mon, 18 Nov 2013 23:03:39 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Heorhi Valakhanovich <valahanovich@tut.by>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH] tty: Only hangup once
Message-ID: <20131118230339.5402fac4@alan.etchedpixels.co.uk>
In-Reply-To: <528A5043.6030901@hurleysoftware.com>
References: <1375293945-4087-1-git-send-email-peter@hurleysoftware.com>
	<20131117203850.46df2124@tormoz-pc>
	<20131118134211.17861db3@alan.etchedpixels.co.uk>
	<528A5043.6030901@hurleysoftware.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I doubt this is caused by a race condition; the first hangup would do most
> of the destruction regardless, and a second hangup can't really race with
> the first because of the tty_lock() held for most of the hangup.
> 
> In any event, it's worth discovering what state a subsequent hangup can
> effect that the first hangup left incomplete. I'll look into it.
> 
> Regards,
> Peter Hurley

disassociate_ctty races with tty_hangup.

tty->pgrp is only protected by ctrl_lock

See no_tty and the FIXME note. Sorry the FIXME wasn't clearer.


Alan

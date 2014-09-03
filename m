Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283AbaICMTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:19:35 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:52031 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170AbaICMTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:19:33 -0400
Date: Wed, 3 Sep 2014 13:19:19 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 21/26] tty: Convert tty_struct bitfield to bools
Message-ID: <20140903131919.0d970b6f@alan.etchedpixels.co.uk>
In-Reply-To: <54070643.9080903@hurleysoftware.com>
References: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
	<1409693975-1028-22-git-send-email-peter@hurleysoftware.com>
	<20140903115852.5a720754@alan.etchedpixels.co.uk>
	<54070643.9080903@hurleysoftware.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ahh. Thanks for the insight, Alan.
> 
> But set_bit() et. al. will generate an incredible amount of churn;
> what if I split the fields up to prevent false-sharing?

Do you feel lucky ;-)

I'd rather set_bit and friends were used. They exist largely for this
kind of reason and they also have atomic test/set methods which may in
the longer term be very useful.

Yes it is churn can't argue with that.

Alan

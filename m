Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaDCPnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:43:50 -0400
Received: from mx4.wp.pl ([212.77.101.11]:25933 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbaDCPnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:43:42 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Apr 2014 11:43:42 EDT
Date: Thu, 3 Apr 2014 17:37:01 +0200
From: Jakub =?UTF-8?B?S2ljacWEc2tp?= <moorray3@wp.pl>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rt2x00: BUG: remove double loop on REGISTER_BUSY_COUNT
Message-ID: <20140403173701.75c1f497@north>
In-Reply-To: <1396534327-12971-1-git-send-email-richard.genoud@gmail.com>
References: <1396534327-12971-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: Claws Mail 3.9.3-24-gf407e3 (GTK+ 2.24.22; x86_64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [EVPE]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  3 Apr 2014 16:12:07 +0200, Richard Genoud wrote:
> rt2x00usb_register_read_lock() calls rt2x00usb_vendor_req_buff_lock()
> that calls rt2x00usb_vendor_request() which is already looping up to
> REGISTER_BUSY_COUNT times.
> 
> So this loop is not needed.

Not true.  rt2x00usb_vendor_request() busy-waits for usb_control_msg()
to succeed, rt2x00usb_register_read_lock() busy-waits for the register
field itself to become 0.

Also, how would this be a BUG? 

	-- kuba

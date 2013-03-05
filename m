Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab3CEUuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 15:50:44 -0500
Received: from www.linutronix.de ([62.245.132.108]:39102 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276Ab3CEUul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 15:50:41 -0500
Date: Tue, 5 Mar 2013 21:50:33 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>,
        Sasha Levin <levinsasha928@gmail.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ilya Zykov <ilya@ilyx.ru>,
        Dave Jones <davej@redhat.com>
Subject: Re: [PATCH v3 00/23] ldisc fixes
Message-ID: <20130305205033.GA5771@linutronix.de>
References: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com>
 <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Hurley | 2013-02-05 15:20:15 [-0500]:

>  Please re-test with your dummy_hcd/g_nokia testcase, although
>  I'm not convinced that usb gadget is using tty_hangup() appropriately.
>  tty drivers use this for async carrier loss coming from an IRQ
>  which will be disabled if the tty has been shutdown. Does gserial
>  prevent async hangup to a dead tty in a similar fashion?

Not sure I understood. tty_hangup() is only called from within
gserial_disconnect() which calls right after usb_ep_disable(). After
usb_ep_disable() no further serial packets can be received until the
endpoints are re-enabled. This happens in gserial_connect().

Sebastian

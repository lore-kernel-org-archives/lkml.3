Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab3KUWsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 17:48:38 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:52088 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab3KUWsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 17:48:36 -0500
MIME-Version: 1.0
In-Reply-To: <CANEJEGtXOjxj+85QVfWFGH6WuxxCz6uAfEuUo7bv9YEwh_8OAw@mail.gmail.com>
References: <1384913496-26261-1-git-send-email-freddy@asix.com.tw>
	<20131120.004026.2013972041095203460.davem@davemloft.net>
	<CANEJEGtBmvFNcFzOW9ZnOFd=ZMnz82ajcN52YqW3+n0+=rhxBA@mail.gmail.com>
	<20131120.135413.920731121262719289.davem@davemloft.net>
	<CANEJEGtXOjxj+85QVfWFGH6WuxxCz6uAfEuUo7bv9YEwh_8OAw@mail.gmail.com>
Date: Thu, 21 Nov 2013 14:48:35 -0800
Message-ID: <CANEJEGu_2YdVOjcnzh30RPMiP0KC5bL6JasxMS_+1xV9poxgQw@mail.gmail.com>
Subject: Re: [PATCH 1/1] Workaround for Suspend/Resume issue of AX88772B under ChromeOS
From: Grant Grundler <grundler@google.com>
To: David Miller <davem@davemloft.net>
Cc: Freddy Xin <freddy@asix.com.tw>, netdev <netdev@vger.kernel.org>,
        linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        davemloft@davemloft.net,
        =?UTF-8?B?QVNJWCBMb3VpcyBb6JiH5aiB6Zm4XQ==?= <louis@asix.com.tw>,
        Allan Chou <allan@asix.com.tw>, Daniel_ASIX <daniel@asix.com.tw>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 11:32 AM, Grant Grundler <grundler@google.com> wrote:
> Seems like this should be part of usbnet_resume code based on whether
> the driver provides mdio_write hook (most USBNET drivers do).

Just to be clear: I don't think this is feasible for the now obvious
reason that not all device lose phy stat on resume. :/

Freddy sent me a patch that saves/restores MII_ADVERTISE and MII_BMCR
registers. Testing that now and he'll post if that all works out.

thanks,
grant

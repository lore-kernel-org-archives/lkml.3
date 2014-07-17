Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbaGQSAC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 14:00:02 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:49084 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbaGQR7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 13:59:20 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1407171053330.1517-100000@iolanthe.rowland.org>
References: <5255a576a562f60c185e89b5937357290242fe1e.1405586653.git.amit.virdi@st.com>
	<Pine.LNX.4.44L0.1407171053330.1517-100000@iolanthe.rowland.org>
Date: Thu, 17 Jul 2014 10:59:18 -0700
Message-ID: <CAJJ6jxs9aYOZO+2dBCCa2hP8qzpchD0g2uGYGzGsnOe-e0rRjA@mail.gmail.com>
Subject: Re: [PATCH] usb: core: allow zero packet flag for interrupt urbs
From: Steve Calfee <stevecalfee@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Amit Virdi <amit.virdi@st.com>, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org, rdunlap@infradead.org,
        ming.lei@canonical.com, Hans de Goede <hdegoede@redhat.com>,
        hsi-ss-sw-devel@lists.codex.cro.st.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 7:55 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
>
> I can't say this is actually wrong, but have you ever encountered a
> situation where this would be needed?  How often does anyone need to do
> a multi-packet transfer over an interrupt endpoint?
>
Hi Alan,

I did some testing with multi interrupt transfers some time ago. You
can get allocated a guaranteed 3x1024 time slot per uframe for an
interval of your choice on usb 2.0. So zlps are needed to send exactly
1024 or 2048 bytes in that time slot. Also, interrupt transfers are
crc checked and resent (as long as uframe time is still available). So
you get guaranteed timing like iso sends, and guaranteed data like
bulk sends. This could be valuable for time sensitive apps with known
data capacities.

Microsoft only started supporting multi-interrupt transfers in Windows
Vista and beyond. Winxp refuses to die, so probably no one has built
an actual hardware device for consumers that uses multi-interrupt
xfers up to now.

Regards, Steve

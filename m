Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbbATLDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:03:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46944 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535AbbATLDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:03:46 -0500
Message-ID: <1421751814.29486.13.camel@linux-0dmf.site>
Subject: Re: USB autosuspend causing trouble with bluetooth
From: Oliver Neukum <oneukum@suse.de>
To: Kirill Elagin <kirelagin@gmail.com>
Cc: linux-kernel@vger.kernel.org, marcel@holtmann.org
Date: Tue, 20 Jan 2015 12:03:34 +0100
In-Reply-To: <CABVT_gf-rx0ymvtCrCotkO5=qoDifG1yAMg8U_aTgXEN=x6gvg@mail.gmail.com>
References: <CABVT_gf-rx0ymvtCrCotkO5=qoDifG1yAMg8U_aTgXEN=x6gvg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2015-01-18 at 17:30 +0400, Kirill Elagin wrote:
> Hello,
> 
> Recently I started having issues with my Apple Magic Trackpad and I
> realised that the problem was with autosuspend. Whenever I have `auto`
> in `power/control` of my BT adapter, `btmon` shows no packets,
> nothing. As soon as I `echo on`, all the missing packets arrive.

You are not getting remote wakeups. There are two possibilities

1. the firmware of your BT adapter is faulty and the device needs to
be added to the list of quirky devices

2. a bug in the kernel breaks remote wakeup.

We need to distinguish these cases. Could you connect another device
that uses remote wakeup (HID, CDC-ACM, ... - a keyboard or a mouse is
easiest) to a port connected to XHCI and test autosuspend on that
device?

	Regards
		Oliver





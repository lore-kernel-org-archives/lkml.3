Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728Ab3CTB3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 21:29:47 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56675 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab3CTB3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 21:29:46 -0400
Message-ID: <51491107.5060001@wwwdotorg.org>
Date: Tue, 19 Mar 2013 19:29:43 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Andreas Bombe <aeb@debian.org>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Regression] process hangs due to "USB: EHCI: work around silicon
 bug in Intels EHCI controllers"
References: <20130320000336.GA8912@amos.fritz.box>
In-Reply-To: <20130320000336.GA8912@amos.fritz.box>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 06:03 PM, Andreas Bombe wrote:
> The named commit (6402c796d3) causes a process to hang indefinitely in
> usb_kill_urb(). Reverting it fixes the problem. The bug also prevents
> suspend/shutdown/reboot from completing, presumably due to the hanging
> process.
> 
> (Cc'ing Stephen Warren because I only found his report after I bisected
> it myself. Do you also see a blocked process?)

Yes, I believe the symptoms we're both seeing are identical.

> This is the hanging process on my system:
> [  240.364085] INFO: task colord-sane:3619 blocked for more than 120 seconds.
...
> [  240.364118] Call Trace:
> [  240.364127]  [<ffffffff81685af0>] schedule+0x65/0x67
> [  240.364132]  [<ffffffff8141a235>] usb_kill_urb+0xb5/0xd3

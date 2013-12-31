Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab3LaUke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 15:40:34 -0500
Received: from plane.gmane.org ([80.91.229.3]:59256 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756554Ab3LaUkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 15:40:33 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: walt <w41ter@gmail.com>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst
Date: Tue, 31 Dec 2013 12:40:16 -0800
Message-ID: <52C32BB0.90600@gmail.com>
References: <20131218211219.461663463@linuxfoundation.org> <20131218211220.412278148@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: adsl-69-234-187-142.dsl.irvnca.pacbell.net
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
In-Reply-To: <20131218211220.412278148@linuxfoundation.org>
Cc: stable@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 01:11 PM, Greg Kroah-Hartman wrote:
> 3.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: David Laight <David.Laight@ACULAB.COM>
> 
> commit 35773dac5f862cb1c82ea151eba3e2f6de51ec3e upstream.
> 
> Section 4.11.7.1 of rev 1.0 of the xhci specification states that a link TRB
> can only occur at a boundary between underlying USB frames (512 bytes for
> high speed devices).
> 
> If this isn't done the USB frames aren't formatted correctly and, for example,
> the USB3 ethernet ax88179_178a card will stop sending...


Unfortunately this patch causes a regression when copying large files to my
outboard USB3 drive. (Nothing at all to do with networking.)

When I try to copy a large (20GB) file to the USB3 drive, the copy dies after
about 7GB, the ext4 journal aborts and the drive is remounted read-only.

This bug is 100% reproducible (always pretty close to 7GB) and reverting this
patch completely fixes the problem.

(Note to Sarah:  I recently emailed you about this problem, and I *wrongly*
said that reverting the patch doesn't help.  That was a mistake, sorry.)

I'm happy to try any debugging suggestions/tricks.

BTW, please tell me if I've cc'd too many people.


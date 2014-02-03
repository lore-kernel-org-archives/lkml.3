Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaBCUS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 15:18:56 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:48897 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaBCUSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 15:18:54 -0500
MIME-Version: 1.0
In-Reply-To: <20140203201228.GE26722@mwanda>
References: <52ee2ee736e00_2c3211fc86c5851f@209.249.196.67.mail>
	<20140202160512.GA4946@redhat.com>
	<201402021807.37772.s.L-H@gmx.de>
	<52EFCC66.9020304@lwfinger.net>
	<20140203201228.GE26722@mwanda>
Date: Mon, 3 Feb 2014 12:18:53 -0800
X-Google-Sender-Auth: IlAJ363lYn3r6ttb7riAr8KRSHo
Message-ID: <CA+55aFyHZfw9rtZQJ9i2p7MQAVX4iM0QCdzRZzaivD2nRDHeLQ@mail.gmail.com>
Subject: Re: rtl8821ae.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Stefan Lippers-Hollmann <s.L-H@gmx.de>, Dave Jones <davej@redhat.com>,
        Andrea Merello <andrea.merello@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Driver Project <devel@linuxdriverproject.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 3, 2014 at 12:12 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Mon, Feb 03, 2014 at 11:05:42AM -0600, Larry Finger wrote:
>> A combined driver would require very many branches based on chip
>> number and would certainly execute much more slowly.
>
> I seriously doubt there are performance issues with merging the drivers.

Quite frankly, merging drivers can be a f*cking pain. I would
seriously suggest avoiding it *unless* the hardware is literally
almost identical, or the drivers have been written with multi-chip
support from the ground up by people who actually understood the
hardware.

But the reason isn't performance - it's subtle breakage. Merged
drivers have a tendency to break support for chip A when you fix
something for chip B. And the end result is a driver that nobody
understands, and nobody can sanely test.

Sometimes it's simply better to leave old drivers alone.

                  Linus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933442Ab3CSSni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 14:43:38 -0400
Received: from mout.gmx.net ([212.227.15.18]:49956 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640Ab3CSSng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 14:43:36 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX1/+29ZW4sj+1wPa+g736d61a0yTHzWPpfHA7a/M7u
	ElpKJjMGlfM7gZ
From: Sven Joachim <svenjoac@gmx.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Stephen Thirlwall <sdt@dr.com>
Subject: Re: [ 12/75] USB: EHCI: work around silicon bug in Intels EHCI controllers
References: <Pine.LNX.4.44L0.1303191415580.1302-100000@iolanthe.rowland.org>
Date: Tue, 19 Mar 2013 19:43:28 +0100
In-Reply-To: <Pine.LNX.4.44L0.1303191415580.1302-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Tue, 19 Mar 2013 14:17:10 -0400 (EDT)")
Message-ID: <87ehfbjkmn.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-03-19 19:17 +0100, Alan Stern wrote:

> On Tue, 19 Mar 2013, Sven Joachim wrote:
>
>> On 2013-03-18 22:06 +0100, Greg Kroah-Hartman wrote:
>> 
>> > 3.8-stable review patch.  If anyone has any objections, please let me know.
>> 
>> This patch breaks resume from suspend on my system if the following
>> device is plugged in:
>> 
>> ,----
>> | $ lsusb | head -n1
>> | Bus 005 Device 002: ID 07d1:3c03 D-Link System AirPlus G DWL-G122 Wireless Adapter(rev.C1) [Ralink RT2571W]
>> `----
>> 
>> The same problem exists in 3.9-rc3, FWIW.
>> 
>> Detailed lsusb output follows, I'll be happy to provide more information
>> if needed.
>
> In what way is resume broken?

The kernel comes back, but the screen is black.  Manually switching VT's
is possible, and if I type something I can see it on the screen, but
there is no response and the cursor does not blink.  It looks as if the
VT is not switched backed on resume, and userspace tasks are not
restarted.  Sysrq combinations apparently work, but produce no output.

Cheers,
       Sven

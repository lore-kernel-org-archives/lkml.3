Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168AbaJaKDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 06:03:39 -0400
Received: from svenfoo.org ([82.94.215.22]:52408 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756368AbaJaKDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 06:03:37 -0400
Message-ID: <54535E76.9050208@zonque.org>
Date: Fri, 31 Oct 2014 11:03:34 +0100
From: Daniel Mack <daniel@zonque.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Tom Gundersen <teg@jklm.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Tejun Heo <tj@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>, Ryan Lortie <desrt@desrt.ca>,
        Bastien Nocera <hadess@hadess.net>,
        David Herrmann <dh.herrmann@gmail.com>,
        Djalal Harouni <tixxdz@opendz.org>,
        Simon McVittie <simon.mcvittie@collabora.co.uk>,
        "alban.crequy" <alban.crequy@collabora.co.uk>,
        "javier.martinez" <javier.martinez@collabora.co.uk>
Subject: Re: kdbus: add header file
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <6078917.F7Y7rNpK9C@wuerfel> <5452269A.9050003@zonque.org> <3334170.rJW8YMf1Nv@wuerfel>
In-Reply-To: <3334170.rJW8YMf1Nv@wuerfel>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2014 01:03 PM, Arnd Bergmann wrote:
> On Thursday 30 October 2014 12:52:58 Daniel Mack wrote:

>> Hmm, this is the header exported to userspace, so having enums in would
>> make our lives easier, right?
> 
> My point was that you never use the enum by type and the only place in
> user space where it's referenced would be something like
> 
> 	ret = ioctl(fd, KDBUS_CMD_BUS_MAKE, &make);
> 
> In the debugger, you will see the source line here. If you trace into the
> glibc ioctl function, you no longer know the type because that just
> has an 'int'.

Alright - I changed that to #defines now.


Thanks,
Daniel


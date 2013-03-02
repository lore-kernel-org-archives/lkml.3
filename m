Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab3CBNlO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 08:41:14 -0500
Received: from www.linutronix.de ([62.245.132.108]:52285 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab3CBNlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 08:41:13 -0500
Message-ID: <51320173.6000802@linutronix.de>
Date: Sat, 02 Mar 2013 14:41:07 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Felipe Balbi <balbi@ti.com>, Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [usb gadget] WARNING: at kernel/mutex.c:198 __mutex_lock_common()
References: <20130206020424.GB1175@localhost> <20130227104935.GZ8016@arwen.pp.htv.fi> <20130302133736.GA13058@localhost>
In-Reply-To: <20130302133736.GA13058@localhost>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2013 02:37 PM, Fengguang Wu wrote:
> On Wed, Feb 27, 2013 at 12:49:35PM +0200, Felipe Balbi wrote:
>> Hi,
>>
>> On Wed, Feb 06, 2013 at 10:04:24AM +0800, Fengguang Wu wrote:
>>> Greetings,
>>>
>>> I got the below warning and the first bad commit is
>>
>> can you send a fixup patch ?
> 
> Sorry I don't have the fix. Maarten once proposed
> 
> : Can you change __mutex_lock_common from inline to __always_inline and
> : check if that gets rid of the warning?
> 
> and it worked at that time, however it does not work today when I
> go out to double check the below patch...

This does not get even close to a fix, not to mention a proper one. The
problem is that a spinlock is hold while a mutex is going to be taken.
Maybe I get to this…

Sebastian

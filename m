Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab3GSVAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 17:00:39 -0400
Received: from science.horizon.com ([71.41.210.146]:33131 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752552Ab3GSVAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 17:00:38 -0400
Date: 19 Jul 2013 17:00:36 -0400
Message-ID: <20130719210036.5543.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: hpa@zytor.com, linux@horizon.com
Subject: Re: 3.10.0 i386 uniprocessor panic
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <51E974A9.3050608@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> EIP is at 0xc143a091
>> EAX: c143a090 EBX: 00000100 ECX: f3150000 EDX: c143a090
>> ESI: c143a090 EDI: c143a090 EBP: c143a090 ESP: f3151eec
>>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
>> CR0: 80050033 CR2: a090c143 CR3: 331c6000 CR4: 000007d0
>> DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
>> DR6: ffff0ff0 DR7: 00000400

>> (The CR2 value looks particularly odd.)

> Indeed it does; it is a user space value, but it doesn't look like
> either a normal user space value nor really as a trivially buggered-up
> kernel pointer value, unless the 0xc143... at the bottom is the upper
> half of a kernel pointer, in which case we probably obtained this value
> from a corrupt, misaligned pointer.

Er... I assumed you'd see instantly that it was the 0xc143a090 value
that's in 5 registers (EAX/EDX/ESI/EDI/EBP), and IP-1, but with the
halves swapped.

How the heck the halves got swapped is confusing me...

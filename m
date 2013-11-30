Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751271Ab3K3Hal (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 02:30:41 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:56186 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab3K3Hah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 02:30:37 -0500
Message-ID: <52999419.7040600@linux.com>
Date: Sat, 30 Nov 2013 08:30:33 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, EDAC <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: mcheck: call put_device on device_register failure
References: <5298F900.9000208@linux.com> <20131129205628.GA20144@pd.tnic>
In-Reply-To: <20131129205628.GA20144@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-11-29 21:56, Borislav Petkov:
> On Fri, Nov 29, 2013 at 09:28:48PM +0100, Levente Kurusa wrote:
>> This patch adds a call to put_device() when the device_register()
>> call has failed. This is required so that the last reference to the
>> device is given up.
> 
> I'd assume this is not something you're actually hitting but have caught
> this by code staring...?
> 

Yup, I have been staring at it.

> If we're going to do this, I'd also like to see you add another label
> after device_unregister(dev) which also kfrees dev because apparently
> we're not doing that either.
> 

No, if the call to put_device gives up the last reference to the device,
then device_release gets called which in turn frees the memory associated with it.
In this case, mce_device_release() will get called, which is just a simple kfree call.

-- 
Regards,
Levente Kurusa

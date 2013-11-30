Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab3K3LpJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 06:45:09 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35080 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab3K3LpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 06:45:03 -0500
Message-ID: <5299CFBB.4010209@linux.com>
Date: Sat, 30 Nov 2013 12:44:59 +0100
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
References: <5298F900.9000208@linux.com> <20131129205628.GA20144@pd.tnic> <52999419.7040600@linux.com> <20131130111214.GB4323@pd.tnic> <5299CB38.8090808@linux.com> <20131130113229.GD4323@pd.tnic>
In-Reply-To: <20131130113229.GD4323@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-11-30 12:32, Borislav Petkov:
> On Sat, Nov 30, 2013 at 12:25:44PM +0100, Levente Kurusa wrote:
>> Now this tree makes me wonder if there are devices where the author
>> forgot to set a device_release or when the put_device is not called. I
>> will take a look into this.
> 
> kobject_cleanup() warns about !t->release already.

Yes, I saw that as well. By that I meant that by doing some identifier searches
for device_register and then checking whether they call put_device and have device_release
registered. Also, I wonder if it would be beneficial to have a generic device_release? Most
of the drivers I quickly swept through only call kfree(). Wouldn't a generic one save
some space?

> 
> If you want to fix actual issues and not waste time with potential
> issues which have never actually triggered, try building a couple of
> randconfigs and look at the output :-)

Yes, I do that daily usually, but most of the time I only get some uninitialized warnings. :-)

> 
> Also, we have "make W=" which gives you even more :-)

What does that do? Never heard of it yet.

-- 
Regards,
Levente Kurusa

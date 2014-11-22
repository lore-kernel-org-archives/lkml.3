Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaKVPcE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 10:32:04 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:44766 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaKVPcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 10:32:01 -0500
MIME-Version: 1.0
In-Reply-To: <20141122094433.GA12152@pd.tnic>
References: <1416388961-24159-1-git-send-email-ruiv.wang@gmail.com>
	<20141119102954.GA5617@pd.tnic>
	<3908561D78D1C84285E8C5FCA982C28F3294198E@ORSMSX114.amr.corp.intel.com>
	<20141120101505.GA791@pd.tnic>
	<CANVTcTa++Ef04JSYpfrCVuua5B0Wv=ASyr_H7nfHSQ-vC9GV3Q@mail.gmail.com>
	<20141121164140.GA4274@pd.tnic>
	<3908561D78D1C84285E8C5FCA982C28F3294F888@ORSMSX114.amr.corp.intel.com>
	<20141121181334.GC4274@pd.tnic>
	<CANVTcTa_AVM01VeVBYiSiB3Q0sJagy2hh-xYAjJv70jCWoDHYA@mail.gmail.com>
	<20141122094433.GA12152@pd.tnic>
Date: Sat, 22 Nov 2014 23:32:00 +0800
Message-ID: <CANVTcTaz6pZ=oc0omXa-nPD8G3uOfCVKag-VC66x5gNeGkrgvQ@mail.gmail.com>
Subject: Re: [PATCH v3] x86/mce: Try printing all machine check banks known
 before panic
From: rui wang <ruiv.wang@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "Wang, Rui Y" <rui.y.wang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/14, Borislav Petkov <bp@alien8.de> wrote:
> On Sat, Nov 22, 2014 at 10:16:49AM +0800, rui wang wrote:
>> I think both possibilities are valid. But experiments show that the
>> error logs are not in the dmesg preserved by kdump in /var/crash/
>> after panic and reboot, and not in the mcelog.entry[] array in the
>> kernel. So they must be somewhere in user space memory. Even if we
>> have serial console connected we still can't cache them. The
>> difficulty is that there's no easy way to force a user space daemon to
>> do something during panic.
>>
>> The new banks_saved[] array acts like a safe guard when you pass
>> something to someone else - to prevent it from getting lost in the
>> interim.
>
> ... and instead of duplicating the mcelog functionality partially by
> adding yet another array of struct mces, simply change mcelog to not
> zero out its contents and dump the last 32 errors that passed through
> there.
>

But that means mcelog buffer will have to become circular, and we can
only dump the last 32 errors. There must be a reason why it wasn't
designed as circular. I guess its benefit is as Tony explained: on
systems where mcelog isn't run or run at a later time, we may lose the
first error which is more important.

There's valid reasons why people may not run mcelog, because they may
never see machine checks during their lifetime. However once their
machine panics due to a machine check, it suddenly becomes important.

Thanks
Rui

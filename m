Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726AbaGOVCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:02:31 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbaGOVC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:02:29 -0400
Message-ID: <53C596E0.50403@nod.at>
Date: Tue, 15 Jul 2014 23:02:24 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Fabian Frederick <fabf@skynet.be>, LKML <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH 1/1] fs/ubifs/super.c: replace seq_printf by seq_puts
References: <1405452395-9296-1-git-send-email-fabf@skynet.be>	<CAFLxGvyaye+hKGv5L9ZuZAwZNb7FaVpg_n-abSGAmPu+YDc+hQ@mail.gmail.com> <20140715135932.879df4f901ac58338d387a35@linux-foundation.org>
In-Reply-To: <20140715135932.879df4f901ac58338d387a35@linux-foundation.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 15.07.2014 22:59, schrieb Andrew Morton:
> On Tue, 15 Jul 2014 22:10:24 +0200 Richard Weinberger <richard.weinberger@gmail.com> wrote:
> 
>> On Tue, Jul 15, 2014 at 9:26 PM, Fabian Frederick <fabf@skynet.be> wrote:
>>> Fix checkpatch warnings:
>>> "WARNING: Prefer seq_puts to seq_printf"
>>
>> Can you explain why seq_puts() is preferred over seq_printf()?
> 
> - puts is presumably faster
> 
> - puts doesn't go rogue if you accidentally pass it a "%".
> 
> - this patch actually made fs/ubifs/super.o 12 bytes smaller. 
>   Perhaps because seq_printf() is a varargs function, forcing the
>   caller to pass args on the stack instead of in registers.

This needs to go into the commit message. :-)

Thanks,
//richard

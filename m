Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527AbaBWTGo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 14:06:44 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:34857 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaBWTGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 14:06:43 -0500
Message-ID: <530A46BF.4000107@gmail.com>
Date: Sun, 23 Feb 2014 21:06:39 +0200
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
CC: Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Pavel Machek <pavel@ucw.cz>, Sebastian Reichel <sre@ring0.de>,
        =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        kvalo@qca.qualcomm.com, linville@tuxdriver.com
Subject: Re: [BISECTED] ssh - Received disconnect from x.x.x.x: 2: Bad packet
 length 3149594624
References: <52FD08D1.3030405@gmail.com> <20140213182105.GN13576@mudshark.cambridge.arm.com> <52FD1243.9040706@gmail.com> <20140213192909.GO13576@mudshark.cambridge.arm.com> <52FE407C.3080002@gmail.com> <20140214162458.GF21986@mudshark.cambridge.arm.com> <52FE4E3F.6020407@gmail.com>
In-Reply-To: <52FE4E3F.6020407@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 14.02.2014 19:11, Ivaylo Dimitrov wrote:
>
>
> On 14.02.2014 18:24, Will Deacon wrote:
>>
>> You could try putting back the UNALIGNED_ACCESS in net/mac80211/rx.c and
>> commenting out the skb->len = desc->length  - PLCP_HEADER_LENGTH;  line
>> above.
>
> This seems to fix the issue too, but I am afraid there is more to be
> done, as I see
>
> Feb 14 18:33:46 Nokia-N900 kernel: [   88.599853] wlan0: authenticate
> with 00:23:cd:17:86:d0
> Feb 14 18:33:46 Nokia-N900 kernel: [   88.781860] wlan0: send auth to
> 00:23:cd:17:86:d0 (try 1/3)
> Feb 14 18:33:46 Nokia-N900 kernel: [   88.799804] wlan0: authenticated
> Feb 14 18:33:46 Nokia-N900 kernel: [   88.806243] wlan0: associating
> with AP with corrupt probe response
> Feb 14 18:33:46 Nokia-N900 kernel: [   88.814544] wlan0: associate with
> 00:23:cd:17:86:d0 (try 1/3)
> Feb 14 18:33:46 Nokia-N900 kernel: [   88.826416] wlan0: RX AssocResp
> from 00:23:cd:17:86:d0 (capab=0x431 status=0 aid=2)
>
> spit in dmesg log. AFAIR this is the first time I see "associating with
> AP with corrupt probe response" in dmesg, no matter of the kernel
> version. Despite of that error message, wlan seems to work as it should,
> so far. I guess we need the driver's author saying on the issue.
>
> Thanks,
> Ivo

ping?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933461AbaGOT56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:57:58 -0400
Received: from mail-yh0-f41.google.com ([209.85.213.41]:46146 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933253AbaGOT54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:57:56 -0400
MIME-Version: 1.0
X-Originating-IP: [88.89.217.209]
In-Reply-To: <20140715193926.GF26012@tuxdriver.com>
References: <1404980258-30853-1-git-send-email-teg@jklm.no>
 <1404980258-30853-30-git-send-email-teg@jklm.no> <20140715193926.GF26012@tuxdriver.com>
From: Tom Gundersen <teg@jklm.no>
Date: Tue, 15 Jul 2014 21:57:36 +0200
Message-ID: <CAG-2HqW53FvH5HnqfwtHqbYYROhTE0o4sN+=zzt=hindVxVuRA@mail.gmail.com>
Subject: Re: [PATCH v7 29/33] net: brcmfmac - set name assign type
To: "John W. Linville" <linville@tuxdriver.com>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        David Herrmann <dh.herrmann@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Brett Rudley <brudley@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list@broadcom.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 9:39 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> I don't seem to have a line with "NET_NAME_UNKNOWN" in this driver
> in any of my kernel trees.  What tree are you using for development?

This was patch part of the series introducing NET_NAME_UNKNOWN [0].
I'll resubmit this patch once the earlier patches introducing the
infrastructure have been applied.

Cheers,

Tom

[0]: <https://lkml.org/lkml/2014/7/10/94>.

> On Thu, Jul 10, 2014 at 10:17:34AM +0200, Tom Gundersen wrote:
>> The name is given by the firmware, so we assume it is predictable.
>>
>> Signed-off-by: Tom Gundersen <teg@jklm.no>
>> Cc: Brett Rudley <brudley@broadcom.com>
>> Cc: Arend van Spriel <arend@broadcom.com>
>> Cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>
>> Cc: Hante Meuleman <meuleman@broadcom.com>
>> Cc: John Linville <linville@tuxdriver.com>
>> Cc: linux-wireless@vger.kernel.org
>> Cc: brcm80211-dev-list@broadcom.com
>> ---
>>  drivers/net/wireless/brcm80211/brcmfmac/fweh.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
>> index f6990f2..8d32721 100644
>> --- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
>> +++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
>> @@ -201,7 +201,8 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
>>               brcmf_dbg(EVENT, "adding %s (%pM)\n", emsg->ifname,
>>                         emsg->addr);
>>               ifp = brcmf_add_if(drvr, ifevent->bssidx, ifevent->ifidx,
>> -                                emsg->ifname, NET_NAME_UNKNOWN, emsg->addr);
>> +                                emsg->ifname, NET_NAME_PREDICTABLE,
>> +                                emsg->addr);
>>               if (IS_ERR(ifp))
>>                       return;
>>               brcmf_fws_add_interface(ifp);
>> --
>> 1.9.3
>>
>>
>
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.

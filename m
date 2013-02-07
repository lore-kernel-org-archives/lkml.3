Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422673Ab3BGUYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 15:24:12 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:1551 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759387Ab3BGUYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 15:24:08 -0500
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <51140D3D.9020100@broadcom.com>
Date: Thu, 7 Feb 2013 21:23:25 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Joe Perches" <joe@perches.com>
cc: "Tim Gardner" <tim.gardner@canonical.com>, linux-kernel@vger.kernel.org,
        "Brett Rudley" <brudley@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        "Hante Meuleman" <meuleman@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Seth Forshee" <seth.forshee@canonical.com>,
        "Pieter-Paul Giesberts" <pieterpg@broadcom.com>,
        "Hauke Mehrtens" <hauke@hauke-m.de>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list@broadcom.com, netdev@vger.kernel.org
Subject: Re: [PATCH wireless-next] brcmsmac: avoid 512 byte stack
 variable
References: <1360268032-52414-1-git-send-email-tim.gardner@canonical.com>
 <1360268386.27863.2.camel@joe-AO722>
In-Reply-To: <1360268386.27863.2.camel@joe-AO722>
X-Enigmail-Version: 1.4.6
X-WSS-ID: 7D0AD3571YS1947775-19-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 09:19 PM, Joe Perches wrote:
> On Thu, 2013-02-07 at 13:13 -0700, Tim Gardner wrote:
>> Dynamically allocate the probe response template which
>> avoids potential stack corruption. Observed with smatch:
> 
> trivial:
> 
>> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> []
>> @@ -7408,9 +7408,16 @@ brcms_c_bss_update_probe_resp(struct brcms_c_info *wlc,
> []
>> +	prb_resp = kmalloc(BCN_TMPL_LEN, GFP_ATOMIC);
>> +	if (!prb_resp) {
>> +		wiphy_err(wlc->wiphy, "wl: %s: failed to alloc %u bytes\n",
>> +			__func__, BCN_TMPL_LEN);
> 
> Please remove the error message.
> alloc's don't need specific OOM messages.
> 
> The mm subsystem already provides a standardized
> message with a dump_stack().

You beat me to the finish line :-)

Gr. AvS



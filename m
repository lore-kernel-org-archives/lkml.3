Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933081Ab3GVTFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 15:05:46 -0400
Received: from fep19.mx.upcmail.net ([62.179.121.39]:34701 "EHLO
	fep19.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932521Ab3GVTFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 15:05:44 -0400
X-SourceIP: 77.56.27.120
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <51ED8283.3060901@odi.ch>
Date: Mon, 22 Jul 2013 21:05:39 +0200
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Arend van Spriel <arend@broadcom.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [BUG] 3.10 regression: hang on suspend
References: <20130716065626.GA1587@redhat.com> <51E4F790.6090308@odi.ch> <51E51712.4020609@broadcom.com> <51E58FA5.4000804@odi.ch> <20130717122944.GA25894@redhat.com> <51E6E1AB.5010300@odi.ch> <20130718105550.GA4628@redhat.com> <51E83AB7.6020002@odi.ch> <20130719120842.GA1570@redhat.com> <51E9899E.3080307@odi.ch> <20130722112236.GA7364@redhat.com>
In-Reply-To: <20130722112236.GA7364@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 01:22 PM, Stanislaw Gruszka wrote:
> We remove interface that we do not add in the driver. I think I found
> reason of that - I removed below code in bad commit:
>
>          list_for_each_entry(sdata, &local->interfaces, list) {
> [snip]
> -               switch (sdata->vif.type) {
> -               case NL80211_IFTYPE_AP_VLAN:
> -               case NL80211_IFTYPE_MONITOR:
> -                       /* skip these */
> -                       continue;

Oh yes, that makes a lot of sense! I have an extra monitoring interface 
configured. If I remove that before suspend, the crash does not occur.

And your patch does fix the problem. Very nice!

Thank you,

Ortwin


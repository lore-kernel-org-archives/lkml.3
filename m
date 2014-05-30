Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601AbaE3EIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 00:08:54 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41468 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbaE3EIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 00:08:52 -0400
Message-ID: <53880434.7080002@ti.com>
Date: Fri, 30 May 2014 09:38:20 +0530
From: Satish Patel <satish.patel@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Rob Herring <robherring2@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v3 3/5] char: ti-usim: Add driver for USIM module on AM43xx
References: <1401267437-22489-1-git-send-email-satish.patel@ti.com> <1401267437-22489-4-git-send-email-satish.patel@ti.com> <CAL_JsqKs=a8GRJRmNE-oxU4imHqnb5szv+Km-wv3KuN0d6Bxkg@mail.gmail.com> <53870671.6080601@ti.com> <20140529155349.GD32214@kroah.com>
In-Reply-To: <20140529155349.GD32214@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 5/29/2014 9:23 PM, Greg Kroah-Hartman wrote:
> On Thu, May 29, 2014 at 03:35:37PM +0530, Satish Patel wrote:
>>>> +enum usim_card_mode {
>>>> +       USIM_CARD_MODE_ASYNC = 0,       /* asynchronous mode */
>>>> +       USIM_CARD_MODE_SYNC_TYPE1,      /* synchronous mode: Type 1 */
>>>> +       USIM_CARD_MODE_SYNC_TYPE2,      /* synchronous mode: Type 2 */
>>>> +       USIM_CARD_MODE_SYNC_OTHER,      /* Any other synchronous type */
>>>> +};
>>>> +struct usim_data {
>>>> +       int slot;
>>>> +       int rxexplen;
>>>> +       int txlen;
>>>> +       unsigned char apdu[256];
>>>> +};
>
> You need to use the proper variable types for a structure that is going
> to cross the user/kernel boundry in an ioctl :(
Do you mean to use __u32 instead int ? make use of types defined in 
types.h ? if yes, I will make that change :). Thanks for pointing out.
>

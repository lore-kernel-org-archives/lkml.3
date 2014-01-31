Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707AbaAaPvI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 10:51:08 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:46500 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932278AbaAaPvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 10:51:05 -0500
Message-ID: <52EBC650.50305@ti.com>
Date: Fri, 31 Jan 2014 10:50:40 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Grygorii Strashko <grygorii.strashko@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <ivan.khoronzhuk@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: keystone: switch to use runtime pm
References: <1391174426-13773-1-git-send-email-grygorii.strashko@ti.com> <20140131151955.GB20736@saruman.home> <52EBC499.2070302@ti.com> <20140131154721.GD20736@saruman.home>
In-Reply-To: <20140131154721.GD20736@saruman.home>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 January 2014 10:47 AM, Felipe Balbi wrote:
> On Fri, Jan 31, 2014 at 10:43:21AM -0500, Santosh Shilimkar wrote:
>> On Friday 31 January 2014 10:19 AM, Felipe Balbi wrote:
>>> Hi,
>>>
>>> On Fri, Jan 31, 2014 at 03:20:26PM +0200, Grygorii Strashko wrote:
>>>> The Keystone PM management layer has been implemented using PM bus for
>>>> power management clocks. As result, most of Keystone drivers don't need
>>>> to manage clocks directly. They just need to enable runtime PM and use it
>>>> to handle their PM state and clocks.
>>>>
>>>> Hence, remove clock management code and switch to use runtime PM.
>>>>
>>>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>>>
>>> quite a few weeks back I sent a series enabling runtime pm for all glue
>>> layers. I'll use that version instead, sorry.
>>>
>> That should be fine but you need to drop clk_*() related code
>> from that patch. I assume you will send refresh version of it then.
> 
> why ? it makes no difference if you enable twice and disable twice.
> 
Sure but why do you want to have the clock node handling code in drivers
if it is not needed. Isn't that better ?

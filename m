Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab3AaRZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 12:25:13 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:34737 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab3AaRZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 12:25:11 -0500
Message-ID: <510AA8F3.3020703@wwwdotorg.org>
Date: Thu, 31 Jan 2013 10:25:07 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mark Zhang <nvmarkzhang@gmail.com>
CC: Alexandre Courbot <gnurou@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "acourbot@nvidia.com" <acourbot@nvidia.com>
Subject: Re: [RFC 1/4] video: panel: add CLAA101WA01A panel support
References: <1359514939-15653-1-git-send-email-acourbot@nvidia.com> <1359514939-15653-2-git-send-email-acourbot@nvidia.com> <5108C9C1.1090707@gmail.com> <51098064.7030902@wwwdotorg.org> <5109EA2A.8020204@gmail.com> <CAAVeFuJf9Ww7g8Q9RAG9Na1SZq2-n2MMxcAEBek52ZVG7RpL7g@mail.gmail.com> <5109F916.8080404@gmail.com> <CAAVeFuL_a1aAEDCFdhjMzZG40QuK3dcZqsWqfVpwmQbZsfiHRg@mail.gmail.com> <510A1DAC.1070106@gmail.com>
In-Reply-To: <510A1DAC.1070106@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2013 12:30 AM, Mark Zhang wrote:
> On 01/31/2013 02:36 PM, Alexandre Courbot wrote:
>> On Thu, Jan 31, 2013 at 1:54 PM, Mark Zhang <nvmarkzhang@gmail.com> wrote:
>>> Display controller don't know whether the panel has EDID EEPROM but the
>>> panel driver knows. So why we need to make display controller queries
>>> EDID blindly? Since panel driver knows about all "video modes/panel
>>> size" stuffs, why not we let it handle all these things?
>>
>> The DC actually does know whether the connected panel supports EDID -
>> in this case, the output node will have a property for the DDC bus,
>> e.g.
>>
>>         nvidia,ddc-i2c-bus = <&lcd_ddc>;
>>
>> If no DDC bus is specified or if transfer fails, the DC driver can
>> still query the panel driver for hardcoded modes.
> 
> Strictly speaking, according to my understanding, "nvidia,ddc-i2c-bus"
> means tegra has a hardware ddc channel, this doesn't mean we can get the
> EDID from this DDC surely.

Having a DDC bus by definition means that the EDID can be queried
through it. If you can't query the EDID, there is no DDC bus, and hence
that property is not present in the DT.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645AbaCFBgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 20:36:09 -0500
Received: from mail-yh0-f52.google.com ([209.85.213.52]:38285 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757232AbaCFBgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 20:36:06 -0500
Message-ID: <5317D105.6050206@gmail.com>
Date: Wed, 05 Mar 2014 22:36:05 -0300
From: Juan Manuel Cabo <juanmanuel.cabo@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Kieran Clancy <clancy.kieran@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Joseph Salisbury <joseph.salisbury@canonical.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li Guang <lig.fnst@cn.fujitsu.com>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Dennis Jansen <dennis.jansen@web.de>
Subject: Re: [PATCH v2] ACPI / EC: Clear stale EC events on Samsung systems
References: <1393429360-4344-1-git-send-email-clancy.kieran@gmail.com> <53176D59.3030602@canonical.com> <CAGf84Q+7=abgk78WuhNWdy+3kgXma1fHj6OPk9ytQ4kFzcoFJA@mail.gmail.com> <1885040.WKp5oRmh5C@vostro.rjw.lan> <CAGf84QK-N+C6eHct4XDzOCHwfN649F2okJ1y2V70wWz-wHFKEA@mail.gmail.com>
In-Reply-To: <CAGf84QK-N+C6eHct4XDzOCHwfN649F2okJ1y2V70wWz-wHFKEA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Beware, the context line:        
             static struct dmi_system_id ec_dmi_table[] __initdata = {
has changed in recent kernels, so that line of the patch would need
to be different for it to apply older kernels.
It used to be this:
             static struct dmi_system_id __initdata ec_dmi_table[] = {
until 3.11 I guess.

It is just a context line and is not important for the patch itself.

See:
http://lxr.free-electrons.com/source/drivers/acpi/ec.c?v=3.11
http://lxr.free-electrons.com/source/drivers/acpi/ec.c?v=3.12

Cheers!
--Juan Manuel Cabo


On 03/05/2014 10:24 PM, Kieran Clancy wrote:
> On Thu, Mar 6, 2014 at 11:22 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> On Thursday, March 06, 2014 11:04:14 AM Kieran Clancy wrote:
>>> Rafael, is it a separate process to get this in the stable tree or
>>> will it naturally happen after being merged into the mainline?
>> I need to add a proper "CC stable" tag to your patch for this to happen.
>>
>> Which -stable kernels should it go to?
> 3.2 and 3.10 seem like natural choices (3.4?), but I don't know the
> norm for this kind of fix. Would there be any reason not to include it
> in some particular stable kernels?
>
> Cheers,
> Kieran.
>


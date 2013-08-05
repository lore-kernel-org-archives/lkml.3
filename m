Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab3HEQKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:10:16 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:46109 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab3HEQKN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:10:13 -0400
MIME-Version: 1.0
In-Reply-To: <CAPXgP13_WRX-asL=MwCM9ERDDMq_7PLkXLr9hwTG-xCg7cm6_A@mail.gmail.com>
References: <CALCETrU+C+sO8tJ0X5G4RDVLV=kHQQHurOnEQCoqbAouh60dng@mail.gmail.com>
 <20130802162850.GL32474@in.waw.pl> <CAPXgP13_WRX-asL=MwCM9ERDDMq_7PLkXLr9hwTG-xCg7cm6_A@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 5 Aug 2013 09:09:52 -0700
Message-ID: <CALCETrXSnFPFVPkXHwz+FFA3=+pmz9V=cMHWwtN+jG1QJALWSQ@mail.gmail.com>
Subject: Re: [systemd-devel] Slow firmware timeouts again (Re: [3.11
 regression?] iwlwifi firmware takes two minutes to load)
To: Kay Sievers <kay@vrfy.org>
Cc: =?ISO-8859-2?Q?Zbigniew_J=EAdrzejewski=2DSzmek?= 
	<zbyszek@in.waw.pl>,
        systemd-devel@lists.freedesktop.org,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org,
        Intel Linux Wireless <ilw@linux.intel.com>,
        Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 5, 2013 at 4:18 AM, Kay Sievers <kay@vrfy.org> wrote:
> On Fri, Aug 2, 2013 at 6:28 PM, Zbigniew Jêdrzejewski-Szmek
> <zbyszek@in.waw.pl> wrote:
>> On Fri, Aug 02, 2013 at 09:04:44AM -0700, Andy Lutomirski wrote:
>>> CONFIG_FW_LOADER_USER_HELPER=y
>> Do you need this? Unsetting this should help.
>>
>> """This option enables / disables the invocation of user-helper
>> (e.g. udev) for loading firmware files as a fallback after the
>> direct file loading in kernel fails. The user-mode helper is
>> no longer required unless you have a special firmware file that
>> resides in a non-standard path."""
>
> On recent systems, if the kernel configures
> CONFIG_FW_LOADER_USER_HELPER=y and a firmware is not found by the
> kernel, the kernel will issue a request which is ignored by userspace
> and will block in that for 60 seconds.
>
> Udev is no longer in the game of firmware loading, not even as a
> fallback, it will just completely ignore all kernel firmware class
> events.
>
> The source code in udev to handle firmware requests is disabled by
> default, currently still kept around for old kernels without the
> in-kernel firmware loader, but it will be deleted in the near future.

Any chance you'd consider a less regression-inducing path to getting
rid of this feature?  For example, have udev warn and immediate fail
firmware loading requests for a few releases, then just warn, then
drop support?

Meanwhile, CONFIG_FW_LOADER_USER_HELPER is still default y (!), so
udev has introduced massive bootup delays into the default
configuration with no warning.  It might be nice to change it to
default n, get rid of everything that selects it, and possible even
rename it to something with LEGACY or OBSOLETE in the name so that
make oldconfig will prompt.

--Andy

>
> Any issues with firmware timeouts should be addressed in the kernel by
> disabling CONFIG_FW_LOADER_USER_HELPER or by removing the fallback
> code from the in-kernel loader.
>
> Kay



-- 
Andy Lutomirski
AMA Capital Management, LLC

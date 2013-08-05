Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab3HELSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 07:18:39 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:59050 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab3HELSg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 07:18:36 -0400
MIME-Version: 1.0
In-Reply-To: <20130802162850.GL32474@in.waw.pl>
References: <CALCETrU+C+sO8tJ0X5G4RDVLV=kHQQHurOnEQCoqbAouh60dng@mail.gmail.com>
 <20130802162850.GL32474@in.waw.pl>
From: Kay Sievers <kay@vrfy.org>
Date: Mon, 5 Aug 2013 13:18:15 +0200
Message-ID: <CAPXgP13_WRX-asL=MwCM9ERDDMq_7PLkXLr9hwTG-xCg7cm6_A@mail.gmail.com>
Subject: Re: [systemd-devel] Slow firmware timeouts again (Re: [3.11
 regression?] iwlwifi firmware takes two minutes to load)
To: =?UTF-8?Q?Zbigniew_J=C4=99drzejewski=2DSzmek?= <zbyszek@in.waw.pl>
Cc: Andy Lutomirski <luto@amacapital.net>, systemd-devel@lists.freedesktop.org,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org,
        Intel Linux Wireless <ilw@linux.intel.com>,
        Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 2, 2013 at 6:28 PM, Zbigniew Jędrzejewski-Szmek
<zbyszek@in.waw.pl> wrote:
> On Fri, Aug 02, 2013 at 09:04:44AM -0700, Andy Lutomirski wrote:
>> CONFIG_FW_LOADER_USER_HELPER=y
> Do you need this? Unsetting this should help.
>
> """This option enables / disables the invocation of user-helper
> (e.g. udev) for loading firmware files as a fallback after the
> direct file loading in kernel fails. The user-mode helper is
> no longer required unless you have a special firmware file that
> resides in a non-standard path."""

On recent systems, if the kernel configures
CONFIG_FW_LOADER_USER_HELPER=y and a firmware is not found by the
kernel, the kernel will issue a request which is ignored by userspace
and will block in that for 60 seconds.

Udev is no longer in the game of firmware loading, not even as a
fallback, it will just completely ignore all kernel firmware class
events.

The source code in udev to handle firmware requests is disabled by
default, currently still kept around for old kernels without the
in-kernel firmware loader, but it will be deleted in the near future.

Any issues with firmware timeouts should be addressed in the kernel by
disabling CONFIG_FW_LOADER_USER_HELPER or by removing the fallback
code from the in-kernel loader.

Kay

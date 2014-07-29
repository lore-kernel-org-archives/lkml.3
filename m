Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbaG2Vwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 17:52:34 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:41748 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaG2Vwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 17:52:33 -0400
MIME-Version: 1.0
In-Reply-To: <2026468.U7VDB8Dm9m@vostro.rjw.lan>
References: <5386F2C7.8080400@redhat.com>
	<CAJ75kXYJL4jD=81NYPYpji9grJQkzMKdgLhRMA=YFstHzzZ0=A@mail.gmail.com>
	<CAHTgTXV_kJ=bUOEQjbxM8+tZ+Df--xrZxH5bwkGFqffLd5h9LA@mail.gmail.com>
	<2026468.U7VDB8Dm9m@vostro.rjw.lan>
Date: Tue, 29 Jul 2014 14:52:32 -0700
Message-ID: <CAHTgTXXejANtoEeeUB59DTy1kU3ROYoOsNi-fLu==PAr6Kh+-Q@mail.gmail.com>
Subject: Re: WARNING: CPU: 0 PID: 2623 at drivers/pnp/pnpacpi/core.c:96 pnpacpi_set_resource
From: Vinson Lee <vlee@twopensource.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: William Dauchy <wdauchy@gmail.com>, Zdenek Kabelac <zkabelac@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 2:10 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Tuesday, July 29, 2014 11:13:55 AM Vinson Lee wrote:
>> On Tue, Jul 29, 2014 at 2:53 AM, William Dauchy <wdauchy@gmail.com> wrote:
>> > Hi Vinson,
>> >
>> > On Mon, Jul 28, 2014 at 9:11 PM, Vinson Lee <vlee@twopensource.com> wrote:
>> >> The warning first happens with 3.14-rc1. The warning does not occur with 3.13.0.
>> >
>> > Hitting the same issue here with a similar trace on 3.14.x. Did you
>> > start bisecting?
>> >
>> > Regards,
>> > --
>> > William
>>
>>
>> I bisected the warning that I'm seeing to this commit.
>>
>> commit 202317a573b20d77a9abb7c16a3fd5b40cef3d9d
>> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> Date:   Fri Nov 22 21:54:37 2013 +0100
>>
>>     ACPI / scan: Add acpi_device objects for all device nodes in the namespace
>
> Interesting.
>
> Does the appended patch make any difference?
>
> Rafael
>
> ---
>  drivers/pnp/pnpacpi/core.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> Index: linux-pm/drivers/pnp/pnpacpi/core.c
> ===================================================================
> --- linux-pm.orig/drivers/pnp/pnpacpi/core.c
> +++ linux-pm/drivers/pnp/pnpacpi/core.c
> @@ -319,8 +319,7 @@ static int __init acpi_pnp_match(struct
>         struct pnp_dev *pnp = _pnp;
>
>         /* true means it matched */
> -       return !acpi->physical_node_count
> -           && compare_pnp_id(pnp->id, acpi_device_hid(acpi));
> +       return pnp->data == acpi;
>  }
>
>  static struct acpi_device * __init acpi_pnp_find_companion(struct device *dev)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Yes, with the patch on top of 3.16-rc7 I do not see the warning.

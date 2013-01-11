Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab3AKXBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 18:01:25 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:60865 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab3AKXBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 18:01:24 -0500
MIME-Version: 1.0
In-Reply-To: <4001131.iQGP87KxgR@vostro.rjw.lan>
References: <1558789.gX8cmBgyDV@vostro.rjw.lan>
	<CAE9FiQW4t17=gYC1dnyCVJUQ3rvV491uiA5U1ZjLWjraM=g9rQ@mail.gmail.com>
	<9771783.0zXIGEmDYn@vostro.rjw.lan>
	<4001131.iQGP87KxgR@vostro.rjw.lan>
Date: Fri, 11 Jan 2013 15:01:22 -0800
X-Google-Sender-Auth: gQeaRtudnmlXrLP3xROy1rsJnOc
Message-ID: <CAE9FiQW-3TJx0WGLGz7g4m+Tsryn73u-n_Ka6jbHGM0oDUmxhw@mail.gmail.com>
Subject: Re: [Alternative][PATCH] ACPI / PCI: Set root bridge ACPI handle in
 advance, v2
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiang Liu <liuj97@gmail.com>,
        Myron Stowe <myron.stowe@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 1:53 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> May I have your sign-off for the patch below at least?

Yes. please.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

>
>
> Rafael
>
>
>> > Index: linux-2.6/drivers/acpi/glue.c
>> > ===================================================================
>> > --- linux-2.6.orig/drivers/acpi/glue.c
>> > +++ linux-2.6/drivers/acpi/glue.c
>> > @@ -311,7 +311,7 @@ static int acpi_platform_notify(struct d
>> >         if (!ret) {
>> >                 struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
>> >
>> > -               acpi_get_name(dev->acpi_handle, ACPI_FULL_PATHNAME, &buffer);
>> > +               acpi_get_name(ACPI_HANDLE(dev), ACPI_FULL_PATHNAME, &buffer);
>> >                 DBG("Device %s -> %s\n", dev_name(dev), (char *)buffer.pointer);
>> >                 kfree(buffer.pointer);
>> >         } else
>> >

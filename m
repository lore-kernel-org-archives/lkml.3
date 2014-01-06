Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbaAFT2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 14:28:46 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:55765 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492AbaAFT2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 14:28:44 -0500
MIME-Version: 1.0
In-Reply-To: <2459491.HIKjAnF27k@vostro.rjw.lan>
References: <37552283.kG1L4S8Daa@vostro.rjw.lan>
	<6023795.zgEUjY5fWb@vostro.rjw.lan>
	<CAE9FiQXQuX5EOE1jbXfK+G1mf9q=4-fpw1jNs38sza9tcPtqMg@mail.gmail.com>
	<2459491.HIKjAnF27k@vostro.rjw.lan>
Date: Mon, 6 Jan 2014 11:28:43 -0800
X-Google-Sender-Auth: j8Gs0xQ30n6RadCe-dQ8cNlKsO8
Message-ID: <CAE9FiQV1tui+nHMFF419dpTOKt_x4US6R=3uPhDvUDJ0zoMrEg@mail.gmail.com>
Subject: Re: [PATCH][tentative] PCI / ACPI: Rework PCI host bridge removal to
 avoid sysfs warnings
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 2, 2014 at 4:45 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Thursday, January 02, 2014 02:47:04 PM Yinghai Lu wrote:
>>
>> No. It should be before removing all root bus devices.
>> as they need to access the pci devices during stop ioapic and dmar.
>>
>> Also ioapic itself could one one pci device.
>
> Well, if we stop drivers first, then stop ioapic/dmar and *then* remove
> devices, it is possible to rebind a driver to a device after ioapic/dmar has
> been stopped, which I guess will not lead to anything nice?

Not sure how that could happen.

If it would really happen, we could set dev->match_driver to 0 in pci_stop_dev.

Yinghai

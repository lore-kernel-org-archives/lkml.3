Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab3LNWQC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 17:16:02 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:47970 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab3LNWQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 17:16:00 -0500
MIME-Version: 1.0
In-Reply-To: <20131214220145.GA27585@kroah.com>
References: <CAMxnaaWgUPRb3L2aKpUu62F73GR2iXOfd6LUnTkU0O=Gq-E_sQ@mail.gmail.com>
 <20131214220145.GA27585@kroah.com>
From: Andreas Noever <andreas.noever@gmail.com>
Date: Sat, 14 Dec 2013 23:15:39 +0100
Message-ID: <CAMxnaaXzvxTJc+fP_E9fQhMTsVcj2PCJCsp=PNae3Pv47JONdQ@mail.gmail.com>
Subject: Re: How to reserve pci bus numbers for hotplug?
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 11:01 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, Dec 12, 2013 at 12:37:50AM +0100, Andreas Noever wrote:
>>
>> If I could get Linux to assign enough resources (bus numbers for now)
>> then I could drop the acpi_osi parameter and make thunderbolt work
>> after suspend... So, is there an easy way to fix this? (Quirks,
>> reconfiguring bus number assignments from a platform driver, ...?)
>
> I think you are going to have to do a lot more here, what is needed is a
> whole connection manager for Thunderbolt, emulating what the BIOS does,
> in order to get all of this working properly.
>
> But don't let that stop you from trying, however the work involved is
> really not trivial at all.
>
> good luck,
>
> greg k-h

Actually the thunderbolt part is already working (for non chaining
devices, see https://lkml.org/lkml/2013/11/28/492 if you are
interested). I can completely bootstrap the tb side of things. The
only problem is that if power has been cut by the firmware (during
boot without osi_acpi=Darwin or after a suspend/resume cycle) then
Linux does not allocate enough PCI resources...

Cheers,
Andreas

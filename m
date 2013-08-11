Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab3HKWI7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 18:08:59 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:65507 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab3HKWI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 18:08:57 -0400
MIME-Version: 1.0
In-Reply-To: <20130811190826.GH6427@sirena.org.uk>
References: <20130811190826.GH6427@sirena.org.uk>
From: Grant Likely <grant.likely@linaro.org>
Date: Sun, 11 Aug 2013 23:08:37 +0100
X-Google-Sender-Auth: 0F-i4tavmaWECWlbzw7E4IZEa5I
Message-ID: <CACxGe6sM8_d_omiQU=4qA207dnYMGDELN0KDbhYDsWDg7RKAKQ@mail.gmail.com>
Subject: Re: Non-enumerable devices on USB and other enumerable buses
To: Mark Brown <broonie@kernel.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, devicetree@kernel.org,
        Linux USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 11, 2013 at 8:08 PM, Mark Brown <broonie@kernel.org> wrote:
> I know there's been some discussion of this topic but do we have any
> general consensus on how to handle such things both from a Linux driver
> model point of view and from a DT/ACPI point of view?

There is precedence for describing enumerated device in the device
tree. Real OpenFirmware platforms can and will enumerate the PCI and
USB busses and pass a full tree to the OS. I don't think we want to
full enumerating like that with either ACPI or FDT, but we could allow
for sparse population of devices when something is fixed like a
soldered down USB hub or USB Ethernet MAC.

To make it work would probably require a hook in the USB enumeration
path to look for matching nodes in DT/ACPI and attach it to the struct
device.

g.

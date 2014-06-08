Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbaFHSG5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 14:06:57 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:62174 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbaFHSG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 14:06:56 -0400
MIME-Version: 1.0
In-Reply-To: <5394A309.7030705@zytor.com>
References: <CA+waHKUfu0Mxy_J9qWwayxZVDBA_RDYrpsL100Mr1sUBQRchVw@mail.gmail.com>
 <5394A309.7030705@zytor.com>
From: Nikolay Amiantov <nikoamia@gmail.com>
Date: Sun, 8 Jun 2014 22:06:35 +0400
Message-ID: <CA+waHKVTONQVqj7=n5tHfmxa3FOWyYFi4rZvMD7j_eio4-NWLQ@mail.gmail.com>
Subject: Re: What can change in ways Linux handles memory when all memory >4G
 is disabled? (x86)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 8, 2014 at 9:53 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> This would point either to an iommu problem, or a problem in the driver
> where addresses somehow get truncated to 32 bits.  Since this is a
> graphics driver it is extremely complex, and subtle problems could be
> buried somewhere inside it.  The fact that you can trigger it without a
> driver would point to that kind of problem inside the firmware.
>
>         -hpa

My assumption is that in new BIOSes (old ones are working, as I've
said, for T440p) there is some new way nvidia should be enabled, and
it's not related to ACPI (the calls are same in Windows). There are no
related changelog entries for T440p [1] (between 1.14 and 1.16). Also,
about address truncation: I thought so too, but if I understand
correctly, then some memory in >=4G region should be reserved for some
driver's use, and this is not the case (see [2] for /proc/iomem).

Nikolay Amiantov.

[1]: http://download.lenovo.com/ibmdl/pub/pc/pccbbs/mobiles/gluj13us.txt
[2]: http://bpaste.net/show/355712/

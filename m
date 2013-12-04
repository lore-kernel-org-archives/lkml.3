Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab3LDSXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 13:23:17 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:61082 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932511Ab3LDSXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 13:23:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] Introduce FW_INFO* functions and messages
Date: Wed, 4 Dec 2013 19:22:57 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <1385997579-22240-1-git-send-email-prarit@redhat.com> <1385997579-22240-2-git-send-email-prarit@redhat.com> <20131203132120.6a7ab2cd7cc99720712cbe6a@linux-foundation.org>
In-Reply-To: <20131203132120.6a7ab2cd7cc99720712cbe6a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201312041922.59181.arnd@arndb.de>
X-Provags-ID: V02:K0:qNTbuQ7uQW384AeM8uHV1A7HiITrs3qMl/Q9tWN6Chf
 lsBgKbeo1TfbGQiGQzIT4RwVJfTmzfMQMiEqxuteOcHb1u6N5M
 TYeyKMIEAGMAPRb8wG4VJ9TXo9dsAaNyxJNKIOSMW1/Uw1IpN2
 hJqId6MVKw8pk6xBBFhXWYA/CQBIgoHJkH2WosKfGVS47tcHZ9
 bi/z+JxbbuyxfgyBWzKMXnugMIX4n0OB8RwTvbS/R3O8QOSVyi
 Nrf8wh0iawbe68FgPPE/cFCu0ERyw+zmgPGKGbL0SG3CiG7QXT
 5YovZD3inWG5MEZqFuFHgUBVv1Esty6GpFlNs9uAH9B7mKJTXh
 WiIaOEOl8LbLEFeEvkog=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 December 2013, Andrew Morton wrote:
> I do wonder if it all should be generalised a bit - it creates a bunch
> of infrastructure which is specific to system firmware issues, but
> what's so special about firmware?  Why can't I use this infrastructure
> to log netdev errors or acpi errors or PM errors or...?  But I didn't
> think about it much ;)

I had similar thoughts when I read this, but I can also remember a bunch
of very overdesigned attempts to reorganize and structure the kernel
logging code. I lot of time was wasted in the past for things that
ended up being too invasive or inconsistent.

The other part I noticed about this particular patchset is that it's
not really "firmware" as such, but specifically PC wiht ACPI that
gets covered here. So rather than generalizing the code, another
option would be to narrow down the scope and make it
acpi_{warn,info,dbg} instead.

	Arnd

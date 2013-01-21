Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab3AUUmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 15:42:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54788 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237Ab3AUUmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 15:42:52 -0500
Message-ID: <50FDA81B.9090602@zytor.com>
Date: Mon, 21 Jan 2013 14:42:03 -0600
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        Tim Gardner <rtg.canonical@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Tony Luck <tony.luck@intel.com>,
        Steve Langasek <steve.langasek@canonical.com>,
        Colin Ian King <colin.king@canonical.com>,
        Matt Fleming <matt.fleming@intel.com>, David Airlie <airlied@linux.ie>,
        Corentin Chary <corentincj@iksaif.net>,
        Dave Jiang <dave.jiang@intel.com>, Peter Jones <pjones@redhat.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] efi: Make 'efi_enabled' a function to query EFI facilities
References: <1358800838-10459-1-git-send-email-matt@console-pimps.org> <1358800838-10459-2-git-send-email-matt@console-pimps.org>
In-Reply-To: <1358800838-10459-2-git-send-email-matt@console-pimps.org>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2013 02:40 PM, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
> 
> Originally 'efi_enabled' indicated whether a kernel was booted from
> EFI firmware. Over time its semantics have changed, and it now
> indicates whether or not we are booted on an EFI machine with
> bit-native firmware, e.g. 64-bit kernel with 64-bit firmware.
> 
> But users actually want to query 'efi_enabled' for different reasons -
> what they really want access to is the list of available EFI
> facilities.
> 
> For instance, the x86 reboot code needs to know whether it can invoke
> the ResetSystem() function provided by the EFI runtime services, while
> the ACPI OSL code wants to know whether the EFI config tables were
> mapped successfully. There are also checks in some of the platform
> driver code to simply see if they're running on an EFI machine (which
> would make it a bad idea to do BIOS-y things).
> 

Could you please explain as part of the checkin comment why this is
needed for urgent/stable?  I.e. what breaks *now*, as opposed to this
being a cleanup for the next merge window.

	-hpa



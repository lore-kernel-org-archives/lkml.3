Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab3LTVoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 16:44:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48306 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130Ab3LTVoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 16:44:22 -0500
Message-ID: <52B4BA0A.1030902@zytor.com>
Date: Fri, 20 Dec 2013 13:43:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: joeyli <jlee@suse.com>, Alessandro Zummo <a.zummo@towertech.it>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com,
        samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>,
        werner@suse.com, trenn@suse.de, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org, Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH 00/14] Support timezone of ACPI TAD and EFI TIME
References: <1387439053-8711-1-git-send-email-jlee@suse.com> <1387517916.3539.4446.camel@linux-s257.site> <52B4B242.5010002@zytor.com> <2787644.ytU7M33B4r@vostro.rjw.lan>
In-Reply-To: <2787644.ytU7M33B4r@vostro.rjw.lan>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2013 01:45 PM, Rafael J. Wysocki wrote:
> 
> My understanding, however, is that to use the TAD, we don't actually need to
> create a struct acpi_device for it.  We just need a handle to the ACPICA
> object which can be found using acpi_get_devices() as soon as the namespace
> has been extracted from the DSDT and friends.  That in turn happens in
> acpi_early_init(), which is called from start_kernel() right before
> efi_late_init().
> 
> Is that early enough?
> 

Possibly... will have to investigate.  I would also ask if the same
applies to the PNP0B0x devices -- all we really need there is the
presence/absence indication and the I/O port base.

	-hpa



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab3LUMV5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 07:21:57 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:51506 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753790Ab3LUMVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 07:21:55 -0500
Date: Sat, 21 Dec 2013 12:21:48 +0000
From: Matt Fleming <matt@console-pimps.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, joeyli <jlee@suse.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com,
        samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>,
        werner@suse.com, trenn@suse.de, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org, Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH 00/14] Support timezone of ACPI TAD and EFI TIME
Message-ID: <20131221122148.GB29501@console-pimps.org>
References: <1387439053-8711-1-git-send-email-jlee@suse.com>
 <52B4BA0A.1030902@zytor.com>
 <20131220215056.GA29501@console-pimps.org>
 <3476450.BMEcId2Lgj@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3476450.BMEcId2Lgj@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Dec, at 11:18:56PM, Rafael J. Wysocki wrote:
> 
> I'm not sure 100%, but I *think* we need to do that with interrupts enabled.
> At least after mm_init(), because it relies on things initialized there if I
> remember correctly.
> 
> From what I can tell at the moment, it might be possible to move it before
> efi_enter_virtual_mode() if that would help.

Actually yeah, that would be super useful, and I think we'd be able to
get rid of the whole efi_late_init() stuff because we'd no longer need
to hang on to the EFI_BOOT_SERVICES* regions after
SetVirtualAddressMap().

-- 
Matt Fleming, Intel Open Source Technology Center

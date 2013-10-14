Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128Ab3JNQYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 12:24:54 -0400
Received: from tango.0pointer.de ([85.214.72.216]:48559 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab3JNQYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 12:24:52 -0400
Date: Mon, 14 Oct 2013 18:24:46 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "aaron.lu@intel.com" <aaron.lu@intel.com>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>
Subject: Re: [PATCH] acpi/video: Add Lenovo IdeaPad Yoga 13 to acpi video
  detect blacklist
Message-ID: <20131014162445.GA11682@tango.0pointer.de>
References: <20131014005505.GA30503@tango.0pointer.de>
 <525B44C0.3010204@intel.com>
 <20131014022325.GA2248@tango.0pointer.de>
 <525B58BE.5050009@intel.com>
 <20131014034927.GA3638@tango.0pointer.de>
 <525B703E.7080102@intel.com>
 <20131014153621.GA7758@tango.0pointer.de>
 <1381765708.24317.1.camel@x230.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381765708.24317.1.camel@x230.lan>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14.10.13 15:48, Matthew Garrett (matthew.garrett@nebula.com) wrote:

> On Mon, 2013-10-14 at 17:36 +0200, Lennart Poettering wrote:
> 
> > Sorry, still not getting this. How should this ever work if the intel
> > video driver is compiled as kmod? That means that it isn't clear at all
> > when the kmod is going to be loaded or if it is loaded at all, you
> > cannot delay the registration of the acpi backlight that long, since the
> > time you'd have to wait is basically unbounded...
> 
> See the intel_opregion_present() code in drivers/acpi/video.c. The ACPI
> driver won't bind to Intel hardware until i915 indicates that it should
> do so.

Hmm, OK, so this means that the acpi backlight will check whether i915
hw is around, and not whether the i915 driver is actually loaded? That
would work for me I guess. Thanks.

That means on win8 machines with win8 graphics there'll always be a
single backlight device in userspace only?

Lennart

-- 
Lennart Poettering - Red Hat, Inc.

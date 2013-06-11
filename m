Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab3FKNIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 09:08:10 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:65195 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab3FKNII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 09:08:08 -0400
Date: Tue, 11 Jun 2013 08:08:04 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-acpi@vger.kernel.org, joeyli.kernel@gmail.com,
        daniel.vetter@ffwll.ch, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rjw@sisk.pl
Subject: Re: [PATCH 0/3] Fix backlight issues on some Windows 8 systems
Message-ID: <20130611130804.GF8943@thinkpad-t410>
Mail-Followup-To: Matthew Garrett <matthew.garrett@nebula.com>,
	linux-acpi@vger.kernel.org, joeyli.kernel@gmail.com,
	daniel.vetter@ffwll.ch, intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	lenb@kernel.org, rjw@sisk.pl
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 09, 2013 at 07:01:36PM -0400, Matthew Garrett wrote:
> Windows 8 introduced new policy for backlight control by pushing it out to
> graphics drivers. This appears to have coincided with a range of vendors
> adding Windows 8 checks to their backlight control code which trigger either
> awkward behaviour (Lenovo) or complete brokenness (some Dells). The simplest
> thing to do would be to just disable ACPI backlight control entirely if the
> firmware indicates Windows 8 support, but it's entirely possible that
> individual graphics drivers might still make use of the ACPI functionality in
> preference to native control.
> 
> The first two patches in this series are picked from other patchesets aimed at
> solving similar problems. The last simply unregisters ACPI backlight control
> on Windows 8 systems when using an Intel GPU. Similar code could be added to
> other drivers, but I'm reluctant to do so without further investigation as
> to the behaviour of the vendor drivers under Windows.

I've received some feedback from user testing of these patches (don't
have an affected machine myself) and the feedback is mostly good. One
user reported it didn't work, but I that machine may have discrete
graphics (waiting to hear back from the user).

The main drawback I see with any approach like this one is that the
backlight remains broken for users of proprietary graphics drivers.

Seth

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162139Ab3DERDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 13:03:19 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:61055 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162074Ab3DERDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 13:03:17 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: Re: Version number policy!
Date: Fri, 5 Apr 2013 19:03:09 +0200
User-Agent: KMail/1.13.7 (Linux/3.9.0-rc5-wl+; KDE/4.8.4; x86_64; ; )
Cc: Adrian Chadd <adrian@freebsd.org>,
        "ath9k_htc_fw" <ath9k_htc_fw@lists.infradead.org>,
        "linux-wireless" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth" <linux-bluetooth@vger.kernel.org>
References: <CAJ-Vmo=LVSzdEo6DhfOVT_0JHCTMmdPU1zGfMuBmhmr8QuDmJQ@mail.gmail.com> <CAB=NE6V3sApMSGWkKbaFaJC4+VpLxgYF-xyNRKxiA-YDCwhGkQ@mail.gmail.com>
In-Reply-To: <CAB=NE6V3sApMSGWkKbaFaJC4+VpLxgYF-xyNRKxiA-YDCwhGkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201304051903.11215.chunkeey@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 April 2013 10:19:00 Luis R. Rodriguez wrote:
> On Thu, Apr 4, 2013 at 11:27 AM, Adrian Chadd <adrian@freebsd.org> wrote:
> > Here's my first take on the version number policy:
> >
> > https://github.com/qca/open-ath9k-htc-firmware/wiki/VersionPolicy
> > The summary:
> >
> > * major version number changes are for firmware API / behaviour
> > changes that aren't backwards compatible;
> > * minor version number changes are for firmware API / behaviour
> > changes that are incremental and default to the old behaviour (eg, new
> > optional commands);
> > * the driver should check the minor version number before using any
> > optional features with that version.
> >
> > What's TODO:
> >
> > * Add a new WMI command to get the build number, git string, etc.
> > * add it as our first optional minor version command :-)
>
> This is better than anything we had drafted before for 802.11 open
> firmware design rules. Cc'ing a few lists for wider review given that
> what we had written before for rules was for 802.11 and Bluetooth [0]
> and it was very Linux specific. We are striving for open firmware here
> for the community, for BSD / Linux. Christian would have dealt with
> more of the support on open firmware design so far due to carl9170.fw
> [1] so curious if he has any input.
Based on my experience with carl9170, I can tell you that
new stuff (new wmi commands, or advanced offload caps, features
and bugfixes) should be advised via feature flags in bitmaps
and not firmware versions. [Just make it long enough...]

Otherwise you'll have to write endless checks like:
if ((fw_minor == 1 && fw_patch > 30) ||
    (fw_minor == 2 && fw_patch > 7) ||
    (fw_minor == 3 && fw_patch > 3) ||
    (fw_minor > 4))
		feature_supported = true;

everytime you backport features and bugfixes to older firmwares.

Also, firmware dates are more important than you think.
They allow some way of syncing the firmware->driver and
your inbox.

Regards,
	Christian

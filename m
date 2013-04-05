Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162192Ab3DERX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 13:23:56 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:50664 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab3DERXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 13:23:54 -0400
MIME-Version: 1.0
In-Reply-To: <201304051903.11215.chunkeey@googlemail.com>
References: <CAJ-Vmo=LVSzdEo6DhfOVT_0JHCTMmdPU1zGfMuBmhmr8QuDmJQ@mail.gmail.com>
	<CAB=NE6V3sApMSGWkKbaFaJC4+VpLxgYF-xyNRKxiA-YDCwhGkQ@mail.gmail.com>
	<201304051903.11215.chunkeey@googlemail.com>
Date: Fri, 5 Apr 2013 19:23:54 +0200
Message-ID: <CAFSJ42bqquh+xekt8+V3wbG3MOUVFELTxR3mNPfS0Jn9J7OURQ@mail.gmail.com>
Subject: Re: Version number policy!
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Adrian Chadd <adrian@freebsd.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good point regarding timestamp.

When it comes to feature bitmap do you have an example of such a
bitmap from carl9170? Why not to rely always on major version?

2013/4/5 Christian Lamparter <chunkeey@googlemail.com>:
> On Friday 05 April 2013 10:19:00 Luis R. Rodriguez wrote:
>> On Thu, Apr 4, 2013 at 11:27 AM, Adrian Chadd <adrian@freebsd.org> wrote:
>> > Here's my first take on the version number policy:
>> >
>> > https://github.com/qca/open-ath9k-htc-firmware/wiki/VersionPolicy
>> > The summary:
>> >
>> > * major version number changes are for firmware API / behaviour
>> > changes that aren't backwards compatible;
>> > * minor version number changes are for firmware API / behaviour
>> > changes that are incremental and default to the old behaviour (eg, new
>> > optional commands);
>> > * the driver should check the minor version number before using any
>> > optional features with that version.
>> >
>> > What's TODO:
>> >
>> > * Add a new WMI command to get the build number, git string, etc.
>> > * add it as our first optional minor version command :-)
>>
>> This is better than anything we had drafted before for 802.11 open
>> firmware design rules. Cc'ing a few lists for wider review given that
>> what we had written before for rules was for 802.11 and Bluetooth [0]
>> and it was very Linux specific. We are striving for open firmware here
>> for the community, for BSD / Linux. Christian would have dealt with
>> more of the support on open firmware design so far due to carl9170.fw
>> [1] so curious if he has any input.
> Based on my experience with carl9170, I can tell you that
> new stuff (new wmi commands, or advanced offload caps, features
> and bugfixes) should be advised via feature flags in bitmaps
> and not firmware versions. [Just make it long enough...]
>
> Otherwise you'll have to write endless checks like:
> if ((fw_minor == 1 && fw_patch > 30) ||
>     (fw_minor == 2 && fw_patch > 7) ||
>     (fw_minor == 3 && fw_patch > 3) ||
>     (fw_minor > 4))
>                 feature_supported = true;
>
> everytime you backport features and bugfixes to older firmwares.
>
> Also, firmware dates are more important than you think.
> They allow some way of syncing the firmware->driver and
> your inbox.
>
> Regards,
>         Christian
>
> _______________________________________________
> Ath9k_htc_fw mailing list
> Ath9k_htc_fw@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath9k_htc_fw



-- 
Best regards,
Eugene

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310AbaETWFC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 18:05:02 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:38514 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751178AbaETWE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 18:04:59 -0400
Message-ID: <537BD184.9090608@logitech.com>
Date: Tue, 20 May 2014 15:04:52 -0700
From: Roland Bosa <rbosa@logitech.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: simon@mungewell.org
CC: =?ISO-8859-1?Q?Michal_Mal=FD?= <madcatxster@devoid-pointer.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        jkosina@suse.cz, elias.vds@gmail.com, anssi.hannula@iki.fi
Subject: Re: [PATCH v4 01/24] input: Add ff-memless-next module
References: <1398524543-15012-1-git-send-email-madcatxster@devoid-pointer.net>    <1818063.tFLKhAd1oy@sigyn>    <20140514180558.GB30089@core.coreip.homeip.net>    <2965006.XKYHWj9YzJ@sigyn> <537B9FAE.9070602@logitech.com> <8c45868c3cd4333d1098bdbc0fa83a2e.squirrel@mungewell.org>
In-Reply-To: <8c45868c3cd4333d1098bdbc0fa83a2e.squirrel@mungewell.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2014 12:39 PM, simon@mungewell.org wrote:
> hopefully bring Linux into scope for force-feedback of AAA game quality.

^ That's my objective too.

> Mostly this has come from a small group of people reverse engineering the
> Logitech wheels, which leads to the 'tailor-made' situation. But we'd like
> the systems/interfaces to be device agnostic.

I'm sure we can consolidate the support into fewer files.

> As you how you can help...? As Michal said having a contact at Logitech to
> whom we can ask technical questions (off list) would probably be the
> greatest help. This would clear up any assumptions we have made, and help
> with decisions going forward.

Please don't hesitate to contact me. ;-)

> It may also be the case that Logitech is working with studios/game
> designers to improve controller performance. If any information can be
> feed 'forward' to improve the Linux driver, that would be useful too.

IMO, there are two types of games. The "arcade" ones, which have a set
of 'canned' force effects, which play whenever an event happens in game.
And the "simulation" ones, which base the game on a physics engine. The
latter can redirect some variables of their engine to the input layer
and typically drive a constant force and maybe a spring/damper too.

For the first type, you might want to keep a centering spring active all
the time. Maybe you want to tweak the gain in the game settings. Maybe
there's a gain for the centering and one for the special effects. The
canned effects are mostly periodics with varying waveform, duration,
amplitude and envelope. That's about it.

For the second type, you don't want a centering spring. You typically
will drive a constant force effect with the engine, with some sprinkled
damping and maybe a slight spring here and there.

I would personally put more weight and effort to get the second type
properly implemented. The players of those games demand more realism and
they need the subtle force changes to drive better than the competition.
That means having a FF driver that can deal with many force updates per
second without choking and a consistent, reproducible force output at
the device, maybe even similar across varying devices. This translates
into a decoupled design for accepting force updates and sending USB
updates, as well as a device-specific layer to "calibrate" and "unify"
the force responses across different models.

Does this make sense?

thanks
roland


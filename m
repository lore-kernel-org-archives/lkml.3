Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750869AbaETV06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 17:26:58 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:33196 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaETV0z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 17:26:55 -0400
MIME-Version: 1.0
In-Reply-To: <6970969.ej8OFzkVkO@sigyn>
References: <1398524543-15012-1-git-send-email-madcatxster@devoid-pointer.net>
	<2965006.XKYHWj9YzJ@sigyn>
	<865ad8dbc7ae0d13c045bd2a85cff2e2.squirrel@mungewell.org>
	<6970969.ej8OFzkVkO@sigyn>
Date: Tue, 20 May 2014 23:26:54 +0200
Message-ID: <CADbOyBTOQLewGSzXY6O1Rghw28bMtDYf5UdH9QU17DPur8hryw@mail.gmail.com>
Subject: Re: [PATCH v4 01/24] input: Add ff-memless-next module
From: Elias Vanderstuyft <elias.vds@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Simon Wood <simon@mungewell.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Anssi Hannula <anssi.hannula@iki.fi>,
        =?UTF-8?B?TWljaGFsIE1hbMO9?= <madcatxster@devoid-pointer.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 10:58 PM, Michal Malý
<madcatxster@devoid-pointer.net> wrote:
> On Tuesday 20 of May 2014 16:16:12 simon@mungewell.org wrote:
>> Regarding the question of emulated vs. real effects, can we extend the API
>> so that applications can know which effects are really supported, and
>> enable/disable emulation somehow?
>
> I suppose that a few extra flags (FF_PERIODIC_EMULATED etc.) defined in
> "uapi/linux/input.h" should suffice.

@Dmitry:
Now that we're talking about API changes, I would like to propose some
additional things in the Linux FF API:

- Possibility to *get* FF state variables, such as the value of the
current GAIN, and the current AUTOCENTER:
At the moment, only *setting* is possible.
This poses a problem when implementing proper AUTOCENTER state
recovery (upon closing a Windows program) in Wine, because the initial
AUTOCENTER state was unknown.
The same applies for GAIN.

- Introduce multiple types of GAIN, apart from the current global
GAIN, e.g. GAIN_CONSTANT and GAIN_DAMPER:
This is mainly on request of some users, especially Logitech users: on
Windows Logitech additionally supports to set the global Damper and
Spring gain.
Maybe it would be nicer to create a global gain for every supported
Linux FF effect?

Thanks,
Elias

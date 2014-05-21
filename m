Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbaEUOWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:22:55 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:47722 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbaEUOWy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:22:54 -0400
MIME-Version: 1.0
In-Reply-To: <CADbOyBQfHAnZYJj=z-SF77yg+yNpAzETX_W2UGh56NsZo3o8ew@mail.gmail.com>
References: <1398524543-15012-1-git-send-email-madcatxster@devoid-pointer.net>
	<1c6140633925b0838b7627e071e80761.squirrel@mungewell.org>
	<537BFEBF.8010601@logitech.com>
	<2643156.2tkLFqgYFg@sigyn>
	<CADbOyBQfHAnZYJj=z-SF77yg+yNpAzETX_W2UGh56NsZo3o8ew@mail.gmail.com>
Date: Wed, 21 May 2014 16:22:52 +0200
Message-ID: <CADbOyBRmAhpWVAEL=kJfqfhYWhSRQH+C3d8-mgaA7rQN=oYY1A@mail.gmail.com>
Subject: Re: [PATCH v4 01/24] input: Add ff-memless-next module
From: Elias Vanderstuyft <elias.vds@gmail.com>
To: =?UTF-8?B?TWljaGFsIE1hbMO9?= <madcatxster@devoid-pointer.net>,
        Roland Bosa <rbosa@logitech.com>
Cc: Simon Wood <simon@mungewell.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, Anssi Hannula <anssi.hannula@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 3:35 PM, Elias Vanderstuyft <elias.vds@gmail.com> wrote:
> On Wed, May 21, 2014 at 4:13 AM, Michal Malý
> <madcatxster@devoid-pointer.net> wrote:
>> Proper decoupling of the userspace and driver is the only important thing that
>> is missing from the current code.
>
> Also dynamic updating of periodic effects is not yet supported in
> "ff-memless-next".
> This can also be important in simulation games (=second type), e.g.
> the "rFactor" game.

Oh, and I forgot some other things that need to be mentioned:
- Trigger-button is not yet implemented, as far as I know
- Custom force effects, in Linux it is called FF_CUSTOM. (however I
think we can neglect this effect for now)
- Infinite iterations in the Linux FF API is not supported.

@Roland:
Now I understand why Logitech Windows drivers have bugs in the
periodic implementation of the DInput specs:
Logitech seems to have based their drivers on the Immersion Studio
visualisation of the to-be-generated periodic effects, and these
visualisations are not conform with the DInput specs of MSDN.
Take a quick look at the MSDN specs for e.g. SawtoothUp:
http://msdn.microsoft.com/en-us/library/windows/desktop/ee418719%28v=vs.85%29.aspx
Now open the Immersion Studio (demo) and create a standard SawtoothUp
effect, and look at the visualisation... It's wrong, right?
Same applies for SawtoothDown and Triangle.

Elias

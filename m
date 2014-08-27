Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964849AbaH0Swz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:52:55 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:54201 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935656AbaH0Swy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:52:54 -0400
Message-ID: <53FE2901.50508@gmail.com>
Date: Wed, 27 Aug 2014 20:52:49 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] regulator: max77802: set opmode to normal if off
 is read from hw
References: <1409053061-22568-1-git-send-email-javier.martinez@collabora.co.uk> <53FE2446.3040402@gmail.com> <20140827183733.GN17528@sirena.org.uk> <53FE25EB.7060702@gmail.com> <20140827184705.GO17528@sirena.org.uk>
In-Reply-To: <20140827184705.GO17528@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.08.2014 20:47, Mark Brown wrote:
> On Wed, Aug 27, 2014 at 08:39:39PM +0200, Tomasz Figa wrote:
>> On 27.08.2014 20:37, Mark Brown wrote:
> 
>>> That's essentially the situation the patch is trying to fix - if we boot
>>> and the regulator is off there's no way to figure out what the operating
>>> mode would have been so we have to pick something.  If you've got an
>>> idea for something better to do...
> 
>> Probably the only way to correctly handle this is to specify the right
>> operating mode in DT (after defining a binding for it).
> 
> I'm not convinced that's worth it - chances are that if anything changed
> the mode it was a previously running Linux which will most likely be
> doing the same things when it starts running anyway.
> 

The previously running Linux would have changed the opmode accidentally,
due to hardware design of PMIC chip, which doesn't allow powering off a
regulator in other way than setting opmode to OFF.

If you provide the "active" opmode to that Linux, after a warm reboot it
will be able to power on such regulator to correct opmode, without
defaulting it incorrectly to NORMAL.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935725AbaH0Sjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:39:51 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33274 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935198AbaH0Sjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:39:49 -0400
Message-ID: <53FE25EB.7060702@gmail.com>
Date: Wed, 27 Aug 2014 20:39:39 +0200
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
References: <1409053061-22568-1-git-send-email-javier.martinez@collabora.co.uk> <53FE2446.3040402@gmail.com> <20140827183733.GN17528@sirena.org.uk>
In-Reply-To: <20140827183733.GN17528@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.08.2014 20:37, Mark Brown wrote:
> On Wed, Aug 27, 2014 at 08:32:38PM +0200, Tomasz Figa wrote:
>> On 26.08.2014 13:37, Javier Martinez Canillas wrote:
> 
>>> +		/*
>>> +		 * If the regulator is disabled and the system warm rebooted,
>>> +		 * the hardware reports OFF as the regulator operating mode.
>>> +		 * Default to operating mode NORMAL in that case.
>>> +		 */
>>> +		if (val == MAX77802_OPMODE_OFF)
>>> +			max77802->opmode[id] = MAX77802_OPMODE_NORMAL;
>>> +		else
>>> +			max77802->opmode[id] = val;
> 
>> I might be missing something, but I believe I see a flaw here. If after
>> a cold boot opmode is something else than OFF or NORMAL, the kernel
>> starts, turns the regulator off and does warm reboot, the setting is
>> lost and the regulator is switched to NORMAL mode.
> 
> That's essentially the situation the patch is trying to fix - if we boot
> and the regulator is off there's no way to figure out what the operating
> mode would have been so we have to pick something.  If you've got an
> idea for something better to do...
> 

Probably the only way to correctly handle this is to specify the right
operating mode in DT (after defining a binding for it).

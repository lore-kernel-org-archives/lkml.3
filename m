Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018Ab3HOQS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 12:18:56 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:13450 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756721Ab3HOQSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 12:18:55 -0400
Message-ID: <520CFF6C.7020302@itdev.co.uk>
Date: Thu, 15 Aug 2013 17:18:52 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: rydberg@euromail.se
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH 37/51] Input: atmel_mxt_ts - Implement vector/orientation
 support
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk> <1372337366-9286-38-git-send-email-nick.dyer@itdev.co.uk> <20130718172029.GF32381@polaris.bitmath.org>
In-Reply-To: <20130718172029.GF32381@polaris.bitmath.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rydberg@euromail.se wrote:
> On Thu, Jun 27, 2013 at 01:49:12PM +0100, Nick Dyer wrote:
>> The atmel touch messages contain orientation information as a byte in a packed
>> format which can be passed straight on to Android if the input device
>> configuration is correct, see
>> http://source.android.com/tech/input/touch-devices.html#touchorientationcalibration

Except they've changed the URL, should be:
https://source.android.com/devices/tech/input/touch-devices.html#touchorientationcalibration

The Atmel format is two 4-bit signed values packed into 1 byte, you use
inverse tan to work out the angle, and pythagoras theorem to work out the
magnitude of the vector (giving a confidence level)

>> This requires vector reports to be enabled in maXTouch config (zero DISVECT
>> bit in T9 CTRL field)
>>
>> Android converts the format in frameworks/base/services/input/Input.cpp,
>> search for ORIENTATION_CALIBRATION_VECTOR.
> 
> How does this compare to the input mt documentation?

http://lxr.free-electrons.com/source/Documentation/input/multi-touch-protocol.txt#L263

So yes, we don't meet the documented format. Options:
1. Leave out this patch entirely and support out of tree
2. Update multi-touch-protocol.txt to include the Atmel format
3. Convert in driver to match documented protocol. Presumably via a LUT of
the 256 possible values. Although this loses the confidence level that is
implied.
4. Getting the firmware changed is not a valid option I'm afraid (too many
devices already out there).

Which do you prefer (I suspect 3) ?

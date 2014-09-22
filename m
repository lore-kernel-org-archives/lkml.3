Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbaIVHgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 03:36:45 -0400
Received: from svenfoo.org ([82.94.215.22]:40048 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbaIVHgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 03:36:43 -0400
Message-ID: <541FD188.6030602@zonque.org>
Date: Mon, 22 Sep 2014 09:36:40 +0200
From: Daniel Mack <daniel@zonque.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Matt Ranostay <mranostay@gmail.com>
CC: Kumar Gala <galak@codeaurora.org>, linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/3] cap1106: Add support for various cap11xx devices
References: <1411268469-21283-1-git-send-email-mranostay@gmail.com>	<1411268469-21283-2-git-send-email-mranostay@gmail.com>	<541EA149.5000408@zonque.org> <CAKzfze--CZ3EVMpRgNy393ddDE64pPm0sibkVBFxWjEm8wL=dA@mail.gmail.com>
In-Reply-To: <CAKzfze--CZ3EVMpRgNy393ddDE64pPm0sibkVBFxWjEm8wL=dA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2014 12:46 AM, Matt Ranostay wrote:
> On Sun, Sep 21, 2014 at 2:58 AM, Daniel Mack <daniel@zonque.org> wrote:
>> On 09/21/2014 05:01 AM, Matt Ranostay wrote:

>>> @@ -313,12 +307,16 @@ static int cap1106_i2c_probe(struct i2c_client *i2c_client,
>>>
>>>  static const struct of_device_id cap1106_dt_ids[] = {
>>>       { .compatible = "microchip,cap1106", },
>>> +     { .compatible = "microchip,cap1126", },
>>> +     { .compatible = "microchip,cap1188", },
>>
>> Hmm, how can that work unless you set .data to the number of channels
>> here? Did you test that with a DT-enabled board?
>>
> Yes it was tested on a BBB.  The num_channels is set from cap1106_i2c_ids

Ah ok. I forgot there's this fallback to the i2c ids. What others driver
do is to use of_match_device() in the probe function, and then access
->data of the returned match.

But I'm fine with falling back to cap1106_i2c_ids unless anyone else has
objections.


Thanks,
Daniel



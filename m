Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbaISACX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 20:02:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:15246 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbaISACW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 20:02:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,550,1406617200"; 
   d="scan'208";a="601920440"
Message-ID: <541B71C9.3080802@linux.intel.com>
Date: Thu, 18 Sep 2014 16:59:05 -0700
From: eric ernst <eric.ernst@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@intel.com>,
        Samuel Ortiz <samuel.ortiz@intel.com>
CC: Loic Poulain <loic.poulain@intel.com>, linus.walleij@linaro.org,
        heikki.krogerus@linux.intel.com, mathias.nyman@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] pinctrl: baytrail: Clear DIRECT_IRQ bit
References: <1410961621-15231-1-git-send-email-loic.poulain@intel.com> <20140918074910.GC10854@lahna.fi.intel.com> <20140918094113.GC26004@zurbaran> <20140918095505.GI10854@lahna.fi.intel.com>
In-Reply-To: <20140918095505.GI10854@lahna.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 14-09-18 02:55 AM, Mika Westerberg wrote:
> On Thu, Sep 18, 2014 at 11:41:13AM +0200, Samuel Ortiz wrote:
>> Hi Mika,
>>
>> On Thu, Sep 18, 2014 at 10:49:43AM +0300, Mika Westerberg wrote:
>>> On Wed, Sep 17, 2014 at 03:47:01PM +0200, Loic Poulain wrote:
>>>> Direct Irq En bit can be initialized to a bad value.
>>>> This bit has to be cleared for io access mode.
>>> +Eric
>>>
>>> I would like to have a bit better explanation *why* this bit needs to be
>>> cleared.
>>>
>>> Also want to ask Eric (who added the WARN()), is there something
>>> preventing us to do this? I remember last time you said that we are not
>>> supposed to change this bit runtime.
>>>
>>> My preference is that we get rid of the WARN() and just unconditionally
>>> clear the bit.
>> I'd keep the warn though, as it most likely shows a buggy firmware
>> implementation.
> Fair enough :)
>
> Maybe it could be more informative.
Agreed - I think its safest to say "you're shooting yourself in the 
foot," rather than reinforcing what we think are the right pad settings.

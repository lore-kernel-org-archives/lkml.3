Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab3KYIrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 03:47:47 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:1611 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab3KYIro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 03:47:44 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 25 Nov 2013 00:41:31 -0800
Message-ID: <52930EAA.7030208@nvidia.com>
Date: Mon, 25 Nov 2013 17:47:38 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Alexandre Courbot <gnurou@gmail.com>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>, Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/7] net: rfkill: gpio: remove gpio conversion support
References: <1385122474-14926-1-git-send-email-mika.westerberg@linux.intel.com> <1385122474-14926-4-git-send-email-mika.westerberg@linux.intel.com> <CAAVeFuKm=AHf4Az+ZZXwWLtft2_zmCqy2Wscw25cWNCbn2T+dQ@mail.gmail.com> <20131125084127.GB21001@xps8300>
In-Reply-To: <20131125084127.GB21001@xps8300>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 05:41 PM, Heikki Krogerus wrote:
> On Sat, Nov 23, 2013 at 05:59:30PM +0900, Alexandre Courbot wrote:
>> Wouldn't it be possible (and simpler) to move patch 2 of your series
>> to first position, and then to merge patch 1 and 3 together in second
>> position? It seems to me that you are basically undoing much of the
>> work of your first patch here (notably by removing
>> rfkill_gpio_convert_to_desc() which ends up having a very short life)
>> and that this could be avoided if you defined the platform lookup
>> tables first.
>>
>> Doing so would avoid prevent you from using gpio_to_desc() which you
>> should never ever use anyway. :P
>
> Adding the lookup table in first patch and then changing the driver in
> the second creates a point to the history where this driver stops
> working on this platform, which is something I'm not willing to do.

Does it? If you just add a lookup table and keep using the integer-based 
GPIO interface, then your lookup table will not be used by anyone and 
will basically be a no-op. Then you can switch to the GPIO descriptor 
interface and take advantage of the lookup table. Unless I missed 
something there should not be any point that breaks in the git history.

(to be clear: the first patch should *only* contain the lookup table, 
and the second be a merge of the current patches 1 and 3 of this series.)

> But, we can make one patch out of all three if everybody is OK with
> that.

IIUC platform changes should be distinct from drivers whenever possible, 
so this is probably not the best choice here.

Alex.


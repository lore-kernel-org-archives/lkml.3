Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbaKYSdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 13:33:07 -0500
Received: from mga11.intel.com ([192.55.52.93]:46657 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622AbaKYSdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 13:33:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,456,1413270000"; 
   d="scan'208";a="637941983"
Message-ID: <5474CB5D.9050807@linux.intel.com>
Date: Tue, 25 Nov 2014 10:33:01 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Grant Likely <grant.likely@secretlab.ca>, Ben Zhang <benzh@chromium.org>,
        alsa-devel <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Bard Liao <bardliao@realtek.com>,
        Oder Chiou <oder_chiou@realtek.com>,
        Anatol Pomozov <anatol@google.com>, Dylan Reid <dgreid@chromium.org>,
        flove@realtek.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH 1/2] ASoC: rt5677: Add ACPI device probing
References: <1416034608-24238-1-git-send-email-benzh@chromium.org> <CACxGe6stjCvaQZkh=hFcF-56v5qJVar11jRZz0PRSd2wz6EUyA@mail.gmail.com> <5474A78C.7030805@linux.intel.com> <20141125172120.GI7712@sirena.org.uk>
In-Reply-To: <20141125172120.GI7712@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/25/14 09:21, Mark Brown wrote:
> On Tue, Nov 25, 2014 at 08:00:12AM -0800, Darren Hart wrote:
>> On 11/25/14 04:11, Grant Likely wrote:
> 
>>> Also, since this patch is targeted at v3.19 or later, the 
>>> device-properties API should be used. Don't create something
>>> custom.
> 
>> Right. The ACPI/UEFI forum is managing the creation of new DSD
>> bindings and ensuring they are documented online. I believe this
>> is the... 3rd so far? So we're still optimizing the process. But
>> yes, please, send the schema itself for review and let's get this
>> documented and migrated over to _DSD.
> 
> To be clear the main reason I'm querying this is that it doesn't
> appear to be a _DSD based binding at all (as far as I understand
> it, the API it's using is from before the dawn of time or at least
> the dawn of git).
> 
> Given the design of _DSD is to share with DT and we already have
> device tree bindings for the device we should be using, it's not
> clear to me if we want to grind them all through UEFI and I suspect
> they'd be unhappy if we tried but pretty much all audio CODECs are
> good candidates for use with ACPI given the new hardware designs
> Intel have so if we are doing it I ought to be bouncing everyone to
> UEFI forum.

Right, I realized between sending and driving into the office that my
statement might be construed this way. I meant *new* _DSD bindings
should go through the ACPI/UEFI forum. Where we can reuse DT bindings,
we should absolutely do that, agreed. We should still document this
and link to the DT binding so it can be referenced and used even when
Linux is not the target OS.

-- 
Darren Hart
Intel Open Source Technology Center

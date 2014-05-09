Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbaEIH43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 03:56:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:2457 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755323AbaEIH4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 03:56:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1016,1389772800"; 
   d="scan'208";a="429848765"
Message-ID: <536C8CCC.8010600@linux.intel.com>
Date: Fri, 09 May 2014 11:07:40 +0300
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
CC: Julius Werner <jwerner@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [regression 3.15-rc3] Resume from s4 broken by 1f81b6d22a5980955b01e08cf27fb745dc9b686f
References: <20140505180530.GA18465@intel.com> <CAODwPW_57G+Lebe2Xarem9P-L6ePtAaZfy5kpNVEtgkWbc0FWw@mail.gmail.com> <20140506114126.GB18465@intel.com> <536A39C0.5060205@linux.intel.com> <20140507150240.GK18465@intel.com>
In-Reply-To: <20140507150240.GK18465@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> I can't see how this relates to Julius patch though, and I'm not sure yet why it
>> only triggers when devices are connected to SS ports. Maybe just unlucky timing?
>
> I think the non-SS ports are connected to the EHCI controllers rather
> than the XHCI controllers. So that explains at least one detail. And I
> guess timing is as good an excuse as any why this gets exposed by the
> patch in question.

That's right, sometimes I forget that there exists something else than xHCI.

>
>>
>> Does this help?:
>
> Indeed it does. The machine just survived a dozen or so suspend+resume
> cycles without a hitch. The bug was 100% reproducible on this machine,
> so the fix seems solid.
>
> Tested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
>

Great, a patch with your Tested-by tag pushed to my tree at:

git://git.kernel.org/pub/scm/linux/kernel/git/mnyman/xhci.git for-usb-linus

-Mathias



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934585AbaDJBwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 21:52:23 -0400
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:38806 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934552AbaDJBwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 21:52:19 -0400
Message-ID: <5345F951.8020603@akamai.com>
Date: Wed, 09 Apr 2014 21:52:17 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@alien8.de>, Aristeu Rozanski <aris@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "mingo@kernel.org" <mingo@kernel.org>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "mitake@dcl.info.waseda.ac.jp" <mitake@dcl.info.waseda.ac.jp>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] ie31200_edac: Add driver
References: <cover.1396645124.git.jbaron@akamai.com> <760765424abe31811027ff3efd078bc858b7d3ed.1396645124.git.jbaron@akamai.com> <20140409113552.GJ6529@pd.tnic> <20140409133433.GJ29214@redhat.com> <3908561D78D1C84285E8C5FCA982C28F31E22EAC@ORSMSX106.amr.corp.intel.com> <20140409173633.GN6529@pd.tnic> <5345980F.7070604@akamai.com> <20140409191454.GQ6529@pd.tnic> <5345A54D.2050808@akamai.com> <20140409201615.GS6529@pd.tnic> <3908561D78D1C84285E8C5FCA982C28F31E2358F@ORSMSX106.amr.corp.intel.com> <5345C683.2080307@akamai.com> <3908561D78D1C84285E8C5FCA982C28F31E237A2@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31E237A2@ORSMSX106.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2014 06:44 PM, Luck, Tony wrote:
>> So when the driver sees uncorrected errors, I'm also seeing them in my
>> memory scanning program - so they correspond nicely. I didn't see anything
>> logged in /var/log/mcelog, but I will update to the latest when possible.
> I wonder if there are some BIOS options to enable reporting via CMCI/MCE?
> On the E5 systems the reference BIOS uses phrases like "poison forwarding"
> in the option names.
>
> The above behavior sounds less than useful.
>
> Scenario: Your mission critical app is running (controlling a giant laser cutter).
> Oops there is a memory error, and the bad data arrives at the application causing
> it to swing the laser beam through 180 degrees, destroying half of your lab.
> A few seconds/minutes later - your EDAC driver prints a message saying that
> the uncorrected error count just got incremented.
>
> -Tony

Agreed, and I don't like the polling either. But so far on this h/w I have not
been able to find a better option.

I also seem to recall, that ce errors tend to proceed ue errors. So, I think
alerting on ce errors can help avoid getting into ue errors.

So IMO there is currently value in this driver, and I know others have
requested support for this h/w in the past (on the edac mailing lists).

I'll see what else I can find once I get the problematic h/w in hand.

Thanks,

-Jason


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab3ISWMq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 18:12:46 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:50750 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab3ISWMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 18:12:45 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1379626776.753.164.camel@shinybook.infradead.org>
References: <20130919194752.GA19975@quad.lixom.net>
	<1379626776.753.164.camel@shinybook.infradead.org>
Date: Thu, 19 Sep 2013 15:12:42 -0700
Message-ID: <CAOesGMg3EPrEcaJ4cqhCzK+54CNXa+xN3gEMoBnsBmgW67DKHA@mail.gmail.com>
Subject: Re: [GIT PULL] ARM: SoC fixes for 3.12-rc
From: Olof Johansson <olof@lixom.net>
To: "Woodhouse, David" <david.woodhouse@intel.com>
Cc: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 2:39 PM, Woodhouse, David
<david.woodhouse@intel.com> wrote:
> On Thu, 2013-09-19 at 12:47 -0700, Olof Johansson wrote:
>>
>> - A fix for build breakage in the MTD subsystem for some PXA devices.
>>   David Woodhouse has this patch in his for-next branch but has not been
>>   responding to our requests to send it up so here it is.
>>   I should have amended the commit message to describe the build failure for
>>   CONFIG_OF=n setups, but forgot and now it's down in the stack of commits.
>
> Thanks for pulling that in. Apologies for the screwup.

No worries. You're a busy guy these days.

> We were were working on a better way to fix the litter of #ifdef
> CONFIG_OF which wasn't ready for the merge window so I just left this
> one out since it *appeared* to be entirely cosmetic.

Yeah, the real bug is a missing stub function in the #else case, but
if the ifdef is all going away there's no point in adding it.

The ifdeffery around the match tables is something that Mark Brown
brought up yesterday as well. With ACPI_PTR() and of_match_ptr() we at
least don't need the ifdefs in the struct device, but we do still need
it for the match tables.


-Olof

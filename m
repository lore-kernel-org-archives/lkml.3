Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab3AaRXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 12:23:22 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:60012 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab3AaRXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 12:23:20 -0500
Message-ID: <510AA885.5000603@wwwdotorg.org>
Date: Thu, 31 Jan 2013 10:23:17 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [RFC 1/4] video: panel: add CLAA101WA01A panel support
References: <1359514939-15653-1-git-send-email-acourbot@nvidia.com> <1359514939-15653-2-git-send-email-acourbot@nvidia.com> <51098229.7080508@wwwdotorg.org> <CAAVeFuJkJ4cftWvSvt1YJa6c48JyJPVTu=i18yMHptZMi3DAzg@mail.gmail.com>
In-Reply-To: <CAAVeFuJkJ4cftWvSvt1YJa6c48JyJPVTu=i18yMHptZMi3DAzg@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2013 09:14 PM, Alexandre Courbot wrote:
> On Thu, Jan 31, 2013 at 5:27 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> So this looks like a reasonable binding to me. The one issue is that
>> it's very generic, and if we go this route, we'll probably end up with
>> tens or hundreds of identical or extremely similar simple bindings, and
>> associated drivers.
>>
>> We can avoid this instead by defining something like a "simple-lcd"
>> binding, and associated driver, that will work for perhaps 90%, 95%,
>> 99%, even 100%(?) of panels.
> 
> That seems totally doable indeed. Actually the right way to do this
> might be by extending the simple DPI panel driver Laurent included in
> his patchset.
> 
>> Just like the above, but with:
>>
>> compatible="simple-panel", "chunghwa,claa101wa01a"
>>
>> instead, and the driver binding to "simple-panel" rather than
>> "chunghwa,claa101wa01a".
> 
> Just out of curiosity, why don't we rather define
> 
> compatible="chunghwa,claa101wa01a", "simple-panel"
> 
> in that order? I thought DT compatible strings should go from more to
> less specific. The device would still bind to "simple-panel" if no
> more specific driver exists.

Yes, that's correct; I "typo"d the example I gave.

>> The driver can assume that a specific set of supplies (and perhaps
>> GPIOs) is always present, and that the /sequence/ of manipulating those
>> is fixed. This will avoid the need for anything like the power sequences
>> code. If a particular panel doesn't fit those assumptions, including the
>> exact sequence of manipulations for each state transition (which should
>> be documented in the binding) then it can get a custom driver, this also
>> avoiding having to define custom sequences in DT.
>>
>> Things that might be parameterized/optional:
>>
>> * Perhaps some GPIOs aren't always present.
>> * If some regulators aren't SW-controllable, DT should still provide a
>> fixed/dummy regulator so the driver doesn't care.
> 
> How about making all regulators and GPIO optional in the driver?

The general feedback I've received is that regulators should always be
present, and simply implemented by fixed/dummy regulators if missing in
a particular board design, rather than having the driver code handle
them being optional. This certainly does simplify the driver, since it
can always unconditionally program the regulator irrespective of whether
it's fixed/dummy or not.


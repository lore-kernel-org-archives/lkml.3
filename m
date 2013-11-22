Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab3KVVBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 16:01:05 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:36418 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab3KVVBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 16:01:03 -0500
Message-ID: <528FC60A.80308@wwwdotorg.org>
Date: Fri, 22 Nov 2013 14:00:58 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Thierry Reding <thierry.reding@gmail.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/7] net: rfkill: gpio: remove gpio conversion support
References: <1385122474-14926-1-git-send-email-mika.westerberg@linux.intel.com> <1385122474-14926-4-git-send-email-mika.westerberg@linux.intel.com> <528FA520.7080501@wwwdotorg.org> <20131122205640.GA21895@xps8300>
In-Reply-To: <20131122205640.GA21895@xps8300>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2013 01:56 PM, Heikki Krogerus wrote:
> On Fri, Nov 22, 2013 at 11:40:32AM -0700, Stephen Warren wrote:
>> On 11/22/2013 05:14 AM, Mika Westerberg wrote:
>>> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>>>
>>> All platforms using this driver are now converted to the new
>>> descriptor-based GPIO interface.
>>
>> Don't you want to remove the fields from the pdata structure too, since
>> it's pointless to set them anymore IIUC?
> 
> Agreed. We should have removed them in this patch.
> 
> I have prepared a separate patch where I remove those and some other
> unused fields from the pdata structure (attachment). Would it be OK to
> add that to this patch set? Or should this patch simply be updated?

I would suggest killing off the two GPIO fields in this patch, since
it's logically part of this change. I think the balance of the patch is
unrelated to gpiod conversion, so should probably be sent separately,
although watch out for dependencies.


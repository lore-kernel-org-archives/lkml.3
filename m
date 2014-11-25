Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbaKYLNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:13:36 -0500
Received: from smtp73.ord1c.emailsrvr.com ([108.166.43.73]:50941 "EHLO
	smtp73.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754307AbaKYLNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 06:13:33 -0500
X-Sender-Id: pramod.gurav@smartplayin.com
Message-ID: <54746533.1010408@smartplayin.com>
Date: Tue, 25 Nov 2014 16:47:07 +0530
From: Pramod Gurav <pramod.gurav@smartplayin.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        lgirdwood@gmail.com
Subject: Re: [RFC PATCH] regulator: core: do not disable regulator if boot_on
 is set
References: <1416912803-10772-1-git-send-email-pramod.gurav@smartplayin.com> <20141125110540.GL7712@sirena.org.uk>
In-Reply-To: <20141125110540.GL7712@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tuesday 25 November 2014 04:35 PM, Mark Brown wrote:
> On Tue, Nov 25, 2014 at 04:23:23PM +0530, Pramod Gurav wrote:
>> Currently the regulator core disables the regulators which are unused
>> or whose reference count is zero or if they are configured always_on.
> 
> No, it does *not* disable them if they are configured always_on (as the
> code you're modifying shows).

Yes, thats a typo.
> 
>> This change adds a check in this logic to see if a regulator is
>> configured as boot_on and does not disable it if found true.
> 
>> -		if (c && c->always_on)
>> +		if (c && (c->always_on || c->boot_on))
>>  			continue;
> 
> This isn't what boot_on means.  It just means that the regulator is
> expected to be enabled at initial power on, it doesn't mean it needs to
> be enabled all the time.  Otherwise there'd be no point in having a
> separate always_on flag.

Thanks for the comment. :-)
> 

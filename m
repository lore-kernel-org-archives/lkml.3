Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbaA0EQh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 23:16:37 -0500
Received: from mail.active-venture.com ([67.228.131.205]:64078 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbaA0EQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 23:16:36 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52E5DDA5.2010705@roeck-us.net>
Date: Sun, 26 Jan 2014 20:16:37 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Jean Delvare <khali@linux-fr.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Wei Ni <wni@nvidia.com>, linux-kernel@vger.kernel.org,
        LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] lm90 driver no longer working on PCs in 3.13
References: <52E561D0.4040308@roeck-us.net> <20140126211357.6fa68909@endymion.delvare> <52E573B6.9040903@roeck-us.net> <20140126214936.7736f530@endymion.delvare> <52E58330.90602@roeck-us.net> <52E58656.7000903@roeck-us.net> <20140126235103.GP11727@sirena.org.uk>
In-Reply-To: <20140126235103.GP11727@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2014 03:51 PM, Mark Brown wrote:
> On Sun, Jan 26, 2014 at 02:04:06PM -0800, Guenter Roeck wrote:
>
>> I think I have a better idea: Surround the regulator code, or at least
>> its error handling, in the lm90 driver with
>
>> 	if (IS_ENABLED(CONFIG_OF)) {
>> 	}
>
>> Would that be ok ? If yes I'll submit a patch. I'll do the same in
>> another driver I am working on.
>
> That's not going to have the desired effect in cases where DT is built
> into the kernel but not in use on the current system (which is a
> configuration that gets used) and will remove error handling for non-DT
> systems that do have regulators set up.  There's not the relationship
> between this and DT that you seem think there is...
>
> Besides, if we're going to do a bodge like that we should do it in the
> core and not in individual callers.
>

Then it appears the only remedy at this time is to revert the patch.

Guenter


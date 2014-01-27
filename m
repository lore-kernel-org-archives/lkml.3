Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbaA0RT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 12:19:28 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:56234 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516AbaA0RT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 12:19:27 -0500
Message-ID: <52E6951C.60609@wwwdotorg.org>
Date: Mon, 27 Jan 2014 10:19:24 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Guenter Roeck <linux@roeck-us.net>
CC: Jean Delvare <khali@linux-fr.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Wei Ni <wni@nvidia.com>, linux-kernel@vger.kernel.org,
        LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] lm90 driver no longer working on PCs in 3.13
References: <52E561D0.4040308@roeck-us.net> <20140126211357.6fa68909@endymion.delvare> <52E573B6.9040903@roeck-us.net> <20140126214936.7736f530@endymion.delvare> <52E58330.90602@roeck-us.net> <52E58656.7000903@roeck-us.net> <20140126235103.GP11727@sirena.org.uk>
In-Reply-To: <20140126235103.GP11727@sirena.org.uk>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2014 04:51 PM, Mark Brown wrote:
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
> configuration that gets used) ...

The solution to that particular aspect of the problem is the following:

if (of_have_populated_dt()) {
	...

which is a run-time rather than compile-time test.


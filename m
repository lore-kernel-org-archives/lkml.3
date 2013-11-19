Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab3KSRLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 12:11:32 -0500
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:62969 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753478Ab3KSRLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 12:11:30 -0500
Message-ID: <528B9BC1.7090402@akamai.com>
Date: Tue, 19 Nov 2013 12:11:29 -0500
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: "mingo@kernel.org" <mingo@kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "paulus@samba.org" <paulus@samba.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        Florian Fainelli <florian@openwrt.org>,
        Shinya Kuribayashi <skuribay@ruby.dti.ne.jp>,
        Jayachandran C <jchandra@broadcom.com>,
        Ganesan Ramalingam <ganesanr@broadcom.com>
Subject: Re: [PATCH v2] panic: Make panic_timeout configurable
References: <20131118210436.233B5202A@prod-mail-relay06.akamai.com> <20131119090211.GN10382@linux-mips.org>
In-Reply-To: <20131119090211.GN10382@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2013 04:02 AM, Ralf Baechle wrote:
> On Mon, Nov 18, 2013 at 09:04:36PM +0000, Jason Baron wrote:
> 
>> The panic_timeout value can be set via the command line option 'panic=x', or via
>> /proc/sys/kernel/panic, however that is not sufficient when the panic occurs
>> before we are able to set up these values. Thus, add a CONFIG_PANIC_TIMEOUT
>> so that we can set the desired value from the .config.
>>
>> The default panic_timeout value continues to be 0 - wait forever, except for
>> powerpc and mips, which have been defaulted to 180 and 5 respectively. This
>> is in keeping with the fact that these arches already set panic_timeout in
>> their arch init code. However, I found three exceptions- two in mips and one in
>> powerpc where the settings didn't match these default values. In those cases, I
>> left the arch code so it continues to override, in case the user has not changed
>> from the default. It would nice if these arches had one default value, or if we
>> could determine the correct setting at compile-time.
> 
> It's more complicated - MIPS was using the global default with five MIPS
> platforms overriding the default.
> 
> I propose to kill these overrides for sanity unless somebody comes up
> with a good argument.  Patch below.
> 

And so have the mips default be 0? IE drop the arch/mips/Kconfig bits from
the patch I posted? (Which could of course be configured to a non-zero value
by the user, if desired.)

Thanks,

-Jason


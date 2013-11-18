Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab3KRXNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 18:13:43 -0500
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:38086 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307Ab3KRXNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 18:13:41 -0500
Message-ID: <528A9F24.1000206@akamai.com>
Date: Mon, 18 Nov 2013 18:13:40 -0500
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "mingo@kernel.org" <mingo@kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "paulus@samba.org" <paulus@samba.org>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: Re: [PATCH v2] panic: Make panic_timeout configurable
References: <20131118210436.233B5202A@prod-mail-relay06.akamai.com> <20131118143059.afe17d2faced16171a05eb10@linux-foundation.org>
In-Reply-To: <20131118143059.afe17d2faced16171a05eb10@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 05:30 PM, Andrew Morton wrote:
> On Mon, 18 Nov 2013 21:04:36 +0000 (GMT) Jason Baron <jbaron@akamai.com> wrote:
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
> Felipe is proposing a simpler patch ("panic: setup panic_timeout
> early") which switches to early_param().  Is that sufficient for the
> (undescribed!) failure which you are presumably observing?
> 

No - that patch doesn't change the 'panic_timeout' value until the call
to 'parse_early_param()' is made. If there is a panic before that point, the
param doesn't do anything. The idea of this patch is to allow it to be configured
at build-time.

I've tested the patch by simply inserting a panic() call at the beginning of
'start_kernel()'. So, no I do not have a specific panic in mind for this.

Thanks,

-Jason

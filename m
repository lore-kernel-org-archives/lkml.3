Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197Ab3LDLv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 06:51:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932099Ab3LDLv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 06:51:56 -0500
Message-ID: <529F174D.3030805@redhat.com>
Date: Wed, 04 Dec 2013 06:51:41 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/3] Introduce FW_INFO* functions and messages
References: <1385997579-22240-1-git-send-email-prarit@redhat.com>	<1385997579-22240-2-git-send-email-prarit@redhat.com> <20131203132120.6a7ab2cd7cc99720712cbe6a@linux-foundation.org>
In-Reply-To: <20131203132120.6a7ab2cd7cc99720712cbe6a@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/03/2013 04:21 PM, Andrew Morton wrote:
> On Mon,  2 Dec 2013 10:19:37 -0500 Prarit Bhargava <prarit@redhat.com> wrote:
> A slight simplification:
> 
>> +static inline char *dump_hadware_arch_desc(void)
>> +{
>> +	return NULL;
>> +}
> 
> 	return "unavailable";
> 
>> +void warn_slowpath_fmt_dev(const char *file, int line,
>> +			   struct device *dev, int level, const char *fmt, ...)
>> +{
>> +	struct slowpath_args args;
>> +	static char fw_str[16] = "\0";
>> +
>> +	switch (level) {
>> +	case 1:
>> +		strcpy(fw_str, "[Firmware Info]");
>> +		break;
>> +	case 2:
>> +		strcpy(fw_str, "[Firmware Warn]");
>> +		break;
>> +	case 3:
>> +		strcpy(fw_str, "[Firmware Bug]");
> 
> What's With The Crazy Capitalization In This Code?  It's Illiterate!

Heh :) it's what the original FW_* strings were defined as.  I was hoping it was
okay to change them but wasn't 100% sure if I should.  I'll definitely take that
(and the suggestion above) into v2.

<snip>

> 
> The general thrust of the patchset seems useful and important.  I do
> agree with Joe's suggestion regarding the presentation, although it
> isn't a show-stopper.

In V2, I'll take Joe's suggestion into account.  It isn't that difficult to
rework those chunks of the patch into a single patch.

> 
> I do wonder if it all should be generalised a bit - it creates a bunch
> of infrastructure which is specific to system firmware issues, but
> what's so special about firmware?  Why can't I use this infrastructure
> to log netdev errors or acpi errors or PM errors or...?  But I didn't
> think about it much ;)

Well ... I was thinking about this.  Some drivers do keep track of firmware
versions for their devices and I think there is probably a way to unify all that.

Also, I think after this initial change goes in I'm going to grep through the
PCI & ACPI code to see what FW_* changes need to be made there.  AFAICT there
are many locations in those areas which should be FW_*.

I'll get a [v2] out in a little while.  Thanks Joe & Andrew for looking.

P.
> 
> 

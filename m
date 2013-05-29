Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965473Ab3E2JhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 05:37:14 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:14443 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965198Ab3E2JhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 05:37:12 -0400
X-IronPort-AV: E=Sophos;i="4.87,763,1363132800"; 
   d="scan'208";a="26599588"
Message-ID: <51A5CC46.60508@citrix.com>
Date: Wed, 29 May 2013 10:37:10 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: John Stultz <john.stultz@linaro.org>, <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/2] x86/xen: sync the wallclock when the
 system time changes
References: <1369765368-10823-1-git-send-email-david.vrabel@citrix.com> <1369765368-10823-3-git-send-email-david.vrabel@citrix.com> <51A5CEB402000078000D97BA@nat28.tlf.novell.com>
In-Reply-To: <51A5CEB402000078000D97BA@nat28.tlf.novell.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/05/13 08:47, Jan Beulich wrote:
>>>> On 28.05.13 at 20:22, David Vrabel <david.vrabel@citrix.com> wrote:
>> @@ -199,28 +201,59 @@ static void xen_get_wallclock(struct timespec *now)
>>  
>>  static int xen_set_wallclock(const struct timespec *now)
>>  {
>> -	struct xen_platform_op op;
>> -	int ret;
>> -
>>  	/* do nothing for domU */
>>  	if (!xen_initial_domain())
>>  		return -1;
>>  
>> -	/* Set the Xen wallclock. */
>> +	/* Set the hardware RTC. */
>> +	return mach_set_rtc_mmss(now);
>> +
>> +}
> 
> Can't you achieve the same effect in a cleaner way by overriding
> x86_platform.set_wallclock only in the non-init-domain case?

Yes, that makes sense.  John, don't apply this one yet, thanks.

David

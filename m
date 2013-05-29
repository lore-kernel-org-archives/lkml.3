Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966617Ab3E2T6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 15:58:23 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:34898 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966353Ab3E2T6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 15:58:18 -0400
Message-ID: <51A65DD5.5050305@linaro.org>
Date: Wed, 29 May 2013 12:58:13 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: Jan Beulich <JBeulich@suse.com>, xen-devel@lists.xen.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 2/2] x86/xen: sync the wallclock when the
 system time changes
References: <1369765368-10823-1-git-send-email-david.vrabel@citrix.com> <1369765368-10823-3-git-send-email-david.vrabel@citrix.com> <51A5CEB402000078000D97BA@nat28.tlf.novell.com> <51A5CC46.60508@citrix.com>
In-Reply-To: <51A5CC46.60508@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2013 02:37 AM, David Vrabel wrote:
> On 29/05/13 08:47, Jan Beulich wrote:
>>>>> On 28.05.13 at 20:22, David Vrabel <david.vrabel@citrix.com> wrote:
>>> @@ -199,28 +201,59 @@ static void xen_get_wallclock(struct timespec *now)
>>>   
>>>   static int xen_set_wallclock(const struct timespec *now)
>>>   {
>>> -	struct xen_platform_op op;
>>> -	int ret;
>>> -
>>>   	/* do nothing for domU */
>>>   	if (!xen_initial_domain())
>>>   		return -1;
>>>   
>>> -	/* Set the Xen wallclock. */
>>> +	/* Set the hardware RTC. */
>>> +	return mach_set_rtc_mmss(now);
>>> +
>>> +}
>> Can't you achieve the same effect in a cleaner way by overriding
>> x86_platform.set_wallclock only in the non-init-domain case?
> Yes, that makes sense.  John, don't apply this one yet, thanks.
Ok. Zapped from my tree.

thanks
-john


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab3IWRvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 13:51:11 -0400
Received: from mail.tpi.com ([74.45.170.26]:58746 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567Ab3IWRvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 13:51:10 -0400
Message-ID: <52407F8D.7050902@canonical.com>
Date: Mon, 23 Sep 2013 10:51:09 -0700
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.12-rc1] USB: input: cm109.c: Convert high volume dev_err()
 to dev_err_ratelimited()
References: <1378830193-48384-1-git-send-email-tim.gardner@canonical.com> <20130919215246.GB16015@core.coreip.homeip.net>
In-Reply-To: <20130919215246.GB16015@core.coreip.homeip.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2013 02:52 PM, Dmitry Torokhov wrote:
> Hi Tim,
> 
> On Tue, Sep 10, 2013 at 10:23:13AM -0600, Tim Gardner wrote:
>> BugLink: http://bugs.launchpad.net/bugs/1222850
>>
>> This input device can get into a state that produces a high
>> volume of device status errors. Attempt to throttle these
>> error messages such that the kernel log is not flooded.
>>
> 
> Only 2 of these printks need to be rate-limited, as other failures are
> fatal to the driver since it will not resubmit the IO.
> 
> Also I think we need to try and resubmit control URB to try and execute
> buzzer command if previous one failed.
> 
> BTW, EPROTO/EILSEQ errors mentioned in the launchpad bug seem to relate
> to timeout/CRC errors reported by the host controller, so it must indeed
> be the extender that is misbehaving.
> 
> Thanks.
> 

Looks good to me.

rtg
-- 
Tim Gardner tim.gardner@canonical.com

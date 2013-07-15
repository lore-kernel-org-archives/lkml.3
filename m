Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab3GOGx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 02:53:57 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:43802 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984Ab3GOGx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 02:53:56 -0400
Message-ID: <51E39BAB.4060308@linux.vnet.ibm.com>
Date: Mon, 15 Jul 2013 12:20:19 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?S=F6ren_Brinkmann?= <soeren.brinkmann@gmail.com>
CC: Willy Tarreau <w@1wt.eu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [REGRESSION 3.10.1] System does not wake up from suspend
References: <20130715043625.GA2162@skorgonTP.att.net> <20130715045400.GU32054@1wt.eu>
In-Reply-To: <20130715045400.GU32054@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071506-2000-0000-0000-00000CE37D24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 10:24 AM, Willy Tarreau wrote:
> On Sun, Jul 14, 2013 at 09:36:25PM -0700, Sören Brinkmann wrote:
>> Hi Greg,
>>
>> since upgrading to 3.10.1 I find my system not waking up from suspend
>> from time to time. Unfortunately, I couldn't figure out how to reliably
>> reproduce the issue. Sometimes it works just fine.
>>
>> All I know so far:
>> On 3.10 I had my system completely freezing a few times. But that did
>> not seem to be related to suspend/resume. I never experienced the
>> behavior described below on 3.10.
>>
>> On 3.10.1 I hit this bug a few times, that my system did not wake up.
>> I.e. the screen stayed black and the power LED kept flashing. But
>> nothing brought the system back up and I had to longpress power to reset
>> the system.
>> I had none of the system freezes like the ones described above anymore.
> 
> Fortunately, 3.10.1 is very small. The only patch it contains which is
> related to suspend is 18/19 (cpufreq ondemand governor). Maybe you're
> having a problem with cpufreq on this machine in fact.
> 
> You may want to try to force it to performance mode or powersave mode
> and try for a while, it is possible that both 3.10 and 3.10.1 will work
> fine.
> 

Or, you could try applying the patch shown below on top of 3.10.1 and
see if it fixes the suspend/resume regression for you.

https://lkml.org/lkml/2013/7/11/661

(Just apply patch 1, not the entire patchset).
 
Regards,
Srivatsa S. Bhat


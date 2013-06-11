Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab3FKSp0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 14:45:26 -0400
Received: from mail1.bemta12.messagelabs.com ([216.82.251.11]:27653 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754558Ab3FKSpY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 14:45:24 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-127.messagelabs.com!1370976320!8615047!4
X-Originating-IP: [216.166.12.72]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: Ryan Mallon <rmallon@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "poeschel@lemonage.de" <poeschel@lemonage.de>,
        "rob@landley.net" <rob@landley.net>
Date: Tue, 11 Jun 2013 13:45:37 -0500
Subject: RE: [PATCH v4] pwm: add sysfs interface
Thread-Topic: [PATCH v4] pwm: add sysfs interface
Thread-Index: Ac5m0nJhKmrxAvILTMKCPO2lV/4dNAAACYTw
Message-ID: <ADE657CA350FB648AAC2C43247A983F0021DA690F6BE@AUSP01VMBX24.collaborationhost.net>
References: <201306101612.07708.hartleys@visionengravers.com>
 <20130611101432.GA932@manwe> <51B709F5.8070909@gmail.com>
 <ADE657CA350FB648AAC2C43247A983F0021DA690F61B@AUSP01VMBX24.collaborationhost.net>
 <ADE657CA350FB648AAC2C43247A983F0021DA690F63A@AUSP01VMBX24.collaborationhost.net>
 <20130611183521.GC29842@mithrandir>
In-Reply-To: <20130611183521.GC29842@mithrandir>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 11, 2013 11:35 AM, Thierry Reding wrote:
> On Tue, Jun 11, 2013 at 11:47:23AM -0500, H Hartley Sweeten wrote:
>> On Tuesday, June 11, 2013 9:09 AM, H Hartley Sweeten wrote:
>>> On Tuesday, June 11, 2013 4:29 AM, Ryan Mallon wrote:
>>>> On 11/06/13 20:14, Thierry Reding wrote:
>>>>> On Mon, Jun 10, 2013 at 04:12:07PM -0700, H Hartley Sweeten wrote:
>>>>>> +config PWM_SYSFS
>>>>>> +	bool "/sys/class/pwm/... (sysfs interface)"
>>>>>> +	depends on SYSFS
>>>>>> +	help
>>>>>> +	  Say Y here to provide a sysfs interface to control PWMs.
>>>>>> +
>>>>>> +	  For every instance of a PWM device there is a pwmchipN directory
>>>>>> +	  created in /sys/class/pwm. Use the export attribute to request
>>>>>> +	  a PWM to be accessible from userspace and the unexport attribute
>>>>>> +	  to return the PWM to the kernel. Each exported PWM will have a
>>>>>> +	  pwmX directory in the pwmchipN it is associated with.
>>>>> 
>>>>> I have a small quibble with this. Introducing options like this make it
>>>>> increasingly difficult to compile-test all the various combinations, so
>>>>> I'd like to see this converted to a form that will play well with the
>>>>> IS_ENABLED() macro. We already have the same issue with DEBUG_FS, only
>>>>> to a lesser degree because it doesn't have an additional PWM-specific
>>>>> Kconfig option.
>>>
>>> How about removing the Kconfig option and just doing:
>>>
>>> obj-$(CONFIG_SYSFS)			+= sysfs.o
>>>
>>> This way the PWM sysfs interface is always compiled and included in the build
>>> as long as CONFIG_SYSFS is enabled. The check in the header would change to
>> 
>> That didn't work. As Ryan pointed out we get undefined references due to
>> sysfs.c being compiled but not core.c when CONFIG_PWM is not enabled.
>
> Why not add dummies for the missing functions? It was my impression that
> we had dummies for all of them already, but if not they should certainly
> be added to match what other subsystems do.

I just looked it over and the undefined reference was for pwm_set_polarity().
The dummy for that function is missing.

The other problem with this approach is the sysfs.c file gets compiled whenever
CONFIG_SYSFS is enabled even if CONFIG_PWM is not enabled.

Hartley

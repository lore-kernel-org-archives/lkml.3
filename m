Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab3FKQrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 12:47:12 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.199]:23811 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755221Ab3FKQrJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 12:47:09 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-132.messagelabs.com!1370969224!12673178!5
X-Originating-IP: [216.166.12.98]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>,
        Ryan Mallon <rmallon@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "poeschel@lemonage.de" <poeschel@lemonage.de>,
        "rob@landley.net" <rob@landley.net>
Date: Tue, 11 Jun 2013 11:47:23 -0500
Subject: RE: [PATCH v4] pwm: add sysfs interface
Thread-Topic: [PATCH v4] pwm: add sysfs interface
Thread-Index: Ac5mlZpotj+vw08tQeKXWwQT+hY1LQAJ4LjAAAFTr5A=
Message-ID: <ADE657CA350FB648AAC2C43247A983F0021DA690F63A@AUSP01VMBX24.collaborationhost.net>
References: <201306101612.07708.hartleys@visionengravers.com>
 <20130611101432.GA932@manwe> <51B709F5.8070909@gmail.com>
 <ADE657CA350FB648AAC2C43247A983F0021DA690F61B@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0021DA690F61B@AUSP01VMBX24.collaborationhost.net>
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

On Tuesday, June 11, 2013 9:09 AM, H Hartley Sweeten wrote:
> On Tuesday, June 11, 2013 4:29 AM, Ryan Mallon wrote:
>> On 11/06/13 20:14, Thierry Reding wrote:
>>> On Mon, Jun 10, 2013 at 04:12:07PM -0700, H Hartley Sweeten wrote:
>>>> +config PWM_SYSFS
>>>> +	bool "/sys/class/pwm/... (sysfs interface)"
>>>> +	depends on SYSFS
>>>> +	help
>>>> +	  Say Y here to provide a sysfs interface to control PWMs.
>>>> +
>>>> +	  For every instance of a PWM device there is a pwmchipN directory
>>>> +	  created in /sys/class/pwm. Use the export attribute to request
>>>> +	  a PWM to be accessible from userspace and the unexport attribute
>>>> +	  to return the PWM to the kernel. Each exported PWM will have a
>>>> +	  pwmX directory in the pwmchipN it is associated with.
>>> 
>>> I have a small quibble with this. Introducing options like this make it
>>> increasingly difficult to compile-test all the various combinations, so
>>> I'd like to see this converted to a form that will play well with the
>>> IS_ENABLED() macro. We already have the same issue with DEBUG_FS, only
>>> to a lesser degree because it doesn't have an additional PWM-specific
>>> Kconfig option.
>
> How about removing the Kconfig option and just doing:
>
> obj-$(CONFIG_SYSFS)			+= sysfs.o
>
> This way the PWM sysfs interface is always compiled and included in the build
> as long as CONFIG_SYSFS is enabled. The check in the header would change to

That didn't work. As Ryan pointed out we get undefined references due to
sysfs.c being compiled but not core.c when CONFIG_PWM is not enabled.

I'll change the PWM_SYSFS to a hidden option and repost the patch to see if
that is acceptable. Like Ryan mentioned, most test configs have CONFIG_SYSFS
enabled so as long as CONFIG_PWM is enabled we also get the sysfs interface.

Regards,
Hartley



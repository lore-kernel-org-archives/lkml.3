Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbaBDOWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 09:22:34 -0500
Received: from mail.active-venture.com ([67.228.131.205]:58445 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaBDOWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 09:22:32 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52F0F7A6.4070700@roeck-us.net>
Date: Tue, 04 Feb 2014 06:22:30 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: Would devm_regulator_enable be useful ?
References: <52ED901F.3010002@roeck-us.net> <20140203182152.GG22609@sirena.org.uk> <20140203222726.GA5053@roeck-us.net> <20140204111045.GS22609@sirena.org.uk>
In-Reply-To: <20140204111045.GS22609@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2014 03:10 AM, Mark Brown wrote:
> On Mon, Feb 03, 2014 at 02:27:26PM -0800, Guenter Roeck wrote:
>> On Mon, Feb 03, 2014 at 06:21:52PM +0000, Mark Brown wrote:
>
>>> As previously mentioned please fix your mailer to word wrap at a
>>> sensible limit.
>
>> I thought I did ;-). I'll try to make sure I only send e-mail to you
>> using mutt in the future ... but I notice that your line length is
>> less than the one I configured, so maybe that is the problem here.
>
> You need to allow some room for quoting.
>
>>> In both cases enabling and then leaving the resource enabled throughout
>>> the runtime of the device isn't normally the best practice for using
>>> them.  You usually want to enable and disable at runtime with mechanisms
>>> like runtime PM when the device is idle rather than burning power all
>>> the time and once you start doing that managed resources don't fit so
>>> well.
>
>> Ok, I accept that. I thought that was what devm_xxx_[disable,remove] etc
>> was for, though.
>
> Sort of.  They're there but that doesn't mean that they should be used
> in normal operation - they should be special cases, not normal things.
> Managed resources are supposed to for things that are more fire and
> forget.
>

Isn't that a bit philosophical ? The drivers I had in mind commonly
call regulator_enable() in probe and regulator_disable() in remove.
Having device managed functions would simplify that code a lot.
If those same drivers implement pm functions, I don't see a problem
using devm_ functions in those. Sure, execution complexity is a bit
higher, but it is not as if pm functions are high volume calls.
And, after all, the existence of devm_ functions doesn't mean
that they _have_ to be used.

Guenter


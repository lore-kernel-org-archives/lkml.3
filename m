Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588Ab3FFLR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 07:17:59 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:2739 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754034Ab3FFLR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:17:58 -0400
Message-ID: <51B06FE4.7040805@itdev.co.uk>
Date: Thu, 06 Jun 2013 12:17:56 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Subject: Re: [PATCH 10/53] Input: atmel_mxt_ts - Add memory access interface
 via sysfs
References: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk> <7380889.l4hHqCT0mm@dtor-d630.eng.vmware.com> <51AF8730.4010507@itdev.co.uk> <1717403.GgHsbyUkDZ@dtor-d630.eng.vmware.com> <51AFA02B.3000604@itdev.co.uk> <20130605210715.GA16013@core.coreip.homeip.net> <51AFAF6D.7050204@itdev.co.uk> <20130606100346.GC1883@sirena.org.uk> <51B0651D.3090902@itdev.co.uk> <20130606105530.GT31367@sirena.org.uk>
In-Reply-To: <20130606105530.GT31367@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Thu, Jun 06, 2013 at 11:31:57AM +0100, Nick Dyer wrote:
>> Having to define every parameter in each object (there are thousands) in
>> the kernel driver would be impractically technically, since it would result
>> in a huge, and constantly updating API, which would be always out-of-date,
>> and impossible to support.
> 
>> Also, I'm afraid it would also be impractical legally, since it would
>> breach the NDA terms that Atmel require on these parameter definitions.
> 
> If that's a big problem just put the data table in a section of the
> firmware (or a separate file that gets requested as a firmware).  Or
> have the firmware be able to enumerate itself when asked.

That still would breach the NDA, I'm afraid. And there's hundreds of
existing versions of maXTouch chips already out there which don't have the
infrastructure in place to do what you describe.

>> It works very well in practice. This same abstraction is used across
>> maXTouch products on many platforms to provide tool support. I agree that
>> its use should be restricted to system programs.
> 
> It works well so long as people use the supplied binaries in the way
> that's been proscribed.  As soon as people start upgrading kernels,
> customising things out of your expected flow (because they can or
> they're on a tight deadline) things will get more fragile.  This sort of
> stuff is really common, the approaches I'm describing are fairly
> standard solutions.

If we expose every single parameter as a get/set as you suggest, we haven't
added anything that stops a binary of the wrong version doing something
stupid. We've just added a complex API to the same underlying thing, which
gains nothing.

In practice, where there is a risk of the user mucking up their
configuration, the open-source user-space tools that we have released
provide an easy way to back up and restore the configuration in use, and
the kernel driver provides a way to load a known good configuration on
probe. The same configuration formats and tools are used across maXTouch
products on many platforms.

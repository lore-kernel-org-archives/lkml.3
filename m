Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbbAYXdb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 18:33:31 -0500
Received: from mo2.mail-out.ovh.net ([178.32.228.2]:33722 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbbAYXd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 18:33:29 -0500
X-Greylist: delayed 14426 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Jan 2015 18:33:29 EST
Message-ID: <54C57496.30406@ventoso.org>
Date: Sun, 25 Jan 2015 23:56:22 +0100
From: Luca Olivetti <luca@ventoso.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Fengguag Wu <fengguang.wu@intel.com>,
        =?windows-1252?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH 3.18 105/183] [media] af9005: fix kernel panic on init
 if compiled without IR
References: <20150125180810.160428929@linuxfoundation.org> <20150125180814.764501379@linuxfoundation.org> <54C544EB.3000104@ventoso.org> <20150125220124.GA28946@kroah.com>
In-Reply-To: <20150125220124.GA28946@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 8401465105769400664
X-Ovh-Remote: 85.58.156.44 (44.pool85-58-156.dynamic.orange.es)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejkedrudelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejkedrudelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El 25/01/15 a les 23:01, Greg Kroah-Hartman ha escrit:
> On Sun, Jan 25, 2015 at 08:32:59PM +0100, Luca Olivetti wrote:
>> El 25/01/15 a les 19:07, Greg Kroah-Hartman ha escrit:
>>> 3.18-stable review patch.  If anyone has any objections, please let me know.
>>
>> I don't have any objection apart from the description: IIRC the bug is
>> triggered only if the kernel is compiled without module support.
>> In any case I think that symbol_request should return NULL if the
>> requested symbol is not available, either because the kernel has been
>> compiled without module support or the required symbol is not provided
>> by any module (though I think in the latter case it already works this
>> way, at least it did at the time I wrote the driver).
>> Or, as I said here
>> https://lkml.org/lkml/2009/2/4/350
>> maybe symbol_request isn't the correct approach to provide multiple,
>> alternative, implementations.
> 
> The description is identical to what is in Linus's tree, so there's not
> much I can do about it at this late point in time, sorry.

I'm OK with that, but will somebody look at/clarify the behavior of
symbol_request when modules are disabled?

Bye
-- 
Luca


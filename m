Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759515Ab3EOP6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 11:58:41 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:54555 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759030Ab3EOP6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 11:58:39 -0400
Message-ID: <5193B0CB.9080608@suse.cz>
Date: Wed, 15 May 2013 17:59:07 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        jirislaby@gmail.com
CC: linux-kernel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 13/15] chipidea: Allow user to select PCI/IMX options
References: <1367936303-13386-1-git-send-email-jslaby@suse.cz> <1367936303-13386-13-git-send-email-jslaby@suse.cz> <87k3n9n8ln.fsf@ashishki-desk.ger.corp.intel.com>
In-Reply-To: <87k3n9n8ln.fsf@ashishki-desk.ger.corp.intel.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 11:07 AM, Alexander Shishkin wrote:
> Jiri Slaby <jslaby@suse.cz> writes:
> 
>> From: Jeff Mahoney <jeffm@suse.com>
>>
>> The chipidea driver currently has needless ifneq rules in the makefile
>> for things that should be config options.
> 
> Please elaborate on the "should be" part.
> 
>> This can be problematic,
>> especially in the IMX case, since the OF_DEVICE dependency will be met
>> on powerpc systems - which don't actually support the hardware via that
>> method.
> 
> That's all right, but these things should still compile on powerpc and
> get more compilation testing like that. On the other hand, if the
> compilation does break, we're probably looking at a bug in ci13xxx_imx,
> which needs fixing.
> 
>> This patch adds _PCI and _IMX config options to allow the user to
>> select whether to build the modules.
> 
> I would really like to avoid unnecessary config options in the chipidea
> driver, so my question is: is there a real bug or compilation breakage
> that is triggered in the current state of things?
> 
>> +config USB_CHIPIDEA_PCI
>> +	bool "ChipIdea PCI support"
>> +	depends on PCI
>> +	help
>> +	  This option enables ChipIdea support on PCI.
> 
> I totally don't understand this: we have CONFIG_USB_CHIPIDEA and
> CONFIG_PCI, which already enable chipidea support on PCI. This helps in
> the case when you have both options enabled, but still don't want the
> ci13xxx_pci module to be built, but it doesn't justify an extra option.

Hi, the whole point of the patch is that there is no reason in building
the imx part of the driver on powerpc, because ppc will never provide
that of_device. So we are adding that option and disable that in suse
completely by this patch plus a config option.

The PCI case is not necessarily needed, but follows the IMX case.

thanks,
-- 
js
suse labs

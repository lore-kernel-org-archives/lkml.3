Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672AbaJaWIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 18:08:53 -0400
Received: from smtp105.iad3a.emailsrvr.com ([173.203.187.105]:40273 "EHLO
	smtp105.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932270AbaJaWIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 18:08:51 -0400
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <5454086D.6000401@mev.co.uk>
Date: Fri, 31 Oct 2014 22:08:45 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.1.2
MIME-Version: 1.0
To: Hartley Sweeten <HartleyS@visionengravers.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] staging: comedi: split bus support into separate
 modules
References: <1414777659-25578-1-git-send-email-abbotti@mev.co.uk> <DC148C5AA1CEBA4E87973D432B1C2D882601ABA4@P3PWEX4MB008.ex4.secureserver.net>
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D882601ABA4@P3PWEX4MB008.ex4.secureserver.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/10/14 18:19, Hartley Sweeten wrote:
> On Friday, October 31, 2014 10:48 AM, Ian Abbott wrote:
>> The Comedi core module doesn't need support for PCI, USB or PCMCIA.
>> Only the low-level Comedi drivers need it.  Split the support for these
>> bus types out of the core "comedi" module and into new modules,
>> "comedi_pci", "comedi_usb", and "comedi_pcmcia".
>>
>> 1) staging: comedi: comedidev.h: remove dummy PCI support functions
>> 2) staging: comedi: comedidev.h: remove some #ifdefs
>> 3) staging: comedi: split out PCMCIA support into new module
>> 4) staging: comedi: split out USB support into new module
>> 5) staging: comedi: split out PCI support into new module
>
> Ian,
>
> Is this really necessary?
>
> The pci, usb, and pcmcia support is already conditionally compiled in.
> The support does get added to the main comedi module instead of
> as separate modules but that shouldn't be a problem.

Well a lot of potentially unused module space could get pulled in if 
using a stock distro kernel. For example, the USB dependencies amount to 
over 200k. Not so bad for the others, especially PCI where the code is 
built in anyway.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-

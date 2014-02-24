Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbaBXJvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 04:51:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53186 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbaBXJvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 04:51:43 -0500
Message-ID: <530B162D.40203@suse.de>
Date: Mon, 24 Feb 2014 10:51:41 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>, Ray Strode <halfline@gmail.com>
CC: Josh Boyer <jwboyer@fedoraproject.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Werner Fink <werner@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lennart Poettering <lennart@poettering.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>, Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH 3.13 35/99] tty: Set correct tty name in active sysfs
 attribute
References: <20140220235118.191692546@linuxfoundation.org>	<20140220235119.236520201@linuxfoundation.org>	<CA+5PVA55O2GwUE8oMHShgKgQPA89z5RTbn6yCvOPBMGsf70kBw@mail.gmail.com>	<20140221202127.GA28780@kroah.com>	<CAA_UwzLWGUpQghswiAjo2Ppw0tr3voNPPhekGoHiLTX9MDV3fw@mail.gmail.com>	<5308BF5A.3040706@suse.de>	<CANq1E4Q=9un+ZSy7uUEJPHgqCRKbLOw+PXR+jWxPSKrDLz7N=g@mail.gmail.com>	<CAA_UwzKrqBw3o3z4LGkYfQ3H11ERKQCscdHNSjkVgHs9F117ow@mail.gmail.com> <CANq1E4Ts4fMFqd-YZE1Vqbju3MATsY_Vrs+Ye4i=P=QsDrdYtw@mail.gmail.com>
In-Reply-To: <CANq1E4Ts4fMFqd-YZE1Vqbju3MATsY_Vrs+Ye4i=P=QsDrdYtw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2014 04:05 PM, David Herrmann wrote:
> Hi
> 
> On Sun, Feb 23, 2014 at 1:20 AM, Ray Strode <halfline@gmail.com> wrote:
>> Hi,
>>
>>
>> On Feb 22, 2014 9:27 AM, "David Herrmann" <dh.herrmann@gmail.com> wrote:
>>> How about this:
>>>
>>> +               driver = cs[i]->device(cs[i], &index);
>>> +                /* special case for tty0 which must not be resolved */
>>> +               if (driver && (index > 0 || cs[i]->major != TTY_MAJOR)) {
>>> +                       count += tty_line_name(driver, index, buf +
>>> count);
>>> +                       count += sprintf(buf + count, "%c", i ? ' ':'\n');
>>> +               } else
>>> +                       count += sprintf(buf + count, "%s%d%c",
>>> +                                        name, index, i ? ' ':'\n');
>>
>> Assuming I'm reading the code correctly, I don't think that will work.
>> Index will be rewritten from 0 to fg_console (which I suppose is going to be
>> 1) after the device vfunc is called.
> 
> Oh, nice catch. We have to use cs[i]->index of course. I only
> hand-edited the patch, I didn't even compile-test. But I guess you get
> the idea of special-casing tty0.
> 
Okay, that's a good idea.

I'll be redoing the patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342AbaBWPF1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 10:05:27 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:63773 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaBWPFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 10:05:25 -0500
MIME-Version: 1.0
In-Reply-To: <CAA_UwzKrqBw3o3z4LGkYfQ3H11ERKQCscdHNSjkVgHs9F117ow@mail.gmail.com>
References: <20140220235118.191692546@linuxfoundation.org>
	<20140220235119.236520201@linuxfoundation.org>
	<CA+5PVA55O2GwUE8oMHShgKgQPA89z5RTbn6yCvOPBMGsf70kBw@mail.gmail.com>
	<20140221202127.GA28780@kroah.com>
	<CAA_UwzLWGUpQghswiAjo2Ppw0tr3voNPPhekGoHiLTX9MDV3fw@mail.gmail.com>
	<5308BF5A.3040706@suse.de>
	<CANq1E4Q=9un+ZSy7uUEJPHgqCRKbLOw+PXR+jWxPSKrDLz7N=g@mail.gmail.com>
	<CAA_UwzKrqBw3o3z4LGkYfQ3H11ERKQCscdHNSjkVgHs9F117ow@mail.gmail.com>
Date: Sun, 23 Feb 2014 16:05:25 +0100
Message-ID: <CANq1E4Ts4fMFqd-YZE1Vqbju3MATsY_Vrs+Ye4i=P=QsDrdYtw@mail.gmail.com>
Subject: Re: [PATCH 3.13 35/99] tty: Set correct tty name in active sysfs attribute
From: David Herrmann <dh.herrmann@gmail.com>
To: Ray Strode <halfline@gmail.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>, Werner Fink <werner@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lennart Poettering <lennart@poettering.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>, Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sun, Feb 23, 2014 at 1:20 AM, Ray Strode <halfline@gmail.com> wrote:
> Hi,
>
>
> On Feb 22, 2014 9:27 AM, "David Herrmann" <dh.herrmann@gmail.com> wrote:
>> How about this:
>>
>> +               driver = cs[i]->device(cs[i], &index);
>> +                /* special case for tty0 which must not be resolved */
>> +               if (driver && (index > 0 || cs[i]->major != TTY_MAJOR)) {
>> +                       count += tty_line_name(driver, index, buf +
>> count);
>> +                       count += sprintf(buf + count, "%c", i ? ' ':'\n');
>> +               } else
>> +                       count += sprintf(buf + count, "%s%d%c",
>> +                                        name, index, i ? ' ':'\n');
>
> Assuming I'm reading the code correctly, I don't think that will work.
> Index will be rewritten from 0 to fg_console (which I suppose is going to be
> 1) after the device vfunc is called.

Oh, nice catch. We have to use cs[i]->index of course. I only
hand-edited the patch, I didn't even compile-test. But I guess you get
the idea of special-casing tty0.

Thanks
David

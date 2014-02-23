Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaBWAYE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 19:24:04 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:64363 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaBWAYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 19:24:03 -0500
MIME-Version: 1.0
In-Reply-To: <CANq1E4Q=9un+ZSy7uUEJPHgqCRKbLOw+PXR+jWxPSKrDLz7N=g@mail.gmail.com>
References: <20140220235118.191692546@linuxfoundation.org> <20140220235119.236520201@linuxfoundation.org>
 <CA+5PVA55O2GwUE8oMHShgKgQPA89z5RTbn6yCvOPBMGsf70kBw@mail.gmail.com>
 <20140221202127.GA28780@kroah.com> <CAA_UwzLWGUpQghswiAjo2Ppw0tr3voNPPhekGoHiLTX9MDV3fw@mail.gmail.com>
 <5308BF5A.3040706@suse.de> <CANq1E4Q=9un+ZSy7uUEJPHgqCRKbLOw+PXR+jWxPSKrDLz7N=g@mail.gmail.com>
From: Ray Strode <halfline@gmail.com>
Date: Sat, 22 Feb 2014 19:23:42 -0500
Message-ID: <CAA_UwzLkcQSGUUNA_stAcmD-6DFVTZLvE6AoUzvO5iq0ALSSOQ@mail.gmail.com>
Subject: Re: [PATCH 3.13 35/99] tty: Set correct tty name in active sysfs attribute
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Hannes Reinecke <hare@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay@vrfy.org>, Jiri Slaby <jslaby@suse.cz>,
        Werner Fink <werner@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(resending because my phone tried to send the reply as html mail and
it got rejected)

On Sat, Feb 22, 2014 at 9:27 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
> > How about this:
>
> +               driver = cs[i]->device(cs[i], &index);
> +                /* special case for tty0 which must not be resolved */
> +               if (driver && (index > 0 || cs[i]->major != TTY_MAJOR)) {
> +                       count += tty_line_name(driver, index, buf + count);
> +                       count += sprintf(buf + count, "%c", i ? ' ':'\n');
> +               } else
> +                       count += sprintf(buf + count, "%s%d%c",
> +                                        name, index, i ? ' ':'\n');
Assuming I'm reading the code correctly, I don't think that will work.
 Index will be rewritten from 0 to fg_console (which I suppose is
going to be 1) after the device vfunc is called.

--Ray

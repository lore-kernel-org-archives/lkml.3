Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbaBVNNx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 08:13:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33799 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbaBVNNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 08:13:52 -0500
Message-ID: <5308BF5A.3040706@suse.de>
Date: Sat, 22 Feb 2014 16:16:42 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Ray Strode <halfline@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Josh Boyer <jwboyer@fedoraproject.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay@vrfy.org>, Jiri Slaby <jslaby@suse.cz>,
        David Herrmann <dh.herrmann@gmail.com>, Werner Fink <werner@suse.de>
Subject: Re: [PATCH 3.13 35/99] tty: Set correct tty name in active sysfs
 attribute
References: <20140220235118.191692546@linuxfoundation.org> <20140220235119.236520201@linuxfoundation.org> <CA+5PVA55O2GwUE8oMHShgKgQPA89z5RTbn6yCvOPBMGsf70kBw@mail.gmail.com> <20140221202127.GA28780@kroah.com> <CAA_UwzLWGUpQghswiAjo2Ppw0tr3voNPPhekGoHiLTX9MDV3fw@mail.gmail.com>
In-Reply-To: <CAA_UwzLWGUpQghswiAjo2Ppw0tr3voNPPhekGoHiLTX9MDV3fw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2014 11:18 PM, Ray Strode wrote:
> Hi,
>
> On Fri, Feb 21, 2014 at 3:21 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> Ray, Josh, can I get some more information about this?  Is this broken
>> in Linus's tree?  Or did I get the backport wrong here?
> I don't think it's a problem with the backport specifically. To be
> honest, i'm not even 100% sure it is that patch. It was just the only
> patch that touched that code recently so it seemed likely.  I didn't
> do builds to check for sure.
>
>> What is the value of the file before and after this patch?
> "tty0" in the past and "tty1" now
>
>> And what is plymouth doing with this file value, it was incorrect
>> before, what was it using the value for?
> See the other (3.11) thread for my initial message, but basically
> plymouth had code something like this pseudocode:
>
> /* disable splash if there are serial consoles */
> if (!contents_of_file_equals("/sys/class/tty/console/active", "tty0")) {
>          disable_splash_and_force_verbose_messages();
> }
>
> since the file started saying tty1 that code started disabling the
> splash for everyone in rawhide.
>
<sigh>

And of course, checking for "!tty0" is the proper check for serial console.
Which, of course, means we have to stay with a broken kernel interface 
for ever and ever.

Innovation, here we come.

</sigh>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)

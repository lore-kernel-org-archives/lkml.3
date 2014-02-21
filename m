Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663AbaBUOwr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 09:52:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50464 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754625AbaBUOwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 09:52:46 -0500
Message-ID: <5307683C.50209@suse.de>
Date: Fri, 21 Feb 2014 15:52:44 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Josh Boyer <jwboyer@fedoraproject.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay@vrfy.org>, Jiri Slaby <jslaby@suse.cz>,
        David Herrmann <dh.herrmann@gmail.com>, Werner Fink <werner@suse.de>,
        Ray Strode <halfline@gmail.com>
Subject: Re: [PATCH 3.13 35/99] tty: Set correct tty name in active sysfs
 attribute
References: <20140220235118.191692546@linuxfoundation.org>	<20140220235119.236520201@linuxfoundation.org> <CA+5PVA55O2GwUE8oMHShgKgQPA89z5RTbn6yCvOPBMGsf70kBw@mail.gmail.com>
In-Reply-To: <CA+5PVA55O2GwUE8oMHShgKgQPA89z5RTbn6yCvOPBMGsf70kBw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2014 03:48 PM, Josh Boyer wrote:
> On Thu, Feb 20, 2014 at 6:52 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> 3.13-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Hannes Reinecke <hare@suse.de>
>>
>> commit d8a5dc3033af2fd6d16030d2ee4fbd073460fe54 upstream.
>>
>> The 'active' sysfs attribute should refer to the currently active tty
>> devices the console is running on, not the currently active console.
>>
>> The console structure doesn't refer to any device in sysfs, only the tty
>> the console is running on has.  So we need to print out the tty names in
>> 'active', not the console names.
>>
>> This resolves an issue on s390 platforms in determining the correct
>> console device to use.
> 
> Just to be double sure this is seen, Ray points out that it breaks
> current plymouth because the heuristic changed.  Hold off on this one?
> 
Without this patch systemd won't present a login console for s390.
I'd prefer fixing plymouth.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)

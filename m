Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbaBUO4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 09:56:52 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:51750 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755667AbaBUO4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 09:56:49 -0500
Message-ID: <5307692B.4070005@hurleysoftware.com>
Date: Fri, 21 Feb 2014 09:56:43 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Hannes Reinecke <hare@suse.de>, Josh Boyer <jwboyer@fedoraproject.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay@vrfy.org>, Jiri Slaby <jslaby@suse.cz>,
        David Herrmann <dh.herrmann@gmail.com>, Werner Fink <werner@suse.de>,
        Ray Strode <halfline@gmail.com>
Subject: Re: [PATCH 3.13 35/99] tty: Set correct tty name in active sysfs
 attribute
References: <20140220235118.191692546@linuxfoundation.org>	<20140220235119.236520201@linuxfoundation.org> <CA+5PVA55O2GwUE8oMHShgKgQPA89z5RTbn6yCvOPBMGsf70kBw@mail.gmail.com> <5307683C.50209@suse.de>
In-Reply-To: <5307683C.50209@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2014 09:52 AM, Hannes Reinecke wrote:
> On 02/21/2014 03:48 PM, Josh Boyer wrote:
>> On Thu, Feb 20, 2014 at 6:52 PM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>>> 3.13-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: Hannes Reinecke <hare@suse.de>
>>>
>>> commit d8a5dc3033af2fd6d16030d2ee4fbd073460fe54 upstream.
>>>
>>> The 'active' sysfs attribute should refer to the currently active tty
>>> devices the console is running on, not the currently active console.
>>>
>>> The console structure doesn't refer to any device in sysfs, only the tty
>>> the console is running on has.  So we need to print out the tty names in
>>> 'active', not the console names.
>>>
>>> This resolves an issue on s390 platforms in determining the correct
>>> console device to use.
>>
>> Just to be double sure this is seen, Ray points out that it breaks
>> current plymouth because the heuristic changed.  Hold off on this one?
>>
> Without this patch systemd won't present a login console for s390.
> I'd prefer fixing plymouth.

Not an option.

As I said before, the old interface should be left alone and
forked to present a new interface that systemd can use to
get what it expects.

Regards,
Peter Hurley


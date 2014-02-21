Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbaBUO4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 09:56:38 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:61947 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062AbaBUO4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 09:56:36 -0500
MIME-Version: 1.0
In-Reply-To: <5307683C.50209@suse.de>
References: <20140220235118.191692546@linuxfoundation.org>
	<20140220235119.236520201@linuxfoundation.org>
	<CA+5PVA55O2GwUE8oMHShgKgQPA89z5RTbn6yCvOPBMGsf70kBw@mail.gmail.com>
	<5307683C.50209@suse.de>
Date: Fri, 21 Feb 2014 09:56:35 -0500
X-Google-Sender-Auth: 5TEOLl3_p4FwCF7kfrQ7375bK8Y
Message-ID: <CA+5PVA5W=t9+OmZXZuJT-1EsZXmTUBrX4eHjJcmQg676SOjSng@mail.gmail.com>
Subject: Re: [PATCH 3.13 35/99] tty: Set correct tty name in active sysfs attribute
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay@vrfy.org>, Jiri Slaby <jslaby@suse.cz>,
        David Herrmann <dh.herrmann@gmail.com>, Werner Fink <werner@suse.de>,
        Ray Strode <halfline@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 9:52 AM, Hannes Reinecke <hare@suse.de> wrote:
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

Sure.  Except fixing plymouth is easy to do, but not easy to actually
get deployed on all of the old userspace.  So if someone runs a 3.14
kernel on any distro that doesn't have a fixed plymouth, it's broken.
By including this patch, you're basically trading one broken userspace
component for another.

Is there some other way this could be fixed in-kernel that would allow
both to work?

josh

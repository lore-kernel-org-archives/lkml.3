Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbbAGQ5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 11:57:34 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:35107 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbbAGQ5d convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:10:1>);
	Wed, 7 Jan 2015 11:57:33 -0500
Message-Id: <54AD7387020000780005271C@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Wed, 07 Jan 2015 16:57:27 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Ian Campbell" <Ian.Campbell@citrix.com>,
        "Imre Palik" <imrep.amz@gmail.com>
Cc: "Anthony Liguori" <aliguori@amazon.com>, "Imre Palik" <imrep@amazon.de>,
        "David Vrabel" <david.vrabel@citrix.com>, <x86@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        <xen-devel@lists.xenproject.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        "Ingo Molnar" <mingo@redhat.com>, <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH RFC] xen-time: decreasing the rating of
 the xen clocksource below that of the tsc clocksource for dom0's
References: <1420647398-20207-1-git-send-email-imrep.amz@gmail.com>
 <1420648234.18631.117.camel@citrix.com>
In-Reply-To: <1420648234.18631.117.camel@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 07.01.15 at 17:30, <Ian.Campbell@citrix.com> wrote:
> On Wed, 2015-01-07 at 17:16 +0100, Imre Palik wrote:
>> From: "Palik, Imre" <imrep@amazon.de>
>> 
>> In Dom0's the use of the TSC clocksource (whenever it is stable enough to
>> be used) instead of the Xen clocksource should not cause any issues, as
>> Dom0 VMs never live-migrated.
> 
> Is this still true given that dom0's vcpus are migrated amongst pcpus on
> the host? The tsc are not synchronised on some generations of hardware
> so the result there would be the TSC appearing to do very odd things
> under dom0's feet. Does Linux cope with that or does it not matter for
> some other reason?

Indeed. The textual qualification above ("whenever it is stable enough")
isn't being expressed in the code change at all.

Jan


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaDCNeq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 09:34:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:58927 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbaDCNeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 09:34:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-acpi@lists.linaro.org
Cc: "mika.westerberg@linux.intel.com" <mika.westerberg@linux.intel.com>,
        "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Linaro-acpi] How to pass I2C platform_data under ACPI
Date: Thu, 03 Apr 2014 15:34:30 +0200
Message-ID: <4539649.rsMWK1FkZ6@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140403113832.GD19349@intel.com>
References: <D854C92F57B1B347B57E531E78D05EAD57463568@BGSMSX104.gar.corp.intel.com> <D854C92F57B1B347B57E531E78D05EAD57463D21@BGSMSX104.gar.corp.intel.com> <20140403113832.GD19349@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:nsn691JhfQVvtO6fSqiv2Uv3ag63fwXtEzG1U6mRSQO
 9PTLy9ESaHybmW9GmgS8BNyg7NS6pHN/0PTAD+ht10OiK+oNQw
 jNolg0vjSfuOJjeI0f0KsG2l0p9hrPNEkNpEnKyvJh/LxvAMsr
 Sppo00oK+iGsLLEJhmrxycFMEh1hdbfuN8m7K4KJayGRjvfk3b
 Teh1h4w6q8RcNHWQNFkMIxGO3GsGnVtQVcFeXpJ8fkhX48qPEn
 nIy7kkQHgSGLBLXHtvzX62gpNTW2eSTHrLUHVjj1OypQCu+wDq
 h4ENDaaUY9IK10n+1Q5ds2eINTctiXrYW9R7r35jlThvu4NSwI
 zYfDQgNfvW7s4+UuEXM4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 April 2014 14:38:33 mika.westerberg@linux.intel.com wrote:
> On Thu, Apr 03, 2014 at 11:25:34AM +0000, Pallala, Ramakrishna wrote:
> > >> In non ACPI environment I used to initialize the platform_data under 
> > >> board or platforms files. Under ACPI how do I do that?
> > >
> > >If you can't extract that information from ACPI namespace, then one option is to pass platform data along with the device ACPI ID:
> > >
> > >static const struct acpi_device_id my_acpi_match[] = {
> > >     { "MYID0001", (kernel_ulong_t)&my_platform_data }
> > >     ...
> > >     { },
> > >};
> > 
> > Thanks for the Quick reply.
> > 
> > So If I  want to use different platform_data for different boards can I
> > do something like below?
> 
> Exactly.
> 
> > And initialize the platform data in either driver or in separate module
> > which gets compiled along with driver?
> 
> Typically it has been done in the same driver but I don't see any problems
> having a separate module as well.
> 
> > static const struct acpi_device_id my_acpi_match[] = {
> >       { "MYID0001", (kernel_ulong_t)&my_platform_data1 }
> >       { "MYID0002", (kernel_ulong_t)&my_platform_data2 }
> >       ...
> >       { },

We definitely don't want per-board match entries, that does not scale.
The driver should be reasonably generic and get all the necessary data
out of well-defined tables. You can have different IDs when there
are only a few cases that are actually relevant, but it has to be
conceivable that the same driver get used on future hardware without
changes.

	Arnd

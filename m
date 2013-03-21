Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab3CUIAg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 04:00:36 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:33074 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228Ab3CUIAf convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:2:1>);
	Thu, 21 Mar 2013 04:00:35 -0400
Message-Id: <514ACC3B02000078000C765B@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Thu, 21 Mar 2013 08:00:43 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Shawn Starr" <shawn.starr@rogers.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [Intel][RNG] PCI IDs commented out for 82801I (ICH9 Mobile
 and non-mobile)?
References: <1597390.RUFC41Uyje@segfault.sh0n.net>
 <514A2195.9060402@zytor.com>
In-Reply-To: <514A2195.9060402@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 20.03.13 at 21:52, "H. Peter Anvin" <hpa@zytor.com> wrote:
> On 03/20/2013 01:42 PM, Shawn Starr wrote:
>> Hello folks,
>> 
>> I was looking at why I can't load the Intel RNG driver (or why it doesn't 
> load automatically) and 
>> it just so happens I have both the mobile and non-mobile ICH9 chipset. 
> Looking at the driver I noticed:
>> 
>>  /* BAM, CAM, DBM, FBM, GxM
>>        { PCI_DEVICE(0x8086, 0x2448) }, */
>>  
>>  /* BA, CA, DB, Ex, 6300, Fx, 631x/632x, Gx
>>        { PCI_DEVICE(0x8086, 0x244e) }, */
>> 
>> IDs from both machines:
>>  
>> 00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge 
> [8086:2448] (rev 93)
>> 00:1e.0 PCI bridge [0604]: Intel Corporation 82801 PCI Bridge [8086:244e] 
> (rev 92)
>>  
>> I saw a thread from 2006 explaining the 50% chance there's no RNG (but these 
> days all modern chipsets should have an RNG) and I know 
>> this chipset I have does have an RNG so I'd like to use the HW random 
> generator vs software.
>> 
> 
> Do you know that for sure?

I haven't seen _any_ half way recent system having this old style
FWH.

>> Do we need to revisit this? Even if I try to force it to load it still fails:
>> 
>> # modprobe intel_rng no_fwh_detect=-1 or =1 
>> modprobe: ERROR: could not insert 'intel_rng': No such device
>> 
> 
> The Intel RNG of that era lived in the Firmware Hub (a.k.a. BIOS flash)
> rather than in the chipset proper... so even with the right chipset you
> might or might not actually have the the RNG.  The code really detects
> the presence of a chipset which could support a FWH flash part.
> 
> Jan, in c24c95a085c6b52c11c2f5afecc38b0ca143cdae you comment out a
> number of PCI IDs.  Was that intentional?

Yes, as explained in the description (albeit, reading it now, 6.5
years later, again, I admit it could have been written in better
ways): Before that change, the selection of which particular
device from a chipset was chose was more or less random. But
with the new code now actually accessing the device, it has to be
the LPC one. And the list of devices stops at ICH7 - that was,
afaict now, the newest one in existence back then. Therefore, if
there really are newer chipsets with FWH, the code would need
auditing for correctness when intending to add further PCI IDs.

Jan


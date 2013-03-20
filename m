Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab3CTUwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 16:52:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50739 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab3CTUwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 16:52:50 -0400
Message-ID: <514A2195.9060402@zytor.com>
Date: Wed, 20 Mar 2013 13:52:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Shawn Starr <shawn.starr@rogers.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [Intel][RNG] PCI IDs commented out for 82801I (ICH9 Mobile and
 non-mobile)?
References: <1597390.RUFC41Uyje@segfault.sh0n.net>
In-Reply-To: <1597390.RUFC41Uyje@segfault.sh0n.net>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 01:42 PM, Shawn Starr wrote:
> Hello folks,
> 
> I was looking at why I can't load the Intel RNG driver (or why it doesn't load automatically) and 
> it just so happens I have both the mobile and non-mobile ICH9 chipset. Looking at the driver I noticed:
> 
>  /* BAM, CAM, DBM, FBM, GxM
>        { PCI_DEVICE(0x8086, 0x2448) }, */
>  
>  /* BA, CA, DB, Ex, 6300, Fx, 631x/632x, Gx
>        { PCI_DEVICE(0x8086, 0x244e) }, */
> 
> IDs from both machines:
>  
> 00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge [8086:2448] (rev 93)
> 00:1e.0 PCI bridge [0604]: Intel Corporation 82801 PCI Bridge [8086:244e] (rev 92)
>  
> I saw a thread from 2006 explaining the 50% chance there's no RNG (but these days all modern chipsets should have an RNG) and I know 
> this chipset I have does have an RNG so I'd like to use the HW random generator vs software.
> 

Do you know that for sure?

> Do we need to revisit this? Even if I try to force it to load it still fails:
> 
> # modprobe intel_rng no_fwh_detect=-1 or =1 
> modprobe: ERROR: could not insert 'intel_rng': No such device
> 

The Intel RNG of that era lived in the Firmware Hub (a.k.a. BIOS flash)
rather than in the chipset proper... so even with the right chipset you
might or might not actually have the the RNG.  The code really detects
the presence of a chipset which could support a FWH flash part.

Jan, in c24c95a085c6b52c11c2f5afecc38b0ca143cdae you comment out a
number of PCI IDs.  Was that intentional?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


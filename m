Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab3IWLuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 07:50:00 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:6727 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab3IWLt6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 07:49:58 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 23 Sep 2013 04:49:58 -0700
From: Manoj Chourasia <mchourasia@nvidia.com>
To: Peter Wu <lekensteyn@gmail.com>, Jiri Kosina <jkosina@suse.cz>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 23 Sep 2013 17:19:58 +0530
Subject: RE: [PATCH] hidraw: correctly deallocate memory on device disconnect
Thread-Topic: [PATCH] hidraw: correctly deallocate memory on device
 disconnect
Thread-Index: Ac6dr4eYxkZARg7JRwqzhqat90mdewanENBw
Message-ID: <F1F6C959961EA744BBD5B8EEF8B8FEA16DDCBD9FFF@BGMAIL02.nvidia.com>
References: <F17EA9D408D3644C864D33B8F5E1CC526DAC2ACF47@BGMAIL02.nvidia.com>
 <alpine.LNX.2.00.1308091130420.13089@pobox.suse.cz> <1707995.vN5QlUzrT9@al>
In-Reply-To: <1707995.vN5QlUzrT9@al>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

What is the final proposed fix for this issue?

Thanks
-Manoj


-----Original Message-----
From: Peter Wu [mailto:lekensteyn@gmail.com] 
Sent: Tuesday, August 20, 2013 7:44 PM
To: Jiri Kosina
Cc: Manoj Chourasia; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hidraw: correctly deallocate memory on device disconnect

On Friday 09 August 2013 11:31:15 Jiri Kosina wrote:
> On Mon, 22 Jul 2013, Manoj Chourasia wrote:
> > This is mail is in regard to your commit for hidaw devices. We were 
> > seeing kernel crashes while connect and disconnect a hidraw device 
> > and we were hitting rb tree corruption in vmalloc and kernel was 
> > crashing because of null pointer de-reference. Later we figure out 
> > that was because the hid device disconnect is freeing memory which 
> > later got access by hidraw_read and hid_write.
> 
> Now applied, thanks Manoj, thanks Peter.

I just noticed an issue with this patch, after playing with some receivers I saw 8 hidraw device nodes. Every USB receiver creates two hidraw nodes, one for the receiver and one for the paired device.

UPower seems to keep the file descriptor open which prevents the hidraw device from being removed. Shouldn't the implementation of hidraw be changed to separate open file descriptors from the actual HID devices? That should allow /dev/hidrawX devices to get removed whenever a HID device is gone.

Regards,
Peter

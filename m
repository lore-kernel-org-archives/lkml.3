Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab3F1UIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 16:08:39 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:60347 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab3F1UIi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 16:08:38 -0400
X-RZG-AUTH: :OmsBZ2C7d7IBoB6EHwegNiNxh/xpjMmBYR0YjlTttojRtSoTz+HSISzrOA==
X-RZG-CLASS-ID: mo05
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Subject: Re: udevd cannot modprobe snd-hda-intel with 3.9.8
Date: Fri, 28 Jun 2013 22:08:20 +0200
User-Agent: KMail/1.13.7 (Linux/3.10-rc7-aptosid-686; KDE/4.8.4; i686; ; )
Cc: Takashi Iwai <tiwai@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Henningsson <david.henningsson@canonical.com>,
        Kay Sievers <kay@redhat.com>
References: <51CDD1B0.70607@gmail.com>
In-Reply-To: <51CDD1B0.70607@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201306282208.23429.s.L-H@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Friday 28 June 2013, Riccardo Magliocchetti wrote:
> Hello,
> 
> at boot udev (175-7.2 from debian unstable) blocks for maybe 30 seconds 
> and then gives (handcopied)
> 
>   timeout: killing '/sbin/modprobe -b 
> pci:v00008086d0000293Esv0000144Dsd0000C045bc04sc03i00'
> 
> when booting 3.9.8. 3.8.13 has the same issue, 3.6.0 is fine.
[…]

I think oss-compat might interfere here. Given that it was recently 
(2013-06-18) updated, this would explain why only new'ish kernels are 
affected (initramfs not updated for the older ones). Therefore I'd 
suggest to purge oss-compat (simple removal is not sufficient, as the 
modprobe.d/ snippets are dpkg conffiles) for testing - and to file a 
bug[1] against the new version of oss-compat, if you can confirm it 
to be responsible.

Regards
	Stefan Lippers-Hollmann

[1]	http://www.debian.org/Bugs/Reporting

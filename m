Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab3CFUmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 15:42:00 -0500
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:38223 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab3CFUl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 15:41:59 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhF1AIipN1FV5qjOPGdsb2JhbABEh14BhH23WAMBgVwXAwEBAQE4NIIsAQU6HBMBDxAIAyElDwUlChoTiBe8KhWNdoEBB4JfYQOWSoYIjXM
X-IronPort-AV: E=Sophos;i="4.84,798,1355094000"; 
   d="scan'208";a="291552628"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 6 Mar 2013 21:45:00 +0100
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.9-rc1
Message-ID: <20130306204500.GA335@polaris.bitmath.org>
References: <CA+55aFx0HcOXKpxmZzM5jcbAaOroxafomX5ggMFV4A=py1qh-Q@mail.gmail.com>
 <20130306080642.GA535@polaris.bitmath.org>
 <51370990.5040508@linux.intel.com>
 <20130306100743.GA407@polaris.bitmath.org>
 <CAE9FiQXT4O3GOzm_OoFJG=vc=5LpfBkTEbAO_3xjerBGS_Gy=A@mail.gmail.com>
 <20130306193612.GA513@polaris.bitmath.org>
 <51379A4F.4020200@linux.intel.com>
 <20130306195457.GA449@polaris.bitmath.org>
 <CAE9FiQWK0ZnG9o8WgU-pcTPpir=PUyULQqk-TRVC+sh6UpU8VA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQWK0ZnG9o8WgU-pcTPpir=PUyULQqk-TRVC+sh6UpU8VA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> >> Can you check bootloader like grub.efi ?
> >> >
> >> > I checked, same story. I tried without EFI_STUB, no joy. I ran with
> >> > and without nouveau, just in case. Without the patch, everything
> >> > works. With the patch, nothing works, and no output at all.
> >> >
> >> > With a bit of luck, I could maybe get the first lines of output using
> >> > grub.efi, but frankly I cannot remember if that ever worked on this
> >> > machine.
> 
> Found one bug about real_end calculating, it should be PMD_SIZE align.
> Otherwise in extreme case we could have less then 2M for the first step.
> In your case is about only (1M - 32k) for first step.
> 
> Please try attached patch.

Bingo. Excellent, thank you Yinghai. I verified that it also boots on
top of Linus' tree, so you may add

    Tested-by: Henrik Rydberg <rydberg@euromail.se>

to the final result.

Cheers,
Henrik

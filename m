Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760498Ab3DCPXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 11:23:43 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:51206 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758907Ab3DCPXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 11:23:41 -0400
Message-ID: <515C496A.6050809@openwrt.org>
Date: Wed, 03 Apr 2013 17:23:22 +0200
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Eric Whitney <enwlinux@gmail.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        Christian Kujau <lists@nerdbynature.de>, CAI Qian <caiqian@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>, Steve Best <sbest@redhat.com>,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: fix a big-endian bug when an extent is zeroed out
References: <alpine.DEB.2.10.1304012249440.5874@trent.utfs.org> <877gkls1q7.fsf@openvz.org> <alpine.DEB.2.10.1304021430480.13746@trent.utfs.org> <87r4isd1vn.fsf@openvz.org> <alpine.DEB.2.10.1304021611020.13746@trent.utfs.org> <87li90q9mx.fsf@openvz.org> <87hajoq6s2.fsf@openvz.org> <20130403102204.GA15383@gmail.com> <20130403122058.GB7741@thunk.org> <20130403143406.GA3006@wallace> <20130403144114.GB13668@thunk.org>
In-Reply-To: <20130403144114.GB13668@thunk.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Le 04/03/13 16:41, Theodore Ts'o a écrit :
> On Wed, Apr 03, 2013 at 10:34:06AM -0400, Eric Whitney wrote:
>>
>> The TI OMAP4 processor on my Pandaboard test system is little endian.
>
> Ah... so basically, we need to find a test platform which allows us to
> boot arbitrary kernels and allows us to have root access (which means
> it's unlikely we'll be able to do this via remote access) and which
> doesn't have exotic power requirements (which as far as I know rules
> out pSeries and zSeries systems....)
>
> It would also be nice if we could run tests in finite time, which
> probably rules out the Hercules emulator (it runs at one-tenth zSeries
> processor speeds, which doesn't win speed competitions by default, and
> I suspect their storage speeds are even worse).
>
> Anyone else have any suggestions?  Or anyone willing to help us run
> ext4 regression tests on the ext4 dev tree, so we can find these
> problems before we merge into mainline?

Qemu emulates various mainline PowerPC, MIPS and SPARC big-endian 
systems pretty efficiently and it should not be too hard neither to 
script nor to get a recent kernel up and running on these platforms.

My 2 cents.
--
Florian

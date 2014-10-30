Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759651AbaJ3TJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 15:09:35 -0400
Received: from mail-qc0-f193.google.com ([209.85.216.193]:35621 "EHLO
	mail-qc0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbaJ3TJd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 15:09:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAChTCPzJst_O8OSdCAHQWGpn-Zc_j4hkk_Cs5MF2xubcGoC5Fg@mail.gmail.com>
References: <CAChTCPzJst_O8OSdCAHQWGpn-Zc_j4hkk_Cs5MF2xubcGoC5Fg@mail.gmail.com>
Date: Thu, 30 Oct 2014 21:09:33 +0200
Message-ID: <CAChTCPyDEFEOHGhe2r1+RSouBsf3kW4r9XWW9JkxxubUsnasKw@mail.gmail.com>
Subject: Re: [PATCH] x86, kaslr: Prevent .bss from overlaping initrd
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.j.penttila@gmail.com>
To: linux-kernel@vger.kernel.org, fengguang.wu@intel.com,
        eternal.n08@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When choosing a random address, the current implementation does not take into
> account the reversed space for .bss and .brk sections. Thus the relocated kernel
> may overlap other components in memory, e.g. the initrd image:

initrd should be included in the avoid arrays already, and bss is
included in the output_size

for choose_kernel_location(). So something else is going on?

--Mika

On Thu, Oct 30, 2014 at 9:06 PM, Mika Penttilä
<mika.j.penttila@gmail.com> wrote:
>> When choosing a random address, the current implementation does not take
>> into
>> account the reversed space for .bss and .brk sections. Thus the relocated
>> kernel
>> may overlap other components in memory, e.g. the initrd image:
>
> initrd should be included in the avoid arrays already, and bss is included
> in the output_size
>
> for choose_kernel_location(). So something else is going on?
>
> --Mika
>
>

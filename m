Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbaEEUbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 16:31:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56101 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328AbaEEUbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 16:31:21 -0400
Message-ID: <5367F50F.8080909@zytor.com>
Date: Mon, 05 May 2014 13:31:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: x86_64 allyesconfig has screwed up voffset and blows up KVM
References: <CALCETrX+J643i-YPjATo-u6O+_MgZm_v9x-VBp5WmFm-1g0Twg@mail.gmail.com>
In-Reply-To: <CALCETrX+J643i-YPjATo-u6O+_MgZm_v9x-VBp5WmFm-1g0Twg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2014 11:41 AM, Andy Lutomirski wrote:
> I'm testing 39bfe90706ab0f588db7cb4d1c0e6d1181e1d2f9.  I'm not sure
> what's going on here.
> 
> voffset.h contains:
> 
> #define VO__end 0xffffffff8111c7a0
> #define VO__end 0xffffffff8db9a000
> #define VO__text 0xffffffff81000000
> 
> because
> 
> $ nm vmlinux|grep ' _end'
> ffffffff8111c7a0 t _end
> ffffffff8db9a000 B _end
> 

The "t _end" implies there is a local symbol _end which I guess the
scripts are incorrectly picking up.  Taking a look now.

	-hpa



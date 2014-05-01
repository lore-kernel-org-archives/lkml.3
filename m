Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbaEATqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 15:46:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39951 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbaEATqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 15:46:19 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20140501192618.GA25829@thunk.org>
References: <CALCETrXMAWSC6B-irn4LeXFzB2tODqagsBboky=xnGv5ZTh-sg@mail.gmail.com> <20140501192618.GA25829@thunk.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: random: Providing a seed value to VM guests
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 01 May 2014 12:40:35 -0700
To: tytso@mit.edu, Andy Lutomirski <luto@amacapital.net>
CC: Florian Weimer <fweimer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <kees@outflux.net>, kvm list <kvm@vger.kernel.org>
Message-ID: <068139e3-50f8-4d44-972a-0296b6bc36f7@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I said... I think KVM has already added an emulated instructions enumeration API.

On May 1, 2014 12:26:18 PM PDT, tytso@mit.edu wrote:
>On Thu, May 01, 2014 at 12:02:49PM -0700, Andy Lutomirski wrote:
>> 
>> Is RDSEED really reasonable here?  Won't it slow down by several
>> orders of magnitude?
>
>That is I think the biggest problem; RDRAND and RDSEED are fast if
>they are native, but they will involve a VM exit if they need to be
>emulated.  So when an OS might want to use RDRAND and RDSEED might be
>quite different if we know they are being emulated.
>
>Using the RDRAND and RDSEED "api" certainly makes sense, at least for
>x86, but I suspect we might want to use a different way of signalling
>that a VM guest can use RDRAND and RDSEED if they are running on a CPU
>which doesn't provide that kind of access.  Maybe a CPUID extended
>function parameter, if one could be allocated for use by a Linux
>hypervisor?
>
>						- Ted

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.

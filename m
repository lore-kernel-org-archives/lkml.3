Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbaAFVo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 16:44:58 -0500
Received: from ks35366.kimsufi.com ([213.251.186.122]:45106 "EHLO meetr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756390AbaAFVo4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 16:44:56 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: apple_gmux: switcheroo not working on a 2013 MBP
From: Andreas Heider <andreas@heider.io>
In-Reply-To: <CALkWK0=qTftgogUCyehi-zQWudYC0VTOUjEnSUQYWYv32+JENg@mail.gmail.com>
Date: Mon, 6 Jan 2014 22:44:50 +0100
Cc: LKML <linux-kernel@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <2E4F4157-2975-4A16-A0A3-EC5EADFED228@heider.io>
References: <CALkWK0=--MxTMTmdYzKotUfbctgc09rJ6R=9WB2XHTP-jnbz-A@mail.gmail.com> <D60EADB9-69D0-4B80-9FDD-5C0FE0C18F54@heider.io> <CALkWK0=qTftgogUCyehi-zQWudYC0VTOUjEnSUQYWYv32+JENg@mail.gmail.com>
To: Ramkumar Ramachandra <artagnon@gmail.com>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ram,

Am 06.01.2014 um 22:09 schrieb Ramkumar Ramachandra <artagnon@gmail.com>:

> Hi Andreas,
> 
> Andreas Heider wrote:
>> that means that something is still using the GPU, try DIGD or alternatively
>> shutting down your X-server before switching.
> 
> When I try DIGD, I get:
> 
>  vga_switcheroo: setting delayed switch to client 0
> 
> Then, when I shut down X, I get a blank screen.

That sounds like it works, maybe try it with an external monitor attached.
> 
> When I try IGN after shutting down X, I get the same message:
> 
>  vga_switcheroo: client 1 refused switch

Well, then something else is still using the GPU (or the audio device? But I think in that case the client id would be 101 or so).

> 
>> I think there are still some EDID issues because
>> https://lkml.org/lkml/2012/8/3/300 never got merged, so even after shutting
>> down X you might get a black screen, but it should hopefully work with
>> external displays.
> 
> The series is really old! Why is gmux in such a shabby state today,
> and more importantly: how do I get started hacking on it?
> 
> Thanks.
> 
> Ram

Well it is in this state for to the usual reasons.

But it’s great that you want to work on it! The gmux driver itself should already work fine, the reason for the black screen is that the i915 driver doesn’t handle the switch and after the switch still thinks it doesn’t have any monitors connected to it.

So a good way forward would be to first port the old patch series to the current kernel. The mode setting code in i915 has changed quite a bit, so this might take some effort. The original patch series did work on my MBP 6,2 about one and a half years ago so it should already be enough to get your hardware working.

Then, to really fix it, address the issues noted by Matthew and try to get the patches finally accepted.

I’m not familiar with the new mode setting code in i915 (or rather with i915 at all) so I can’t help you that much, but I’d be happy to test anything you come up with.

Cheers,
Andreas
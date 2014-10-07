Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaJGAGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 20:06:24 -0400
Received: from 216-12-86-13.cv.mvl.ntelos.net ([216.12.86.13]:59700 "EHLO
	brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbaJGAGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 20:06:23 -0400
Date: Mon, 6 Oct 2014 20:05:14 -0400
From: Rich Felker <dalias@libc.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Andy Lutomirski <luto@amacapital.net>, David Daney <ddaney.cavm@gmail.com>,
        libc-alpha@sourceware.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH resend] MIPS: Allow FPU emulator to use non-stack area.
Message-ID: <20141007000514.GD23797@brightrain.aerifal.cx>
References: <1412627010-4311-1-git-send-email-ddaney.cavm@gmail.com>
 <20141006205459.GZ23797@brightrain.aerifal.cx>
 <5433071B.4050606@caviumnetworks.com>
 <20141006213101.GA23797@brightrain.aerifal.cx>
 <54330D79.80102@caviumnetworks.com>
 <20141006215813.GB23797@brightrain.aerifal.cx>
 <543327E7.4020608@amacapital.net>
 <54332A64.5020605@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54332A64.5020605@caviumnetworks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 04:48:52PM -0700, David Daney wrote:
> On 10/06/2014 04:38 PM, Andy Lutomirski wrote:
> >On 10/06/2014 02:58 PM, Rich Felker wrote:
> >>On Mon, Oct 06, 2014 at 02:45:29PM -0700, David Daney wrote:
> [...]
> >>This is a huge ill-designed mess.
> >
> >Amen.
> >
> >Can the kernel not just emulate the instructions directly?
> 
> In theory it could, but since there can be implementation defined
> instructions, there is no way to achieve full instruction set
> coverage for all possible machines.

Is the issue really implementation-defined instructions with delay
slots? If so it sounds like a made-up issue. They're not going to
occur in real binaries. Certainly a compiler is not going to generate
implementation-defined instructions, and if you're writing the asm by
hand, you just don't put floating point instructions in the delay
slot.

Rich

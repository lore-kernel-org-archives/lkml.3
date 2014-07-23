Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbaGWIIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 04:08:07 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:44830 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaGWIIC convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Wed, 23 Jul 2014 04:08:02 -0400
Message-Id: <53CF897E0200007800024FB4@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Wed, 23 Jul 2014 09:07:58 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Andy Lutomirski" <luto@amacapital.net>, <mingo@elte.hu>,
        <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ix86: fix vDSO build
References: <53B5863B02000078000204D5@mail.emea.novell.com>
 <53BF1A94.50009@zytor.com>
In-Reply-To: <53BF1A94.50009@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 11.07.14 at 00:58, <hpa@zytor.com> wrote:
> On 07/03/2014 07:35 AM, Jan Beulich wrote:
>> Relying on static functions used just once to get inlined (and
>> subsequently have dead code paths eliminated) is wrong: Compilers are
>> free to decide whether they do this, regardless of optimization level.
>> With this not happening for vdso_addr() (observed with gcc 4.1.x), an
>> unresolved reference to align_vdso_addr() causes the build to fail.
> 
> The fix seems odd... more of the flavor of "happens to work" unless I'm
> misunderstanding something.  If this needs to be inlined, wouldn't
> __always_inline make more sense?
> 
> What am I missing?

I think this is a matter of taste: Personally I think __always_inline should
be used rather rarely, as it takes away decisions from the compiler that
it would (generally) be in the better position to make.

Sorry for the late reply (was on vacation),
Jan


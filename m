Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161599Ab3FUQnK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 12:43:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58063 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161570Ab3FUQnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 12:43:08 -0400
Message-ID: <51C4827B.7090208@zytor.com>
Date: Fri, 21 Jun 2013 09:42:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Ingo Molnar <mingo@kernel.org>, Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
References: <20130620170124.GA19877@pd.tnic> <20130620171210.GA26593@srcf.ucam.org> <20130620180808.GB19877@pd.tnic> <20130620181015.GA27833@srcf.ucam.org> <20130620181445.GA791@pd.tnic> <20130620181731.GA27960@srcf.ucam.org> <20130620184736.GC19877@pd.tnic> <51C383AC.4060706@zytor.com> <20130621072356.GA22006@pd.tnic> <ca8f8134-24d9-4f96-8876-e24892efc849@email.android.com> <20130621142101.GG22006@pd.tnic>
In-Reply-To: <20130621142101.GG22006@pd.tnic>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2013 07:21 AM, Borislav Petkov wrote:
> On Fri, Jun 21, 2013 at 03:05:30AM -0700, H. Peter Anvin wrote:
>> If you cap it you are basically imposing a constraint on the firmware
>> and may not run properly (or at least have to turn off EFI runtime
>> calls with all that implies.)
> 
> I don't want to cap EFI just for the fun of it but rather set a limit
> so that the next one who wants a chunk of the virtual address space can
> have a reliable limit from where she/he can start. Otherwise we won't
> know where EFI reliably ends...
> 

We don't... and I don't think there is anything we can do about it.  If
some messed-up firmware wants to map a terabyte we either refuse and
don't allow EFI runtime calls on that machine or we accept it.

Fortunately the space is extremely large and with growing down from a
known address it is less likely that we'll conflict with something.

>> It might be good to have a sanity check but it needs to be pretty
>> generous.
> 
> 64 Gb generous enough?

Let's start there and see if we run into something that gives us trouble.

	-hpa



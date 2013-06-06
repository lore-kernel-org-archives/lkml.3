Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab3FFTip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 15:38:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39674 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552Ab3FFTio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 15:38:44 -0400
Message-ID: <51B0E522.4070005@zytor.com>
Date: Thu, 06 Jun 2013 12:38:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Matt Fleming <matt@console-pimps.org>,
        Linux EFI <linux-efi@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 4/4] x86, efi: Map runtime services 1:1
References: <1370177770-26661-1-git-send-email-bp@alien8.de> <1370177770-26661-5-git-send-email-bp@alien8.de> <20130606131439.GI30420@console-pimps.org> <20130606132908.GE20972@pd.tnic> <20130606155822.GH20972@pd.tnic> <51B0E2D4.3040007@zytor.com> <20130606193612.GM20972@pd.tnic>
In-Reply-To: <20130606193612.GM20972@pd.tnic>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2013 12:36 PM, Borislav Petkov wrote:
> On Thu, Jun 06, 2013 at 12:28:20PM -0700, H. Peter Anvin wrote:
>> Or we could materialize mappings for this specific PGD. However,
>> adding a read of %cr3 in __do_page_fault sounds expensive.
> 
> Yes, I think we want to make sure all mappings are there when we do an
> EFI runtime call so that we never #PF while it executes.
> 
> Matt mentioned on IRC that the it could be that his EFI runtime is
> referencing EFI_RESERVED area which we don't map. However, we need to
> confirm/disprove that first, as it is currently only a hunch.

If it is true, then maybe a #PF handler which materializes mappings on
demand might be the right thing to do.

Again, it would be interesting to stop a WinX VM in the process of doing
an EFI call and see exactly what it has set up in its page tables.

	-hpa



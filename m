Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbaG3PFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 11:05:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36988 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbaG3PFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 11:05:45 -0400
Message-ID: <53D909C3.9050205@canonical.com>
Date: Wed, 30 Jul 2014 16:05:39 +0100
From: Colin Ian King <colin.king@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>, Borislav Petkov <bp@alien8.de>
CC: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
        lszubowi@redhat.com, Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH] x86, efi: print debug values in Kib not MB
References: <1406653761-3884-1-git-send-email-prarit@redhat.com> <20140729222932.GA17481@pd.tnic> <20140730144803.GB15082@console-pimps.org>
In-Reply-To: <20140730144803.GB15082@console-pimps.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/07/14 15:48, Matt Fleming wrote:
> On Wed, 30 Jul, at 12:29:32AM, Borislav Petkov wrote:
>> On Tue, Jul 29, 2014 at 01:09:21PM -0400, Prarit Bhargava wrote:
>>> The current debug print in EFI does
>>>
>>> [    0.000000] efi: mem84: type=3, attr=0xf, range=[0x00000000645b5000-0x00000000645fb000) (0MB)
>>>
>>> and rounds off the size to 0MB and isn't very useful.  We should print this in
>>> Kib.  After applying this patch we get better info with
>>>
>>> [    0.000000] efi: mem84: type=3, attr=0xf, range=[0x00000000645b5000-0x00000000645fb000) (280kiB)
>>
>> Turning this into kiB unconditionally won't always work ok:
>>
>> First of all, there might be something which parses that output so I'd
>> make sure I'm not breaking that. Maybe fwts... Matt will know.
> 
> I'm not aware of anything that parses the dmesg output, but I'm
> including Colin in case he has any insight.
> 
That won't break fwts.

Colin

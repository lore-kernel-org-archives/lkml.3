Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310Ab3DAWCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 18:02:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45985 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753929Ab3DAWCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 18:02:21 -0400
Message-ID: <515A03DB.6040107@zytor.com>
Date: Mon, 01 Apr 2013 15:02:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Vivek Goyal <vgoyal@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kexec: use Crash kernel for Crash kernel low
References: <20130320163131.GE2273@redhat.com> <1363807329-24975-1-git-send-email-yinghai@kernel.org> <20130325194245.GA7357@redhat.com> <CAE9FiQU6bGSAODX_-Vir6D-LyY-9Sm84rYzq=gNhDZ5whbia_w@mail.gmail.com> <20130326181418.GA6775@redhat.com> <20130401133428.GA13499@redhat.com> <5159D2E9.7080707@zytor.com> <20130401192606.GA17951@redhat.com> <5159F27E.7060300@zytor.com> <CAE9FiQXikU8-FkYYULHx50qP_ME2bRSzCC=8ZH8iDyUr2ug66g@mail.gmail.com>
In-Reply-To: <CAE9FiQXikU8-FkYYULHx50qP_ME2bRSzCC=8ZH8iDyUr2ug66g@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2013 02:10 PM, Yinghai Lu wrote:
> On Mon, Apr 1, 2013 at 1:47 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 04/01/2013 12:26 PM, Vivek Goyal wrote:
>>
>>> crashkernel=<size>,<option>,<option>.. and crashkernel=800M,high sound
>>> good to me.
>>>
>>> So atleast for 3.9 kernel, shall we hide new semantics behind
>>> crashkernel=XM,high and by default crashkernel=XM tries to emulate
>>> crashkernel=XM,low to retain backward compatibility?
>>
>> Yes, I suspect so.
> 
> current we have:
> 1. crashkernel=XM
> 2. crashkernel=XM crashkernel_low=YM
> 
> so you want to change to
> 1. crashkernel=XM,low or crashkernel=XM
> 2. crashkernel=XM,high
> 3. crashkernel=XM,high crashkernel=YM,low
> 
> looks like you change your mind, now you are agreeing on
> some could low and some could be high.
> 

It sounds that the "never DMA'd to memory" notion requires that we have
some low memory for the iommu, no?

Or am I misunderstanding what you are asking here?

	-hpa



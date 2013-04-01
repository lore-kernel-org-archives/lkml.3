Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715Ab3DAWRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 18:17:09 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:64338 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758077Ab3DAWRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 18:17:07 -0400
MIME-Version: 1.0
In-Reply-To: <515A03DB.6040107@zytor.com>
References: <20130320163131.GE2273@redhat.com>
	<1363807329-24975-1-git-send-email-yinghai@kernel.org>
	<20130325194245.GA7357@redhat.com>
	<CAE9FiQU6bGSAODX_-Vir6D-LyY-9Sm84rYzq=gNhDZ5whbia_w@mail.gmail.com>
	<20130326181418.GA6775@redhat.com>
	<20130401133428.GA13499@redhat.com>
	<5159D2E9.7080707@zytor.com>
	<20130401192606.GA17951@redhat.com>
	<5159F27E.7060300@zytor.com>
	<CAE9FiQXikU8-FkYYULHx50qP_ME2bRSzCC=8ZH8iDyUr2ug66g@mail.gmail.com>
	<515A03DB.6040107@zytor.com>
Date: Mon, 1 Apr 2013 15:17:06 -0700
X-Google-Sender-Auth: goYEqrIhbRmhljtUMgfoelpzYHI
Message-ID: <CAE9FiQWNFbFgXafJBvORRax+GNU_uf0KFnqZ5NQit0BeZZx9LA@mail.gmail.com>
Subject: Re: [PATCH] kexec: use Crash kernel for Crash kernel low
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 1, 2013 at 3:02 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/01/2013 02:10 PM, Yinghai Lu wrote:
>> On Mon, Apr 1, 2013 at 1:47 PM, H. Peter Anvin <hpa@zytor.com> wrote:

> It sounds that the "never DMA'd to memory" notion requires that we have
> some low memory for the iommu, no?
>
> Or am I misunderstanding what you are asking here?

No. just find where to put second kernel.

When vivek raise the problem at beginning, he suggested
1. try 896M under at first, if it fails, will allocate under 4G, and
if it still fail
    try above 4G.
2. or keep crashkernel=XM, only to low, and add crashkernel_high if someone
    really want it to be high.

and then you said, we should keep consistent to keep all above 4G.

Now Vivek says we should use crashkernel=XM,low and crashkernel=XM,high
, also crashkernel=XM is treated as low.

And his last suggestion is just as his old second suggestion.

I just check the code again, it looks it is easy to change it to support:
1. crashkernel=XM
2. crashkernel_high=XM
3. crashkernel_high=XM crashkernel_low=YM

Yinghai

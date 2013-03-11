Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab3CKS6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 14:58:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44839 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491Ab3CKS6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 14:58:10 -0400
Message-ID: <513E28B8.3000502@zytor.com>
Date: Mon, 11 Mar 2013 11:55:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Vivek Goyal <vgoyal@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
References: <513D52BA.3070206@redhat.com> <1362977817-23297-1-git-send-email-yinghai@kernel.org> <20130311144853.GB8482@redhat.com> <20130311150256.GC8482@redhat.com> <CAE9FiQW1CHJ-j9aFgdtKEsgyZSTHTS1HzgMSGM8FnV7Ns3kUvw@mail.gmail.com> <20130311182655.GB12107@redhat.com> <513E2695.3080707@zytor.com> <CAE9FiQXLodhSFy4T9pKLMS+axF0jHGL9B0+TL=dYOFrLVudN9g@mail.gmail.com>
In-Reply-To: <CAE9FiQXLodhSFy4T9pKLMS+axF0jHGL9B0+TL=dYOFrLVudN9g@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2013 11:50 AM, Yinghai Lu wrote:
>>
>> What is the purpose of reserving that kind of memory below 896 MB?  If
>> you have a 32-bit system, it will likely be useless since you are
>> robbing the primary of most of lowmem, on a 64-bit system 896 MB is not
>> a magic value in any way...?
> 
> We did not touch 32 bit system.
> 
> Do you mean that we should
> For 64bit, we should try under 4G, and then try MAXMEM
> instead of try under 896M, then 4G, and MAXMEM?
> 
> Try 896M at first, we will let user to avoid updating their kexec-tools.
> 

Are you saying 896M is somehow hardcoded into kexec-tools?

I actually disagree with trying low memory at all.  Push kdump as high
into the memory range as we can go, if there is a performance penalty it
is much better to take it in the kdump kernel.

All the voodoo to try to keep people from updating kexec-tools is
disturbing; although breaking userspace is bad, updating kexec-tools is
probably easier than updating the kernel, and carrying the voodoo on
indefinitely has serious consequences.

	-hpa



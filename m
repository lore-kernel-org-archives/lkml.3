Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab3CKT6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:58:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45533 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab3CKT6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:58:16 -0400
Message-ID: <513E36CB.5040908@zytor.com>
Date: Mon, 11 Mar 2013 12:55:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
References: <513D52BA.3070206@redhat.com> <1362977817-23297-1-git-send-email-yinghai@kernel.org> <20130311144853.GB8482@redhat.com> <20130311150256.GC8482@redhat.com> <CAE9FiQW1CHJ-j9aFgdtKEsgyZSTHTS1HzgMSGM8FnV7Ns3kUvw@mail.gmail.com> <20130311182655.GB12107@redhat.com> <513E2695.3080707@zytor.com> <CAE9FiQXLodhSFy4T9pKLMS+axF0jHGL9B0+TL=dYOFrLVudN9g@mail.gmail.com> <513E28B8.3000502@zytor.com> <CAE9FiQW-gpEMmc6kseb7E+TEg1F9CqEYZBRDiJ3bDY=t6zGRmg@mail.gmail.com> <20130311192021.GF12107@redhat.com>
In-Reply-To: <20130311192021.GF12107@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2013 12:20 PM, Vivek Goyal wrote:
> 
> I find it odd that if a user wants to load a 32bit kernel or use 32bit
> entry point then he needs to first reboot the kernel and re-reserve
> the memory.
> 
> At installation time, one does not necessarily know what kind of kernel
> will be used for crashdump. So reserving as high as possible limits
> the choices.
> 
> I would rather prefer that user opt in for higher addresses instead of
> these being reserved by default.
> 

Quite frankly the whole design seems to be held together with chewing
gum.  At the core, the problem is a tight coupling between kexec-tools
version, kexec-tools options, and kernel command line options that have
to be combined in very ugly ways.  Part of the reason is that the kernel
isn't actually given the information it needs to do the job required.

As far as "if a user wants to load"... why on Earth should that be the
default?  How could that *not* be an exceptional case?

	-hpa



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab3CKUjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:39:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45907 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336Ab3CKUjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:39:11 -0400
Message-ID: <513E4064.7090501@zytor.com>
Date: Mon, 11 Mar 2013 13:36:52 -0700
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
References: <20130311144853.GB8482@redhat.com> <20130311150256.GC8482@redhat.com> <CAE9FiQW1CHJ-j9aFgdtKEsgyZSTHTS1HzgMSGM8FnV7Ns3kUvw@mail.gmail.com> <20130311182655.GB12107@redhat.com> <513E2695.3080707@zytor.com> <CAE9FiQXLodhSFy4T9pKLMS+axF0jHGL9B0+TL=dYOFrLVudN9g@mail.gmail.com> <513E28B8.3000502@zytor.com> <CAE9FiQW-gpEMmc6kseb7E+TEg1F9CqEYZBRDiJ3bDY=t6zGRmg@mail.gmail.com> <20130311192021.GF12107@redhat.com> <513E36CB.5040908@zytor.com> <20130311201245.GC14738@redhat.com> <513E3C44.9030402@zytor.com>
In-Reply-To: <513E3C44.9030402@zytor.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2013 01:19 PM, H. Peter Anvin wrote:
> 
> The problem with this argument here is that we are spiraling down the
> drain of increasing user-visible complexity in order to not break
> existing but exotic use cases.  We need to stop and reverse this trend.
>  I want to make a few observations on this:
> 
> 1. Running with an archaic kexec-tools should be considered an anomaly.
>  If necessary, we could introduce a kernel option to let the kernel know
> which kexec-tools version the user will use.
> 
> 2. As long as memory is available, there is always the option to shift
> memory around to accommodate the crashkernel.  That probably should have
> been done all along.
> 
> 3. The memory size reserved should be deduced automatically to the
> greatest possible extent.
> 

The really big picture problem here is that the host kernel is expected
to predict at boot time what will happen in the future: what are the
requirements of the kdump kernel, and its tools, which hasn't been
loaded yet?

Can we get past that as a fundamental problem?

	-hpa


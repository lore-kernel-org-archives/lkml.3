Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab3KMXJD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 18:09:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57386 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166Ab3KMXIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 18:08:53 -0500
Message-ID: <52840666.5070800@zytor.com>
Date: Wed, 13 Nov 2013 15:08:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Kexec Mailing List <kexec@lists.infradead.org>,
        Baoquan He <bhe@redhat.com>, WANG Chao <chaowang@redhat.com>,
        Dave Young <dyoung@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: /proc/vmcore mmap() failure issue
References: <20131113204130.GD7613@redhat.com> <20131113210432.GE7613@redhat.com> <5283EBCD.6070305@zytor.com> <20131113224104.GF7613@redhat.com> <528400DD.3040003@zytor.com> <20131113230056.GA19663@redhat.com>
In-Reply-To: <20131113230056.GA19663@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2013 03:00 PM, Vivek Goyal wrote:
> I think it should be easy to truncate ELF headers in kexec-tools too when
> we are preparing elf headers. I am not sure if it is right thing to do or
> not. If some entry is showing up in /proc/iomem as RAM, then kexec-tools
> need to believe that it is a possibility that kernel is using that pfn and
> that pfn needs to be dumped out in vmcore. IMHO, kernel should fix this
> issue.

The kernel will never use a fractional page, so that is not an issue.

> Secondly, I am writing in-kernel kexec support too and I prepare ELF
> headers there too. And I am facing the same problem there too. So if
> we truncate partial pages in e820 both kexec-tools and in kernel kexec
> implementation don't have to do anything.

I'm mostly worried about truncation upon truncation causing problems.
As long as the trimming is done once and with proper consideration for
abutting regions, I guess I'm okay with it, although it feels wrong to me.

	-hpa


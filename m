Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab3CKTHR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:07:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45082 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636Ab3CKTHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:07:15 -0400
Message-ID: <513E2AC6.1000707@zytor.com>
Date: Mon, 11 Mar 2013 12:04:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
References: <513D52BA.3070206@redhat.com> <1362977817-23297-1-git-send-email-yinghai@kernel.org> <20130311144853.GB8482@redhat.com> <20130311150256.GC8482@redhat.com> <CAE9FiQW1CHJ-j9aFgdtKEsgyZSTHTS1HzgMSGM8FnV7Ns3kUvw@mail.gmail.com> <20130311182655.GB12107@redhat.com> <513E2695.3080707@zytor.com> <20130311190242.GC12107@redhat.com>
In-Reply-To: <20130311190242.GC12107@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2013 12:02 PM, Vivek Goyal wrote:
>>
>> What is the purpose of reserving that kind of memory below 896 MB?  If
>> you have a 32-bit system, it will likely be useless since you are
>> robbing the primary of most of lowmem, on a 64-bit system 896 MB is not
>> a magic value in any way...?
> 
> Actually I am not sure where did 896MB magic value had come from for
> x86_64 so far. I assumed that it was some kexec-tools limitation so
> first trying 896MB will preserve working with old kexec-tools. If it
> was some kernel limitation, then I agree it should not be required anymore.
> 
> I do remember that old pugatory had 2G limit. So may be we can first
> try reserve with-in first 2G, then with-in first 4G and then above
> 4G. (Assuming 896M was not kexec-tools limitation and had something
> to do with kernel/initramfs).
> 

It is obvious where it *originated* from... it is the *default* (but not
necessarily the actual!) HIGHMEM crossover point on x86-32.

Whether this limitation has crept into somewhere else is a good question.

	-hpa


